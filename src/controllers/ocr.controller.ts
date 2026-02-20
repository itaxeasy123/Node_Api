// import axios, { AxiosRequestConfig } from "axios";
// import { NextFunction, Request, Response } from "express";
// import { uploadOnCloudinary } from "../lib/cloudinary";
// import { join } from 'path';
// import { cwd } from "process";
// import Tesseract from "tesseract.js"
// import sharp from "sharp";

// const tessDataPath = join(cwd(), 'data');

// const TESSERACT_CONFIG :any = {
//     tessedit_char_whitelist: '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
//     tessdata: tessDataPath,
//     psm: Tesseract.PSM.SINGLE_LINE
// };

// const PAN_PATTERN = /\b[A-Z]{5}[0-9]{4}[A-Z]{1}\b/;

// const DOB_PATTERN = /\b\d{2}\/\d{2}\/\d{4}\b/;

// const NAME_RGX = /\bName\b/i;

// const NAME_EXT_RGX = /([A-Z]{2,})(?:\s+[A-Z]{1,}){0,2}/;

// const FATHER_NAME_RGX = /\bFather's Name\b/i;

// function extractPanDetails(lines:any) {
//   let extractedInfo = {
//     name: "",
//     fatherName: "",
//     dob: "",
//     pan: ""
//   };

//   for (let i = 0; i < lines.length; i++) {
//     const line = lines[i];

//     const dobMatch = line.match(DOB_PATTERN);
//     if (FATHER_NAME_RGX.test(line)) {
//         extractedInfo.fatherName = lines[i + 1].match(NAME_EXT_RGX)[0];
//     } else if (NAME_RGX.test(line)) {
//         extractedInfo.name = lines[i + 1].match(NAME_EXT_RGX)[0];
//     } else if (dobMatch) {
//         extractedInfo.dob = dobMatch[0];
//     } else {
//       const panMatch = line.match(PAN_PATTERN);
//       if (panMatch) {
//         extractedInfo.pan = panMatch[0];
//       }
//     }
//   }

//   return extractedInfo;
// }

// export default class OcrController {

//   //  static async  UploadpanOCR(req: Request, res: Response) {
//   //   try {
//   //     const panLocalPath =  req?.file?.path;

//   //     if (!panLocalPath) {
//   //       return res.status(400).json({ message: 'PAN card image not provided' });
//   //     }

//   //     const panImage = await uploadOnCloudinary(panLocalPath);

//   //     if (!panImage?.url) {
//   //       return res.status(500).json({ message: 'Failed to upload image to Cloudinary' });
//   //     }

//   //     console.log('Cloudinary URL:', panImage?.url);

//   //     const options = {
//   //       method: 'POST',
//   //       url: 'https://india-pan-card-ocr.p.rapidapi.com/v3/tasks/sync/extract/ind_pan',
//   //       headers: {
//   //         'content-type': 'application/json',
//   //         'X-RapidAPI-Key': '8645245108msh6e1a703464669a8p1b2dcbjsn88ae327b7073',
//   //         'X-RapidAPI-Host': 'india-pan-card-ocr.p.rapidapi.com'
//   //       },
//   //       data: {
//   //         task_id:125,
//   //         group_id: 125,
//   //         data: {
//   //           document1: panImage?.url
//   //         }
//   //       }
//   //     };

//   //     const response = await axios.request(options);

//   //     console.log("RES",response);

//   //     return res.status(201).json({ message: 'Successfully fetched data', data: response.data });
//   //   } catch (error) {
//   //     return res.status(500).json({ message: 'Internal server error' });
//   //   }
//   // }

// //   static async Getuploadpandata (req: Request, res: Response){

// //     const requestId= req.params.id

// //     const options = {
// //      method: 'GET',
// //      url: 'https://india-pan-card-ocr.p.rapidapi.com/v3/tasks',
// //       params: {
// //       request_id: requestId
// //     },
// //     headers: {
// //       'X-RapidAPI-Key': '8645245108msh6e1a703464669a8p1b2dcbjsn88ae327b7073',
// //       'X-RapidAPI-Host': 'india-pan-card-ocr.p.rapidapi.com'
// //     }
// // };

// //    try {
// // 	const response = await axios.request(options);
// //     return res.status(200).json({success:true,message:"Successfully fetched data",data:response.data});
// //    } catch (error) {
// //     return res.status(200).json({success: false, message:"internal error", error});
// //    }
// //     }

// static async getpandata(req: any, res: any){
//   try {
//     const image = sharp(req.file.path);

//     let outputBuffer:any = await image
//         .greyscale()
//         .linear(1.0, -25)
//         .toBuffer();

//     const result = await Tesseract
//     .recognize(outputBuffer, 'eng', TESSERACT_CONFIG);

//     const lines = result.data.text
//         .split('\n')
//         .map((line) => line.trim())
//         .filter((line) => line);
//     const data = extractPanDetails(lines);
//     if(data.name===""||data.pan===""){
//       return res.status(404)
//       .json({message:"faild to extract data or  upload a valid pan card "})
//     }
//     return res.status(200)
//     .send({ status: 'success', data });
// } catch(e) {
//     res.status(500).send({
//         status: 'failure',
//         message: 'Something went wrong',
//     });
// }
// }

// }

import { Request, Response } from "express";
import sharp from "sharp";
import { createWorker } from "tesseract.js";
import { extractAadhaarData, extractPanData } from "../lib/ocrExtract";

async function preprocessImage(imagePath: string): Promise<Buffer> {
  try {
    const image = await sharp(imagePath)
      .grayscale()
      .resize({ width: 1000 })
      .toBuffer();
    return image;
  } catch (error) {
    console.error("Error during image preprocessing:", error);
    throw error;
  }
}

async function performOCR(imageBuffer: Buffer): Promise<string> {
  const worker = await createWorker("eng");

  const {
    data: { text },
  } = await worker.recognize(imageBuffer);

  await worker.terminate();
  return text;
}

export interface AadhaarData {
  AadhaarNumber?: string;
  Name?: string;
  DateOfBirth?: string;
  Gender?: string;
}

export interface PanData {
  PAN?: string;
  Name?: string;
  "Father's Name"?: string;
  "Date of Birth"?: string;
}

const ocrPost = async (req: Request, res: Response) => {
  try {
    const data: { pan?: PanData | null; aadhaar?: AadhaarData | null } = {};
    const query = req.query;
    const filePath = req.file?.path;
    if (!filePath) {
      return res.status(400).json({ status: false, error: "No file uploaded" });
    }

    // Preprocess the image
    const processedImage = await preprocessImage(filePath);

    // Perform OCR
    const ocrText = await performOCR(processedImage);

    // Extract PAN data
    if (query.type) {
      if (query.type === "aadhaar") {
        const aadharData = extractAadhaarData(ocrText);
        data["aadhaar"] = aadharData;
      } else if (query.type === "pan") {
        const panData = extractPanData(ocrText.split("\n"));
        data["pan"] = panData;
      }
    } else {
      return res.status(400).json({ status: false, error: "Invalid type" });
    }

    return res.json({
      status: true,
      data,
    });
  } catch (error) {
    console.error("Error during processing:", error);
    return res.status(500).json({ status: false, error: "Processing failed" });
  }
};

export default { ocrPost };
