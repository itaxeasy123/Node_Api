import axios from "axios";
import { Request, Response } from "express";
import Sandbox from "../../services/sandbox.service";

export default class EinvoiceController {
   
static einvoiceAuthToken: string | null = null;

    static async einvoiceLogin(req: Request, res: Response) {
  try {
    const { username, password, gstin } = req.body;

    if (!username || !password || !gstin) {
      return res.status(400).json({
        success: false,
        message: "Missing required fields: username, password, or gstin"
      });
    }

    const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-invoice/tax-payer/authenticate?force=true`;
    const token = await Sandbox.generateAccessToken();
    const headers = {
      accept: 'application/json',
      authorization: `${token}`, // ✅ match other methods
      'x-api-key': process.env.SANDBOX_KEY || '',
      'x-source': 'primary',
      'x-api-version': process.env.SANDBOX_API_VERSION || '',
      'content-type': 'application/json',
    };

    const payload = { username, password, gstin };

    const response = await axios.post(endpoint, payload, { headers });

    EinvoiceController.einvoiceAuthToken = response.data?.data?.access_token || null;


    return res.status(200).json({
      success: true,
      data: response.data
    });

  } catch (error: unknown) {
    console.error('E-invoice login failed:', error);

    if (typeof error === "object" && error !== null && "response" in error) {
      const err = error as { response: { status: number; data?: { message?: string } } };
      return res.status(err.response.status).json({
        success: false,
        message: err.response.data?.message || 'Authentication failed'
      });
    }

    return res.status(500).json({
      success: false,
      message: 'Something went wrong',
      error: error instanceof Error ? error.message : String(error)
    });
  }
}




    static async generateEinvoice(req: Request, res: Response) {
        try {
            // Ensure the request body is not empty
            if (!req.body || Object.keys(req.body).length === 0) {
                return res.status(400).json({ success: false, message: "Body parameters missing" });
            }
    
            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-invoice/tax-payer/invoice`;
            const token = EinvoiceController.einvoiceAuthToken;
    
            // Set up headers for the API request
            const headers = {
                'Authorization': `Bearer ${token}`, // Assuming token is Bearer type
                'Accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY || '',
                'x-api-version': process.env.SANDBOX_API_VERSION || ''
            };
    
            // Send request to Sandbox API
            const response = await axios.post(endpoint, req.body, { headers });
    
            // Handle successful response
            return res.status(200).json({ 
                success: true, 
                data: response.data?.data || response.data // Support for possible structure variation
            });
    
        } catch (error: any) {
            console.error('Error generating e-invoice:', error);
    
            // Handle specific Axios errors
            if (error.response) {
                return res.status(error.response.status).json({
                    success: false,
                    message: error.response.data?.message || 'Error from external service'
                });
            }
            // General error fallback
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: error.message
            });
        }
    }

    static async einvoicebyirn(req: Request, res: Response) {
        try {
            const { irn } = req.body;

            if (!irn) {
                return res.status(400).json({ success: false, message: 'Query Parameter "einvoiceId" is missing' });
            }

            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-invoice/tax-payer/invoice/irn`;

            const token = EinvoiceController.einvoiceAuthToken;

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION
            };

            const { data: { data } } = await axios.get(endpoint, {
                headers
            });

            return res.status(200).send({ success: true, data });
        } catch(e) {
            console.log(e);
            return res.status(500).json({ success: false, message: 'Something went wrong' });
        }
    }
    static async einvoiceCancel(req: Request, res: Response) {
        try {
            const { einvoiceId } = req.body;

            if (!einvoiceId) {
                return res.status(400).json({ success: false, message: 'Query Parameter "einvoiceId" is missing' });
            }

            const endpoint = `${Sandbox.BASE_URL}/einvoice/${einvoiceId}/cancel`;

            const token = EinvoiceController.einvoiceAuthToken;

            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION
            };

            const { data: { data } } = await axios.get(endpoint, {
                headers
            });

            return res.status(200).send({ success: true, data });
        } catch(e) {
            console.log(e);
            return res.status(500).json({ success: false, message: 'Something went wrong' });
        }
    }
    static async generateEinvoicePdf(req: Request, res: Response) {
        try {
            const { irn, signed_qr_code, signed_invoice } = req.body;
    
            // Validate required body parameters
            if (!irn || !signed_qr_code || !signed_invoice) {
                return res.status(400).json({
                    success: false,
                    message: 'Missing required body parameters: "irn", "signed_qr_code", or "signed_invoice".'
                });
            }
    
            const endpoint = `${Sandbox.BASE_URL}/einvoice/generate/pdf`;
            const token = EinvoiceController.einvoiceAuthToken;
    
            // Set up request headers
            const headers = {
                'Authorization': `Bearer ${token}`, // Assuming token is Bearer type
                'Accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY || '',
                'x-api-version': process.env.SANDBOX_API_VERSION || ''
            };
    
            // Create the request payload, including @entity
            const requestBody = {
                irn,
                signed_qr_code,
                signed_invoice,
                "@entity": "in.co.sandbox.gst.compliance.e-invoice.pdf.request"
            };
    
            // API call to generate e-invoice PDF
            const response = await axios.post(endpoint, requestBody, { headers });
    
            // Extract data from the response
            const responseData = response.data?.data || response.data;
    
            return res.status(200).json({
                success: true,
                data: responseData
            });
        } catch (error: any) {
            console.error('Error generating e-invoice PDF:', error);
    
            // Handle specific Axios errors
            if (error.response) {
                return res.status(error.response.status).json({
                    success: false,
                    message: error.response.data?.message || 'Error from external service'
                });
            }
            // General error fallback
            return res.status(500).json({
                success: false,
                message: 'Something went wrong',
                error: error.message
            });
        }
    }
    static async einvoicebydocumentdata(req: Request, res: Response) {
        try{
            const { document_type,document_number,document_date } = req.body;
            if (!document_type || !document_number || !document_date) {
                return res.status(400).json({ success: false, message: 'Query Parameter "documentData" is missing' });
            }
            const endpoint = `${Sandbox.BASE_URL}/gst/compliance/e-invoice/tax-payer/invoice`;
            const token = EinvoiceController.einvoiceAuthToken;
            const headers = {
                'Authorization': token,
                'accept': 'application/json',
                'x-api-key': process.env.SANDBOX_KEY,
                'x-api-version': process.env.SANDBOX_API_VERSION
            };
            const { data: { data } } = await axios.get(endpoint, {
                headers
            });
            return res.status(200).send({ success: true, data });

        }catch(e){
            console.log(e);
            return res.status(500).json({ success: false, message: 'Something went wrong' });
        }
    }
}
