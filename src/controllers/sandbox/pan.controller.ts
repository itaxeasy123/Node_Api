import { Request, Response } from "express";
import Sandbox from "../../services/sandbox.service";
import axios from "axios";

export default class PanController {

    static async getAdvancePanDetails(req: Request, res: Response) {
        try {
            const { pan, name_as_per_pan, date_of_birth } = req.body;
    
            // Validate Required Parameters
if (!pan || !/^[A-Z]{3}[ABCFGHLJPT]{1}[A-Z]{1}[0-9]{4}[A-Z]{1}$/.test(pan)) {
    return res.status(400).json({
        success: false,
        message: "Enter a valid PAN Number (e.g., ABCDE1234F)."
    });
}

    
            if (!name_as_per_pan) {
                return res.status(400).json({
                    success: false,
                    message: "Name as per PAN is required."
                });
            }
    
            if (!date_of_birth || !/^\d{2}\/\d{2}\/\d{4}$/.test(date_of_birth)) {
                return res.status(400).json({
                    success: false,
                    message: "Date of Birth is required in DD/MM/YYYY format."
                });
            }
    
            const endpoint = `${Sandbox.BASE_URL}/kyc/pan/verify`;
    
            // Generate Access Token
            const token = await Sandbox.generateAccessToken();
    
            // Set headers for the request
            const headers = {
                Authorization: token,
                accept: 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };
    
            // Make the POST request with the required body parameters
            const response = await axios.post(
                endpoint,
                { 
                    "@entity": "in.co.sandbox.kyc.pan_verification.request", // Ensure the property matches API expectations
                    pan,
                    name_as_per_pan,
                    date_of_birth,
                    consent :"Y",
                    reason :"For KYC of User sqsqddqd dq"
                },
                { headers }
            );
    
            const { status, data } = response;
    
            // Handle non-200 status codes
            if (status !== 200) {
                return res.status(500).json({
                    success: false,
                    message: "Failed to verify PAN details.",
                    apiResponse: data,
                });
            }
    
            // Respond with the API data
            return res.status(200).json({
                success: true,
                data: data.data,
                message: "PAN details verified successfully.",
            });
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                success: false,
                message: "An unexpected error occurred. Please try again later.",
            });
        }
    }
    

}