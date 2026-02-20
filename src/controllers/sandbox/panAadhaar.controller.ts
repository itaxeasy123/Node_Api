import { Request, Response } from "express";
import Sandbox from "../../services/sandbox.service";
import axios from "axios";

export default class PanAadhaarController {

    static async checkLinkStatus(req: Request, res: Response) {
        try {
            const { pan, aadhaar } = req.body;

            // Validate required fields
            if (!pan) {
                return res.status(400).json({ success: false, message: 'Enter a valid PAN Number' });
            }

            if (!aadhaar) {
                return res.status(400).json({ success: false, message: 'Enter a valid Aadhaar Number' });
            }

            // Set default values for entity, consent, and reason
            const defaultEntity = "in.co.sandbox.kyc.pan_aadhaar.status";
            const defaultConsent = "Y";
            const defaultReason = "For KYC of User jjjjjjjj";

            // Construct the endpoint URL with the PAN number
            const endpoint = `${Sandbox.BASE_URL}/kyc/pan-aadhaar/status`;

            // Generate access token
            const token = await Sandbox.generateAccessToken();

            // Set headers for the API request
            const headers = {
                Authorization: token,
                accept: 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION
            };

            // Prepare the request body with the necessary data
            const requestBody = {
                aadhaar_number: aadhaar,
                pan: pan,
                "@entity": defaultEntity,
                consent: defaultConsent,
                reason: defaultReason
            };
            console.log(requestBody); // Log the request body

            // Make the API call with the request body
            const { status, data: { data } } = await axios.post(endpoint, requestBody, {
                headers
            });

            // Handle API response
            if (status !== 200) {
                return res.status(500).send({ success: false, message: "Something went wrong" });
            }

            // Return successful response with data
            return res.status(200).send({
                success: true,
                data
            });
        } catch (e) {
            console.log(e);
            return res.status(500).send({ success: false, message: "Something went wrong" });
        }
    }

}
