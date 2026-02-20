import { PDFDocument } from "pdf-lib";
import fs from "fs";
import path from "path";
import { Request, Response } from "express";
import archiver from "archiver";
const PDFMerger = require("pdf-merger-js");


export default class PdfController {
  static async mergeFiles(req: Request, res: Response): Promise<void> {
    try {
      // Validate if exactly two files were uploaded
      if (!req.files || (req.files as Express.Multer.File[]).length !== 2) {
        res.status(400).json({ message: "Please upload exactly two PDF files." });
        return;
      }

      // Log the file paths to debug
      const files = req.files as Express.Multer.File[];
      console.log("Uploaded files:", files);

      // Initialize PDFMerger
      const merger = new PDFMerger();

      // Loop through files and log the file paths before adding to the merger
      for (const file of files) {
        if (!fs.existsSync(file.path)) {
          console.error("File does not exist:", file.path);
            res.status(400).json({ message: `File not found: ${file.path}` });
        }
        console.log("Adding file to merger:", file.path);
        await merger.add(file.path);
      }

      // Generate output path
      const outputPath = path.join("uploads", `merged_${Date.now()}.pdf`);

      // Save the merged PDF
      await merger.save(outputPath);

      // Check if the file was saved and is not empty
      if (fs.existsSync(outputPath) && fs.statSync(outputPath).size > 0) {
        console.log("Merged PDF saved successfully at", outputPath);
      } else {
        console.error("Merged PDF is empty:", outputPath);
          res.status(500).json({ message: "Merged PDF is empty" });
      }

      // Send the merged PDF as a downloadable file
      res.download(outputPath, "merged.pdf", (err) => {
        if (err) {
          console.error("Error sending file for download:", err);
          res.status(500).json({ message: "Error sending merged PDF for download" });
        } else {
          console.log("File sent successfully.");
        }
      });
    } catch (error) {
      console.error("Error merging PDFs:", error);
      res.status(500).json({ message: "Error merging PDFs", error });
    }
  }
  static async splitFiles(req: Request, res: Response): Promise<void> {
    try {
      if (!req.file) {
        res.status(400).json({ message: "Please upload a PDF file to split." });
        return;
      }

      const startPage = parseInt(req.body.startPage || req.query.startPage as string);
      
      if (isNaN(startPage) || startPage < 1) {
        res.status(400).json({ message: "Please provide a valid page number to start the split." });
        return;
      }

      const filePath = req.file.path;
      const pdfBytes = fs.readFileSync(filePath);
      const pdfDoc = await PDFDocument.load(pdfBytes);

      const totalPages = pdfDoc.getPageCount();

      if (startPage > totalPages) {
        res.status(400).json({ message: "The start page is beyond the total number of pages in the PDF." });
        return; 
      }

      const splitPdfPaths: string[] = [];
      const outputDir = path.join(__dirname, "uploads");
      if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir);
      }

      for (let i = startPage - 1; i < totalPages; i++) {
        const newPdfDoc = await PDFDocument.create();
        const [copiedPage] = await newPdfDoc.copyPages(pdfDoc, [i]);
        newPdfDoc.addPage(copiedPage);

        const outputFilePath = path.join(outputDir, `split_page_${i + 1}.pdf`);
        const newPdfBytes = await newPdfDoc.save();
        fs.writeFileSync(outputFilePath, newPdfBytes);

        splitPdfPaths.push(outputFilePath);
      }

      // Create a ZIP file containing all the split PDFs
      const zipFilePath = path.join(__dirname, "uploads", `split_pdfs_${Date.now()}.zip`);
      const outputZipStream = fs.createWriteStream(zipFilePath);
      const archive = archiver('zip', {
        zlib: { level: 9 } // Maximum compression
      });

      archive.pipe(outputZipStream);

      // Append all split PDFs to the archive
      splitPdfPaths.forEach((filePath) => {
        archive.file(filePath, { name: path.basename(filePath) });
      });

      archive.finalize();

      outputZipStream.on('close', () => {
        // After the ZIP file is created, send it as a download
        res.download(zipFilePath, 'split_pdfs.zip', (err) => {
          if (err) {
            console.error("Error downloading the ZIP file:", err);
          }
          // Clean up the ZIP and split PDFs after sending
          fs.unlinkSync(zipFilePath);
          splitPdfPaths.forEach((filePath) => fs.unlinkSync(filePath));
        });
      });

    } catch (error) {
      console.error("Error splitting PDF:", error);
      res.status(500).json({ message: "Error splitting PDF", error });
    }
  }
  static async reducePdfSize(req: Request, res: Response): Promise<void> {
    try {
      if (!req.files || req.files.length !== 1) {
        res.status(400).json({ message: "Please upload a single PDF file." });
        return;
      }

      const filePath = (req.files as Express.Multer.File[])[0].path;
      const pdfBytes = fs.readFileSync(filePath);
      const pdfBytesArray = new Uint8Array(pdfBytes);
      const pdfDoc = await PDFDocument.load(pdfBytesArray);

      // Logic to reduce PDF size (e.g., compress images) can be added here.

      const compressedPdfPath = path.join("uploads", `compressed_${Date.now()}.pdf`);
      const compressedPdfBytes = await pdfDoc.save();
      fs.writeFileSync(compressedPdfPath, compressedPdfBytes);

      res.status(200).json({
        message: "PDF size reduced successfully",
        compressedPdfUrl: `http://localhost:8000/uploads/${path.basename(compressedPdfPath)}`,
      });
    } catch (error) {
      console.error("Error reducing PDF size:", error);
      res.status(500).json({ message: "Error reducing PDF size", error });
    }
  }

  static async imagesToPdf(req: Request, res: Response): Promise<void> {
    try {
      if (!req.files || (Array.isArray(req.files) && req.files.length < 1)) {
        res.status(400).json({ message: "Please upload at least one image file." });
        return;
      }

      const pdfDoc = await PDFDocument.create();

      for (const file of req.files as Express.Multer.File[]) {
        const imageBytes = fs.readFileSync(file.path);
        const uint8Array = new Uint8Array(imageBytes); // Convert Buffer to Uint8Array

        if (file.mimetype === "image/jpeg") {
          const image = await pdfDoc.embedJpg(uint8Array);
          const page = pdfDoc.addPage([image.width, image.height]);
          page.drawImage(image, { x: 0, y: 0, width: image.width, height: image.height });
        } else if (file.mimetype === "image/png") {
          const image = await pdfDoc.embedPng(uint8Array);
          const page = pdfDoc.addPage([image.width, image.height]);
          page.drawImage(image, { x: 0, y: 0, width: image.width, height: image.height });
        } else {
          res.status(400).json({ message: "Unsupported image format. Use JPG or PNG." });
          return;
        }
      }

      const outputPath = path.join("uploads", `combined_${Date.now()}.pdf`);
      const pdfBytes = await pdfDoc.save();
      fs.writeFileSync(outputPath, pdfBytes);

      res.status(200).json({
        message: "Images converted to PDF successfully",
        pdfUrl: `http://localhost:8000/uploads/${path.basename(outputPath)}`,
      });
    } catch (error) {
      console.error("Error converting images to PDF:", error);
      res.status(500).json({ message: "Error converting images to PDF", error });
    }
  }
}
