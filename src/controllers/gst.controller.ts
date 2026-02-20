import fs from 'fs';
import path from 'path';
import { Request, Response } from 'express';

const ratesFilePath = path.join(__dirname, '..', 'data', 'gstrates.json');

export default class GstController {
  // Method to get GST rates
  public static getGSTRate(req: Request, res: Response): void {
    const { rate } = req.params; // Get the GST rate from URL parameters

    // Read the gstrates.json file
    fs.readFile(ratesFilePath, 'utf8', (err, data) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: 'Error reading GST rates file',
          error: err.message,
        });
      }

      try {
        const gstRatesData = JSON.parse(data); // Parse the JSON data
        const gstRates = gstRatesData.GST_Rates; // Extract the GST_Rates object

        // Normalize the rate to match keys in GST_Rates
        const rateKey = `${rate}%`.trim();

        // Check if the requested rate exists
        if (!gstRates[rateKey]) {
          return res.status(404).json({
            success: false,
            message: `GST rate ${rate}% not found. Available rates: ${Object.keys(gstRates).join(', ')}`,
          });
        }

        // Respond with the items under the requested GST rate
        return res.status(200).json({
          success: true,
          gstRate: rateKey,
          items: gstRates[rateKey],
        });
      } catch (parseError) {
        return res.status(500).json({
          success: false,
          message: 'Error parsing GST rates file',
          error: (parseError as Error).message,
        });
      }
    });
  }
  
  public static getAllGSTRates(req: Request, res: Response): void {
    // Read the gstrates.json file
    fs.readFile(ratesFilePath, 'utf8', (err, data) => {
      if (err) {
        // Handle file read error
        return res.status(500).json({
          success: false,
          message: 'Error reading GST rates file',
          error: err.message,
        });
      }

      try {
        const gstRates = JSON.parse(data); // Parse the JSON data

        // Respond with all GST rates and items
        const formattedRates = Object.keys(gstRates).map((rate) => ({
          gstRate: rate,
          items: gstRates[rate],
        }));

        return res.status(200).json({
          success: true,
          gstRates: formattedRates,
        });
      } catch (parseError) {
        // Handle JSON parsing errors
        return res.status(500).json({
          success: false,
          message: 'Error parsing GST rates file',
          error: (parseError as Error).message,
        });
      }
    });
}
}