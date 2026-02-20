// import { Request, Response } from "express";
// import { GSTIN_RGX, validateGSTIN } from "../../lib/util";
// import Sandbox from "../../services/sandbox.service";
// import axios from "axios";
// import { z } from "zod";
// import {redisClient} from "../../middlewares/redis-adder";
// const GSTR4_SCHEMA = z.object({
//     gstin: z.string({ required_error: 'GSTIN Number is required' }).regex(GSTIN_RGX, "Invalid GSTIN Number"),
//     fp: z.string(),
//     txos: z.object({
//         samt: z.number(),
//         rt: z.number(),
//         camt: z.number(),
//         trnovr: z.number(),
//     }),
// });
// const GSTR1_SCHEMA = z.object({
//     gstin: z.string({ required_error: 'GSTIN Number is required' }).regex(GSTIN_RGX, "Invalid GSTIN Number"),
//     fp: z.string(),
//     gt: z.number(),
//     cur_gt: z.number()
//     ,
// });


// export default class GSTController {

//     static async searchByGSTIN(req: Request, res: Response) {
//         try {
//             const { gstin } = req.body;

//             // Validate GSTIN
//             if (!validateGSTIN(gstin)) {
//                 return res.status(400).json({
//                     success: false,
//                     message: "Please enter a valid GSTIN",
//                 });
//             }

//             // Generate access token
//             const token = await Sandbox.generateAccessToken();
//             console.log('Access Token:', token);

//             // Configure request options
//             const options = {
//                 method: 'POST',
//                 url: `${Sandbox.BASE_URL}/gst/compliance/public/gstin/search`,
//                 headers: {
//                     Accept: 'application/json',
//                     Authorization: token,
//                     'x-accept-cache': 'true',
//                     'x-api-key': process.env.SANDBOX_KEY,
//                     'x-api-version': process.env.SANDBOX_API_VERSION,
//                 },
//                 data: { gstin }, // Include GSTIN in the request body
//             };

//             // Send request to Sandbox API
//             const response = await axios.request(options);
//             console.log('API Response:', response.data);

//             // Check response status
//             if (response.status !== 200) {
//                 return res.status(response.status).json({
//                     success: false,
//                     message: "Error in Sandbox API",
//                     error: response.data,
//                 });
//             }

//             return res.status(200).json({
//                 success: true,
//                 data: response.data,    
//             }); 
//         } catch (error: any) {
//             console.error('Error:', error);

//             if (error.response) {
//                 return res.status(error.response.status).json({
//                     success: false,
//                     message: "Error in Sandbox API",
//                     error: error.response.data,
//                 });
//             }

//             return res.status(500).json({
//                 success: false,
//                 message: 'Internal Server Error',
//             });
//         }
//     }

//     static async searchGSTINNumberByPan(req: Request, res: Response) {
//         try {
//             const { pan, gst_state_code } = req.body; // Extract from body
    
//             // Validate the presence of required fields
//             if (!pan || !gst_state_code) {
//                 return res.status(400).json({
//                     success: false,
//                     message: "Required fields 'pan' and 'gst_state_code' are missing",
//                 });
//             }
    
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/public/pan/search?state_code=${encodeURIComponent(gst_state_code)}`;
    
//             // Generate access token
//             const token = await Sandbox.generateAccessToken();
//             console.log('Access Token:', token);
    
//             // Configure request options
//             const options = {
//                 method: 'POST',
//                 url: endpoint,
//                 headers: {
//                     Authorization: token,
//                     Accept: 'application/json',
//                     'x-accept-cache': 'true',
//                     'x-api-key': process.env.SANDBOX_KEY,
//                     'x-api-version': process.env.SANDBOX_API_VERSION,
//                 },
//                 data: {
//                     pan
//                 },
//             };
    
//             // Send request to the API
//             const response = await axios.request(options);
//             console.log('API Response:', response.data);
    
//             // Handle non-200 responses
//             if (response.status !== 200) {
//                 return res.status(response.status).json({
//                     success: false,
//                     message: "Error in Sandbox API",
//                     error: response.data,
//                 });
//             }
    
//             return res.status(200).json({
//                 success: true,
//                 data: response.data,
//             });
//         } catch (error: any) {
//             console.error('Error:', error);
    
//             if (error.response) {
//                 return res.status(error.response.status).json({
//                     success: false,
//                     message: "Error in Sandbox API",
//                     error: error.response.data,
//                 });
//             }
    
//             return res.status(500).json({
//                 success: false,
//                 message: 'Internal Server Error',
//             });
//         }
//     }

//     static async trackGSTReturn(req: Request, res: Response) {
//         try {
//             const { gstin, financial_year, gstr } = req.body;
    
//             // Validate GSTIN
//             if (!validateGSTIN(gstin)) {
//                 return res.status(400).json({ success: false, message: "Please enter a valid GSTIN" });
//             }
    
//             // Validate financial_year
//             if (!financial_year) {
//                 return res.status(400).json({ success: false, message: "Financial Year is required" });
//             }
    
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/public/gstrs/track`;
    
//             // Generate Access Token
//             const token = await Sandbox.generateAccessToken();
    
//             // Define headers
//             const headers = {
//                 Authorization: token,
//                 Accept: 'application/json',
//                 'x-accept-cache': 'true',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION,
//             };
    
//             // Build query parameters string
//             const queryParams = `?financial_year=${financial_year}${
//                 gstr ? `&gstr=${gstr}` : ''
//             }`;
    
//             // Make the API request
//             const response = await axios.post(
//                 `${endpoint}${queryParams}`, // Endpoint with query parameters
//                 { gstin,financial_year }, // Body parameters
//                 { headers } // Headers
//             );
    
//             // Handle success response
//             return res.status(200).json({ success: true, data: response.data });
//         } catch (error: any) {
//             console.error(error);
    
//             // Handle errors from the API
//             if (error.response) {
//                 return res
//                     .status(error.response.status)
//                     .json({ success: false, message: "Error in Sandbox API", error: error.response.data });
//             }
    
//             // Handle server-side errors
//             return res.status(500).json({ success: false, message: 'Internal Server Error' });
//         }
//     }

//     static async proceedToFileGstr(req: Request, res: Response) {
//         try {
//             const { gstin, ret_period } = req.body;
//             const { gstr, year, month,is_nil } = req.body;
    
//             // Validate Body and Query Parameters
//             if (!gstin || !ret_period) {
//                 return res.status(400).json({ success: false, message: "Required body parameters missing (gstin, ret_period)." });
//             }
    
//             if (!gstr || !year || !month) {
//                 return res.status(400).json({ success: false, message: "Required parameters missing (gstr, year, month)." });
//             }
    
//             if (!is_nil || !['Y', 'N'].includes(is_nil.toUpperCase())) {
//                 return res.status(400).json({
//                     success: false,
//                     message: "Query parameter 'is_nil' is required and must be 'Y' or 'N'."
//                 });
//             }
    
//             // Build endpoint with `is_nil` as a query parameter
//             const endpoint = `${Sandbox.BASE_URL}/compliance/tax-payer/gstrs/${gstr}/${year}/${month}/new-proceed?is_nil=${is_nil}`;
    
//             // Generate Access Token
//             const token = await Sandbox.generateAccessToken();
    
//             // Set headers for the request
//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION,
//             };
    
//             // Make the POST request with `gstin` and `ret_period` in the body
//             const response = await axios.post(
//                 endpoint,
//                 { gstin, ret_period },
//                 { headers }
//             );
    
//             const { status, data } = response;
    
//             // Handle non-200 status codes
//             if (status !== 200) {
//                 return res.status(500).json({
//                     success: false,
//                     message: "Failed to proceed with GSTR filing.",
//                     apiResponse: data,
//                 });
//             }
    
//             // Respond with the API data
//             return res.status(200).json({
//                 success: true,
//                 data: data.data,
//                 message: "GSTR filing initiated successfully.",
//             });
//         } catch (e) {
//             console.error(e);
//             return res.status(500).json({
//                 success: false,
//                 message: "An unexpected error occurred. Please try again later.",
//             });
//         }
//     }

//     static async registerForGST(req: Request, res: Response) {
//         try {
//             const { gstin, payload } = req.body;

//             if (!validateGSTIN(gstin)) {
//                 return res.status(400).json({ success: false, message: "Please enter valid GSTIN" });
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/registration`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.post(endpoint, payload, {
//                 headers,
//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Something went wrong" });
//             }

//             return res.status(200).send({ success: true, data });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

// static async generateOTP(req: Request, res: Response) {
//     try {
//         const { gstin, username } = req.body;

//         // Validate GSTIN
//         if (!validateGSTIN(gstin)) {
//             // console.warn(`[generateOTP] Invalid GSTIN: ${gstin}`);
//             return res.status(400).json({ success: false, message: "Please enter a valid GSTIN" });
//         }

//         // Construct endpoint
//         const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/otp`;

//         // Generate access token
//         const token = await Sandbox.generateAccessToken();
//         // console.debug(`[generateOTP] Access token generated.`);

//         // Set headers
//         const headers = {
//             'Authorization': token,
//             'x-api-key': process.env.SANDBOX_KEY,
//             'x-api-version': process.env.SANDBOX_API_VERSION || '1.0',
//             'x-source': 'primary',
//             'Content-Type': 'application/json',
//         };

//         // Prepare request body
//         const requestBody = {
//             username,
//             gstin,
//         };

//         // console.debug(`[generateOTP] Sending POST request to ${endpoint} with body:`, requestBody);

//         // Send POST request
//         const response = await axios.post(endpoint, requestBody, { headers });

//         // Check response status
//         if (response.status === 200) {
//             // console.info(`[generateOTP] OTP generated successfully for GSTIN: ${gstin}`);
//             return res.status(200).json({ success: true, data: response.data });
//         } else {
//             // console.error(`[generateOTP] Unexpected response status: ${response.status}`, response.data);
//             return res.status(response.status).json({ success: false, message: 'Unexpected response from OTP API', data: response.data });
//         }
//     } catch (error) {
//         console.error(`[generateOTP] Error occurred:`, error);

//         // Handle specific error responses
//         if (axios.isAxiosError(error)) {
//             const { response } = error;
//             if (response) {
//                 const { status, data } = response;
//                 console.error(`[generateOTP] Axios error response:`, data);

//                 if (status === 422 && data.message === "Invalid GSTIN pattern") {
//                     return res.status(422).json({ success: false, message: "Invalid GSTIN pattern" });
//                 }

//                 if (status === 200 && data?.data?.status_cd === "0") {
//                     const errorMessage = data?.data?.error?.message || 'OTP generation failed';
//                     return res.status(500).json({ success: false, message: errorMessage });
//                 }

//                 return res.status(status).json({ success: false, message: data.message || 'Error from OTP API' });
//             }
//         }

//         return res.status(500).json({ success: false, message: 'Internal server error' });
//     }
// }


// static async verifyOTP(req: Request, res: Response) {
//   try {
//     const { gstin, username, otp } = req.body;

//     if (!validateGSTIN(gstin)) {
//       return res.status(400).json({ success: false, message: "Please enter a valid GSTIN" });
//     }

//     // Append OTP to query string (non-standard, only if backend supports it)
//     const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/otp/verify?otp=${encodeURIComponent(otp)}`;

//     const token = await Sandbox.generateAccessToken();

//     const headers = {
//       'Authorization': token,
//       'accept': 'application/json',
//       'x-api-key': process.env.SANDBOX_KEY,
//       'x-api-version': process.env.SANDBOX_API_VERSION || '1.0',
//       'x-source': 'primary',
//       'Content-Type': 'application/json'
//     };

//     // Send GSTIN and Username in body, OTP is in URL
//     const requestBody = { username, gstin };

//     console.debug("Verifying OTP with body:", requestBody);
//     console.debug("OTP passed in URL params:", otp);

//     const response = await axios.post(endpoint, requestBody, { headers });

//     console.debug("OTP verification response:", response.data);

//     if (response.status !== 200) {
//       return res.status(response.status).send({ success: false, message: "Could not authenticate. Something went wrong" });
//     }
// const { access_token } = response.data.data;
// const sandbox_token=await redisClient.set(`gst-token:${gstin}`, access_token, { EX: 43200 });
// console.log(sandbox_token);


    
//     return res.status(200).send({ success: true, message: `GSTIN: ${gstin} authenticated successfully!`, data: response.data });
//   } catch (error) {
//     console.error("Error during OTP verification:", error);
//     return res.status(500).json({ success: false, message: 'Something went wrong' });
//   }
// }




//     /**
//      * Upload GSTR-4
//      */

//     static async uploadGSTR4(req: Request, res: Response) {
//         try {
//             const data = GSTR4_SCHEMA.parse(req.body);

//             const { gstin, year, month } = req.params;

//             if (!year || !month) {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-4/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const response = await axios.post(endpoint, data, {
//                 headers,
//             });

//             if (response.status !== 200) {
//                 return res.status(500).send({ success: true, message: "Could not upload GSTR 4" });
//             }

//             return res.status(200).send({ success: true, message: `GSTR-4 Uploaded successfully!`, reference_id: response.data.reference_id });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     /**
//      * Upload GSTR-3B
//      */

//     static async uploadGSTR3B(req: Request, res: Response) {
//         try {
//             const body = req.body;

//             const { gstin, year, month } = req.params;

//             if (!validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || !month) {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-3b/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const response = await axios.post(endpoint, body, {
//                 headers,
//             });

//             if (response.status !== 200) {
//                 return res.status(500).send({ success: true, message: "Could not upload GSTR 4" });
//             }

//             return res.status(200).send({ success: true, message: `GSTR-3B Uploaded successfully!`, reference_id: response.data.reference_id });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     /**
//      * File GSTR-3B
//      */

//     static async fileGSTR3B(req: Request, res: Response) {
//         try {
//             const body = req.body;

//             const { gstin, year, month } = req.params;

//             if (!validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || !month) {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-3b/${year}/${month}/file`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const response = await axios.post(endpoint, body, {
//                 headers,
//             });

//             if (response.status !== 200) {
//                 return res.status(500).send({ success: true, message: "Could not upload GSTR 4" });
//             }

//             return res.status(200).send({ success: true, message: `GSTR-3B Filed successfully!`, reference_id: response.data.reference_id });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     /**
//      * GSTR 3B Summary
//      */
//     static async getGSTR3BSummary(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.params;

//             if (!validateGSTIN(gstin)) {
//                 return res.status(400).json({ success: false, message: "Please enter valid GSTIN" });
//             }

//             if (!year || !month) {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-3b/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers
//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Something went wrong" });
//             }

//             return res.status(200).send({ success: true, data });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }



//     // ********   gstr 1   *********
//     static async gstr1AT(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
// console.log("✅ Saved token in Redis:", sandbox_token);
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/at/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,
//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 AT" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 AT found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }


//     static async gstr1ATA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             console.log("✅ Saved token in Redis:", sandbox_token);
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/ata/${year}/${month}`;
 
//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,
//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 ATA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 ATA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1B2B(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, ctin, action_required, from } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!ctin || !action_required || !from) {
//                 return res.status(400).send({ success: false, message: 'ctin ,action_required ,from are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/b2b/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 B2B" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 B2B found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1B2BA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, ctin, action_required, from } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!ctin || !action_required || !from) {
//                 return res.status(400).send({ success: false, message: 'ctin ,action_required ,from are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/b2ba/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 B2BA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 B2BA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1B2CL(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, state_code } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!state_code) {
//                 return res.status(400).send({ success: false, message: 'state_code are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/b2cl/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 B2CL" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 B2CL found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1B2CLA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, state_code } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!state_code) {
//                 return res.status(400).send({ success: false, message: 'state_code are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/b2cla/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 B2CLA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 B2CLA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1B2CS(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/b2cs/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 B2CS" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 B2CS found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1B2CSA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/b2csa/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 B2CSA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 B2CSA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1CDNR(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, action_required, from } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!action_required || !from) {
//                 return res.status(400).send({ success: false, message: 'action_required AND from are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/cdnr/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 CDNR" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 CDNR found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1CDNRA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, action_required, from } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!action_required || !from) {
//                 return res.status(400).send({ success: false, message: 'action_required AND from are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/cdnra/${year}/${month}`;
//             const sandbox_token = await redisClient.get(`gst-token:${gstin}`);

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 CDNRA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 CDNRA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1CDNUR(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/cdnur/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 CDNUR" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 CDNUR found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1CDNURA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/cdnura/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 CDNURA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 CDNURA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1DocumentIssued(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/doc-issue/${year}/${month}`;
// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 Document Isued" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 Document Isued found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1EXP(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/exp/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 EXP" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 EXP found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1EXPA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/expa/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 EXPA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 EXPA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1Summary(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-1/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 Summary" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 Summary found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1HSNSummary(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/hsn/${year}/${month}`;
// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 HSN Summary" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 HSN Summary found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr1NILSupplies(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/expa/${year}/${month}`;
// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -1 NIL Summary" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-1 NIL Summary found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }


//     static async saveGstr1(req: Request, res: Response) {
//         try {
//             const data = GSTR1_SCHEMA.parse(req.body);

//             const { gstin, year, month } = req.params;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || !month) {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/${year}/${month}`;
// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const response = await axios.post(endpoint, data, {
//                 headers,
//             });

//             if (response.status !== 200) {
//                 return res.status(500).send({ success: true, message: "Could not Save GSTR 1" });
//             }

//             return res.status(200).send({ success: true, message: ` Save GSTR-1  successfully!`, reference_id: response.data.reference_id });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async resetGstr1(req: Request, res: Response) {
//         try {
//             const data = (req.body);

//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/:year/:month/reset`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const response = await axios.post(endpoint, data, {
//                 headers,
//             });

//             if (response.status !== 200) {
//                 return res.status(500).send({ success: true, message: "Could not Reset GSTR 1" });
//             }

//             return res.status(200).send({ success: true, message: ` Reset GSTR-1  successfully!`, reference_id: response.data.reference_id });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async fileGSTR1(req: Request, res: Response) {
//         try {
//             const body = req.body;

//             const { gstin, year, month, pan, otp } = req.params;

//             if (!validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || !month) {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!pan || !otp) {
//                 return res.status(400).send({ success: false, message: 'pan and otp are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gst/compliance/tax-payer/gstrs/gstr-1/${year}/${month}/file`;
// const sandbox_token = await redisClient.get(`gst-token:${gstin}`);
//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': sandbox_token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const response = await axios.post(endpoint, body, {
//                 headers,
//             });

//             if (response.status !== 200) {
//                 return res.status(500).send({ success: true, message: "Could not File GSTR 1" });
//             }

//             return res.status(200).send({ success: true, message: `GSTR-1 Filed successfully!`, reference_id: response.data.reference_id });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     // **********Return GSTR-2A******************

//     static async gstr2aB2B(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, ctin } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!ctin) {
//                 return res.status(400).send({ success: false, message: 'ctin  are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-2a/b2b/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -2 B2B" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-2 B2B found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }


//     static async gstr2aB2BA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, ctin } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!ctin) {
//                 return res.status(400).send({ success: false, message: 'ctin  are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-2a/b2ba/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -2 B2BA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-2 B2BA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }


//     static async gstr2aCDN(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, ctin } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!ctin) {
//                 return res.status(400).send({ success: false, message: 'ctin  are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-2a/cdn/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -2 CDN" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-2 CDN found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr2aCDNA(req: Request, res: Response) {
//         try {
//             const { gstin, year, month, ctin } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }
//             if (!ctin) {
//                 return res.status(400).send({ success: false, message: 'ctin  are required' })
//             }

//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-2a/cdna/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -2 CDNA" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-2 CDNA found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr2aISD(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-2a/isd/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -2 ISD" });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-2 ISD found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

//     static async gstr2A(req: Request, res: Response) {
//         try {
//             const { gstin, year, month } = req.query;

//             if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//                 return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//             }

//             if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//                 return res.status(400).send({ success: false, message: 'Year and Month are required' });
//             }


//             const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-2a/${year}/${month}`;

//             const token = await Sandbox.generateAccessToken();

//             const headers = {
//                 'Authorization': token,
//                 'accept': 'application/json',
//                 'x-api-key': process.env.SANDBOX_KEY,
//                 'x-api-version': process.env.SANDBOX_API_VERSION
//             };

//             const { status, data: { data } } = await axios.get(endpoint, {
//                 headers,

//             });

//             if (status !== 200) {
//                 return res.status(500).send({ success: false, message: "Could not find GSTR -2 " });
//             }

//             return res.status(200).send({ success: true, data, message: `GSTR-2  found successfully!` });
//         } catch (e) {
//             console.log(e);
//             return res.status(500).json({ success: false, message: 'Something went wrong' });
//         }
//     }

// // ************************* GSTR -2B *********************************

// static async gstr2B(req: Request, res: Response) {
//     try {
//         const { gstin, year, month } = req.query;

//         if (!gstin || typeof gstin !== 'string' || !validateGSTIN(gstin)) {
//             return res.status(400).send({ success: false, message: 'Invalid GSTIN Number' });
//         }

//         if (!year || typeof year !== 'string' || !month || typeof month !== 'string') {
//             return res.status(400).send({ success: false, message: 'Year and Month are required' });
//         }

//         const endpoint = `${Sandbox.BASE_URL}/gsp/tax-payer/${gstin}/gstrs/gstr-2b/${year}/${month}`;

//         const token = await Sandbox.generateAccessToken();

//         const headers = {
//             'Authorization': token,
//             'accept': 'application/json',
//             'x-api-key': process.env.SANDBOX_KEY,
//             'x-api-version': process.env.SANDBOX_API_VERSION
//         };

//         const { status, data: { data } } = await axios.get(endpoint, {
//             headers,

//         });

//         if (status !== 200) {
//             return res.status(500).send({ success: false, message: "Could not find GSTR -2B " });
//         }

//         return res.status(200).send({ success: true, data, message: `GSTR-2B  found successfully!` });
//     } catch (e) {
//         console.log(e);
//         return res.status(500).json({ success: false, message: 'Something went wrong' });
//     }
// }

// }



//  testing purpose only ## 



import { Request, Response } from "express";
import { validateGSTIN } from "../../lib/util";
import { redisClient } from "../../middlewares/redis-adder";

/**
 * ===============================
 * GST SANDBOX CONTROLLER
 * MODE: MOCK_SANDBOX (TESTING)
 * ===============================
 *
 * NOTE:
 * - Ye file REAL sandbox API hit nahi karti
 * - Responses Sandbox jaisey hi hain
 * - Frontend & backend integration testing ke liye
 */

export default class GSTController {

  // ===========================
  // GSTIN SEARCH
  // ===========================
  static async searchByGSTIN(req: Request, res: Response) {
    const { gstin } = req.body;

    if (!validateGSTIN(gstin)) {
      return res.status(400).json({ success: false, message: "Invalid GSTIN" });
    }

    return res.status(200).json({
      success: true,
      data: {
        gstin,
        tradeName: "MOCK TRADERS PVT LTD",
        legalName: "MOCK TRADERS PRIVATE LIMITED",
        status: "Active",
        state: "Madhya Pradesh",
      },
    });
  }

  // ===========================
  // PAN → GSTIN SEARCH
  // ===========================
  static async searchGSTINNumberByPan(req: Request, res: Response) {
    const { pan, gst_state_code } = req.body;

    if (!pan || !gst_state_code) {
      return res.status(400).json({ success: false, message: "pan and gst_state_code required" });
    }

    return res.status(200).json({
      success: true,
      data: [
        {
          gstin: "22AAAAA0000A1Z5",
          state_code: gst_state_code,
          status: "Active",
        },
      ],
    });
  }

  // ===========================
  // GENERATE OTP
  // ===========================
  static async generateOTP(req: Request, res: Response) {
    const { gstin, username } = req.body;

    if (!validateGSTIN(gstin)) {
      return res.status(400).json({ success: false, message: "Invalid GSTIN" });
    }

    return res.status(200).json({
      success: true,
      data: {
        status_cd: "1",
        message: "OTP sent successfully (mock sandbox)",
      },
    });
  }

  // ===========================
  // VERIFY OTP
  // ===========================
  static async verifyOTP(req: Request, res: Response) {
    const { gstin, otp } = req.body;

    if (!validateGSTIN(gstin) || !otp) {
      return res.status(400).json({ success: false, message: "GSTIN and OTP required" });
    }

    const mockToken = `mock-gst-token-${gstin}`;

    // Save token in redis (same as real flow)
    await redisClient.set(`gst-token:${gstin}`, mockToken, { EX: 43200 });

    return res.status(200).json({
      success: true,
      message: "GSTIN authenticated successfully (mock)",
      data: {
        access_token: mockToken,
        expires_in: 43200,
      },
    });
  }

  // ===========================
  // TRACK GST RETURN
  // ===========================
  static async trackGSTReturn(req: Request, res: Response) {
    const { gstin, financial_year } = req.body;

    if (!validateGSTIN(gstin) || !financial_year) {
      return res.status(400).json({ success: false, message: "Invalid request" });
    }

    return res.status(200).json({
      success: true,
      data: {
        gstin,
        financial_year,
        returns: [
          { gstr: "GSTR-1", status: "Filed" },
          { gstr: "GSTR-3B", status: "Pending" },
        ],
      },
    });
  }

  // ===========================
  // GSTR-1 SUMMARY
  // ===========================
  static async gstr1Summary(req: Request, res: Response) {
    const { gstin, year, month } = req.query;

    if (!validateGSTIN(String(gstin))) {
      return res.status(400).json({ success: false, message: "Invalid GSTIN" });
    }

    return res.status(200).json({
      success: true,
      data: {
        period: `${month}-${year}`,
        b2b: [],
        b2cs: [],
        hsn: [],
        total_taxable_value: 250000,
        total_tax: 45000,
      },
      message: "GSTR-1 summary fetched (mock sandbox)",
    });
  }

  // ===========================
  // SAVE GSTR-1
  // ===========================
  static async saveGstr1(req: Request, res: Response) {
    const { gstin } = req.body;

    if (!validateGSTIN(gstin)) {
      return res.status(400).json({ success: false, message: "Invalid GSTIN" });
    }

    return res.status(200).json({
      success: true,
      message: "GSTR-1 saved successfully (mock)",
      reference_id: "MOCK_GSTR1_SAVE_001",
    });
  }

  // ===========================
  // FILE GSTR-1
  // ===========================
  static async fileGSTR1(req: Request, res: Response) {
    const { gstin } = req.body;

    if (!validateGSTIN(gstin)) {
      return res.status(400).json({ success: false, message: "Invalid GSTIN" });
    }

    return res.status(200).json({
      success: true,
      message: "GSTR-1 filed successfully (mock)",
      ack_no: "MOCK_GSTR1_ACK_123456",
    });
  }

  // ===========================
  // GSTR-3B SUMMARY
  // ===========================
  static async getGSTR3BSummary(req: Request, res: Response) {
    const { gstin, year, month } = req.query;

    if (!validateGSTIN(String(gstin))) {
      return res.status(400).json({ success: false, message: "Invalid GSTIN" });
    }

    return res.status(200).json({
      success: true,
      data: {
        period: `${month}-${year}`,
        outward_supply: 300000,
        inward_supply: 120000,
        tax_payable: 54000,
      },
      message: "GSTR-3B summary fetched (mock)",
    });
  }

}
