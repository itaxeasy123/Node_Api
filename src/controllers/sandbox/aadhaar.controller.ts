import { Request, Response } from "express";
import Sandbox from "../../services/sandbox.service";
import axios from "axios";

export default class AadhaarController {
    static async aadharGenerateOtp(req: Request, res: Response) {
        try {
          const { aadhaar } = req.body;
    
          // Validate the `aadhaar_number` field
          if (!aadhaar) {
            return res
              .status(400)
              .json({ success: false, message: "Body parameter 'aadhaar_number' is required" });
          }
    
          // Endpoint for generating OTP
          const endpoint = `${Sandbox.BASE_URL}/kyc/aadhaar/okyc/otp`;
    
          // Generate access token
          const token = await Sandbox.generateAccessToken();
    
          // Headers for the request
          const headers = {
            Authorization: token,
            Accept: "application/json",
            "x-api-key": process.env.SANDBOX_KEY,
            "x-api-version": process.env.SANDBOX_API_VERSION,
          };
    
          // Prepare the request body
          const body = {
            aadhaar_number:aadhaar,
            "@entity": "in.co.sandbox.kyc.aadhaar.okyc.otp.request",
            consent: "y",
            reason: "For KYC of User",
          };
    
          // Make the POST request to generate OTP
          const { status, data } = await axios.post(endpoint, body, { headers });
    
          // Handle non-200 status responses
          if (status !== 200) {
            return res.status(500).send({ success: false, message: "Something went wrong" });
          }
    
          // Return success response
          return res.status(200).json({ success: true, data });
        } catch (e) {
          console.error("Error generating Aadhaar OTP:", e);
          return res
            .status(500)
            .json({ success: false, message: "Something went wrong" });
        }
      }
    
static async aadhaarVerifyOtp(req: Request, res: Response) {
    try {
        const { otp, reference_id } = req.body;
        
        // Debug: Log what we received
        console.log('Received request body:', req.body);
        console.log('Extracted otp:', otp, 'type:', typeof otp);
        console.log('Extracted reference_id:', reference_id, 'type:', typeof reference_id);
        
        if (!otp) {
            return res.status(400).json({ 
                success: false, 
                message: 'Body parameter otp was not provided' 
            });
        }
        
        if (!reference_id) {
            return res.status(400).json({ 
                success: false, 
                message: 'Body parameter reference_id was not provided' 
            });
        }

        const endpoint = `${Sandbox.BASE_URL}/kyc/aadhaar/okyc/otp/verify`;
        const token = await Sandbox.generateAccessToken();

        const headers = {
            'Authorization': token,
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'x-api-key': process.env.SANDBOX_KEY,
            'x-api-version': process.env.SANDBOX_API_VERSION
        };

        const body = {
            otp: String(otp).trim(), // Ensure it's a string and trim whitespace
            reference_id: String(reference_id).trim(),
            "@entity": "in.co.sandbox.kyc.aadhaar.okyc.request"
        };

        // Debug: Log everything being sent
        console.log('=== API REQUEST DEBUG ===');
        console.log('Endpoint:', endpoint);
        console.log('Headers:', JSON.stringify(headers, null, 2));
        console.log('Body:', JSON.stringify(body, null, 2));
        console.log('Body size:', JSON.stringify(body).length);
        console.log('========================');

        const response = await axios.post(endpoint, body, { headers });

        return res.status(200).json({ 
            success: true, 
            message: `OTP verification successful!`,
            data: response.data
        });

    } catch (error) {
        console.error('=== ERROR DEBUG ===');
        console.error('Full error:', error);
        
        if (axios.isAxiosError(error)) {
            console.error('Axios error response:', error.response?.data);
            console.error('Axios error status:', error.response?.status);
            console.error('Axios error headers:', error.response?.headers);
            
            return res.status(error.response?.status || 500).json({
                success: false,
                message: error.response?.data?.message || error.response?.data || 'OTP verification failed',
                debug: error.response?.data // Include full error response for debugging
            });
        }
        
        return res.status(500).json({
            success: false,
            message: 'Something went wrong during verification'
        });
    }
}
   
    static async verifyAadhaar(req: Request, res: Response) {
        try {
          const { aadhaar_number, otp, reference_id } = req.body;
    
          // Validate required fields
          if (!aadhaar_number || !otp || !reference_id) {
            return res.status(400).json({
              success: false,
              message: "Missing required fields: 'aadhaar_number', 'otp', or 'reference_id'",
            });
          }
    
          // Endpoint for verifying Aadhaar OTP
          const endpoint = `${Sandbox.BASE_URL}/kyc/aadhaar/okyc/otp/verify`;
    
          // Generate access token
          const token = await Sandbox.generateAccessToken();
    
          // Request headers  
          const headers = {
            Authorization: token,
            Accept: "application/json",
            "x-api-key": process.env.SANDBOX_KEY,
            "x-api-version": process.env.SANDBOX_API_VERSION,
          };
    
          // Request body
          const body = {
            aadhaar_number,
            otp,
            reference_id,
            "@entity": "in.co.sandbox.kyc.aadhaar.okyc.otp.verify",
          };
    
          // Make POST request to verify Aadhaar OTP
          const { status, data } = await axios.post(endpoint, body, { headers });
    
          // Handle non-200 status responses
          if (status !== 200) {
            return res.status(500).json({
              success: false,
              message: "Failed to verify Aadhaar OTP",
            });
          }
    
          // Return success response
          return res.status(200).json({ success: true, data });
        } catch (e) {
          console.error("Error verifying Aadhaar OTP:", e);
          return res
            .status(500)
            .json({ success: false, message: "Something went wrong"});
        }
      }
}