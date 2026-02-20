import axios from "axios";
import { Request, Response } from "express";
import Sandbox from "../../services/sandbox.service";

export default class ewaybillcontroller{
    //consingoer
    static async generateEwaybill(req: Request, res: Response){
        try {
            if(!req.body || Object.keys(req.body).length === 0) {
                return res.status(400).json({ success: false, message: "Body Params missing" });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/tax-payer/invoice`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION
            };

            const { data: { data } } = await axios.post(endpoint, req.body, {
                headers
            });

            return res.status(200).send({ success: true, data });
        } catch(e) {
            console.log(e);
            return res.status(500).json({ success: false, message: 'Something went wrong' });
        }
    }
    static async ewayauth(req: Request, res: Response) {
        try {
            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/tax-payer/authenticate`;
            const data = {
                "username": req.body.username,
                "password": req.body.password,
                "gstin": req.body.gstin,
            };
            const token = await Sandbox.generateAccessToken();
    
            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION
            };
    
            const response = await axios.post(endpoint, data, { headers });
    
            return res.status(200).send({ success: true, data: response.data });
        } catch (e) {
            console.error(e);
            return res.status(500).json({ success: false, message: 'Something went wrong' });
        }
    }
    static async getewaybillbydate(req: Request, res: Response) {
        try {
            const { generateddate, rejected = false } = req.body;
    
            // Validate required parameter
            if (!generateddate) {
                return res.status(400).json({ success: false, message: "Body params missing: 'generateddate' is required" });
            }
    
            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/consignor/bills`;
    
            const token = await Sandbox.generateAccessToken();
    
            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };

            const requestData = { generateddate, rejected };

            // Make the API request
            const { data } = await axios.post(endpoint, requestData, { headers });

            return res.status(200).json({ success: true, data });
        } catch (e) {
            console.error('Error in getewaybillbydate:', e);
            return res.status(500).json({ success: false, message: 'Something went wrong', error: (e as any).message });
        }
    }
    static async getewaybillbydocumentdata(req: Request, res: Response) {
        try {
            const { document_type, document_number } = req.query;
    
            // Validate required parameters
            if (!document_type || !document_number) {
                return res.status(400).json({
                    success: false,
                    message: "Query params missing: 'document_type' and 'document_number' are required"
                });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/consignor/bills`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };

            // Pass query parameters to the endpoint
            const docType = Array.isArray(req.query.document_type)
            ? req.query.document_type[0]
            : req.query.document_type ?? "";
          
          const docNumber = Array.isArray(req.query.document_number)
            ? req.query.document_number[0]
            : req.query.document_number ?? "";
          
          const queryParams = new URLSearchParams({ 
            document_type: docType as string, 
            document_number: docNumber as string 
          }).toString();
           
                       const fullEndpoint = `${endpoint}?${queryParams}`;

            // Make the API request
            const { data } = await axios.get(fullEndpoint, { headers });

            return res.status(200).json({ success: true, data });
        } catch (e) {
            console.error('Error in getewaybillbydocumentdata:', e);
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: (e as any).message,
            });
        }
    }
    static async cancelewaybill(req: Request, res: Response) {
        try {
            const { ewbNo, cancelRsnCode,cancelRmrk } = req.body;
            const ewb_no = req.body.ewb_no;
            // Validate required parameters
            if (!ewb_no || !cancelRsnCode || cancelRmrk) {
                return res.status(400).json({
                    success: false,
                    message: "Body params missing: 'ewaybillno' and 'cancelreason' and 'remark' are required"
                });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/consignor/bill/${ewbNo}/cancel`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };

            // Make the API request
            const { data } = await axios.post(endpoint, req.body, { headers });

            return res.status(200).json({ success: true, data });
        } catch (e) {
            console.error('Error in cancelewaybill:', e);
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: (e as any).message,
            });
        }
    }
    //consignee

    static async getewaybillbydateconsignee(req: Request, res: Response) {
        try{
            const { generateddate} = req.body;

            // Validate required parameter
            if (!generateddate) {
                return res.status(400).json({ success: false, message: "Body params missing: 'generateddate' is required" });
            }
            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/consignee/bills?generateddate=${generateddate}`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };


            // Make the API request
            const { data } = await axios.post(endpoint, { headers });

            return res.status(200).json({ success: true, data });
        }
        catch(e){
            console.error('Error in getewaybillbydate:', e);
            return res.status(500).json({ success: false, message: 'Something went wrong', error: (e as any).message });
        }
}
    static async rejectewaybill(req: Request, res: Response) {
        try{
            const {ewbNo} = req.body;

            // Validate required parameters
            if (!ewbNo) {

                return res.status(400).json({
                    success: false,
                    message: "Body params missing: 'ewaybillno' and 'rejectreason' and 'remark' are required"
                });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/consignee/bill/${ewbNo}/reject`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };

            // Make the API request
            const { data } = await axios.post(endpoint, req.body, { headers });

            return res.status(200).json({ success: true, data });
        }catch(e){
            console.error('Error in rejectewaybill:', e);
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: (e as any).message,
            });
        }
}
//transporter
    static async ewaybillsbydateandstate(req:Request,res:Response){
        try{
            const {generated_date, generator_state_code,assigned_date} = req.body;

            // Validate required parameter
            if (!generated_date || !generator_state_code || !assigned_date) {
                return res.status(400).json({ success: false, message: "Body params missing: 'generateddate' and 'state' are required" });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/transporter/bills`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };

            // Make the API request
            const { data } = await axios.post(endpoint, req.body, { headers });

            return res.status(200).json({ success: true, data });
        }catch(e){
            console.error('Error in ewaybillsbydateandstate:', e);
            return res.status(500).json({ success: false, message: 'Something went wrong', error: (e as any).message });
        }
    }
    static async listewaybillbygenerator(req:Request,res:Response){
        try{
            const {generated_date, generator_gstin} = req.body;

            // Validate required parameter
            if (!generated_date || !generator_gstin) {
                return res.status(400).json({ success: false, message: "Body params missing: 'generateddate' and 'gstin' are required" });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/transporter/bills/list?generateddate=${generated_date}`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };

            // Make the API request
            const { data } = await axios.post(endpoint, generator_gstin, { headers });

            return res.status(200).json({ success: true, data });
        }catch(e){
            console.error('Error in listewaybillbygenerator:', e);
            return res.status(500).json({ success: false, message: 'Something went wrong', error: (e as any).message });
        }
    }
    static async updatevehicledetails(req:Request,res:Response){
        try{
            const {
                ewbNo,
                vehicleNo,
                fromPlace,
                fromState,
                reasonCode,
                reasonRem,
                transDocNo,
                transDocDate,
                transMode,
                vehicleType
            } = req.body;

            // Validate required parameters
            if (!ewbNo || !vehicleNo || !fromPlace || !fromState || !reasonCode || !reasonRem || !transDocNo || !transDocDate || !transMode || !vehicleType) {
                return res.status(400).json({
                    success: false,
                    message: "please fill all the details"
                });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/transporter/bill/${ewbNo}/vehicle`;

            const token = await Sandbox.generateAccessToken();

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION,
            };

            // Make the API request
            const { data } = await axios.put(endpoint, req.body, { headers });

            return res.status(200).json({ success: true, data });
        }catch(e){
            console.error('Error in updatevehicledetails:', e);
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: (e as any).message,
            });
        }
    }
    static async extendewaybillvalidity(req: Request, res: Response): Promise<Response> {
        try {
            const { data: requestBody } = req.body;

            // Validate required parameters
            if (!requestBody?.ewbNo) {
                return res.status(400).json({
                    success: false,
                    message: "Body params missing: 'ewbNo'",
                });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/transporter/bill/${requestBody.ewbNo}/extend`;

            // Generate access token
            const token = await Sandbox.generateAccessToken();

            const headers = {
                Authorization: token,
                Accept: 'application/json',
                'x-api-key': process.env.SANDBOX_KEY!,
                'x-api-version': process.env.SANDBOX_API_VERSION!,
            };

            // Make the API request
            const response = await axios.post(endpoint, { data: requestBody }, { headers });

            return res.status(200).json({
                success: true,
                data: response.data,
            });
        } catch (e : any) {
            console.error('Error in extendewaybillvalidity:', e);
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: (e as any).message,
            });
        }
    }
    static async updatetransporterdetails(req: Request, res: Response): Promise<Response> {
        try {
            const { data: requestBody } = req.body;

            // Validate required parameters
            if (!requestBody?.ewbNo) {
                return res.status(400).json({
                    success: false,
                    message: "Body params missing: 'ewbNo'",
                });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-way-bill/transporter/bill/${requestBody.ewbNo}/transporter`;

            // Generate access token
            const token = await Sandbox.generateAccessToken();

            const headers = {
                Authorization: token,
                Accept: 'application/json',
                'x-api-key': process.env.SANDBOX_KEY!,
                'x-api-version': process.env.SANDBOX_API_VERSION!,
            };

            // Make the API request
            const response = await axios.put(endpoint, { data: requestBody }, { headers });

            return res.status(200).json({
                success: true,
                data: response.data,
            });
        } catch (e : any) {
            console.error('Error in updatetransporterdetails:', e);
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: e.message,
            });
        }
    }
}
