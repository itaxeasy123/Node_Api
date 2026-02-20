import { config } from 'dotenv';
import Razorpay from "razorpay";
import crypto from "crypto";
import { Request, Response } from "express";
import { prisma } from "../..";
import path from "path";

config(
  {
    path: path.resolve(__dirname, "../../../.env"),
  }
);
import ApiServiceController from "../apiservice.controller";
const razorpayInstance = new Razorpay({
  key_id: process.env.rzp_key_id, // Replace with your Razorpay Key ID
  key_secret: process.env.rzp_key_secret, // Replace with your Razorpay Key Secret
});

export default class RazorpayService {
    static async createOrder(req: Request, res: Response) {
        const { serviceIds } = req.body; // Expecting an array of service IDs in the request body
        const userId = req.user?.id; // Assuming `userId` is available in `req.user`
    
        try {
          // Validate input
          if (!Array.isArray(serviceIds) || serviceIds.length === 0) {
            return res.status(400).json({
              success: false,
              message: "An array of service IDs is required.",
            });
          }
    
          if (!userId) {
            return res.status(400).json({
              success: false,
              message: "User ID is required.",
            });
          }
    
          // Retrieve prices for the selected services
          const services = await prisma.service.findMany({
            where: { id: { in: serviceIds } },
            select: { id: true, price: true },
          });
    
          if (services.length !== serviceIds.length) {
            const missingIds = serviceIds.filter(
              (id) => !services.some((service) => service.id === id)
            );
            return res.status(400).json({
              success: false,
              message: "Some services were not found.",
              missingServiceIds: missingIds,
            });
          }
    
          // Calculate total amount
          const totalAmount = services.reduce((sum, service) => sum + Number(service.price), 0) * 100; // Convert to paise (smallest unit)
    
          // Create Razorpay order
          const options = {
            amount: totalAmount,
            currency: "INR",
            receipt: `receipt_${Date.now()}`,
            payment_capture: 1,
            notes: {
              userId: userId.toString(),
              serviceIds: JSON.stringify(serviceIds),
            },
          };
    
          const order = await razorpayInstance.orders.create(options);
          console.log("Order created successfully:", order);
    
          // Save the order in the database
          await prisma.payment.create({
            data: {
              razorpay_order_id: order.id,
              razorpay_payment_id: "",
              status: "created",
              userId,
              orderId: 1, // Replace with appropriate logic for generating order ID
            },
          });
    
          return res.status(200).json({
            success: true,
            message: "Order created successfully.",
            order,
          });
        } catch (error) {
          console.error("Error creating order:", error);
          return res.status(500).json({
            success: false,
            message: "Internal Server Error",
          });
        }
      }
  static async razorCallback(req: Request, res: Response) {
    const secret = process.env.rzp_secret; // Replace with your Razorpay Webhook Secret
    if (!secret) {
      console.error("Razorpay Webhook Secret is not defined.");
      return res.status(500).json({ error: "Internal server error" });
    }

    try {
      const { razorpay_payment_id, razorpay_order_id, razorpay_signature } = req.body;

      // Check for required fields
      if (!razorpay_payment_id || !razorpay_order_id || !razorpay_signature) {
        console.error("Missing required fields in Razorpay callback payload.");
        return res.status(400).json({ error: "Invalid payload" });
      }

      // Combine order ID and payment ID
      const payload = `${razorpay_order_id}|${razorpay_payment_id}`;

      // Compute HMAC SHA256 digest
      const shasum = crypto.createHmac("sha256", secret);
      shasum.update(payload);
      const digest = shasum.digest("hex");

      // Log computed and received signature
      console.log("Computed Signature:", digest);
      console.log("Received Signature:", razorpay_signature);

      // Verify signature
      if (digest === razorpay_signature) {
        console.log("Request is legitimate.");

        // Process the payload here
        // Example: Update payment status in the database, send confirmation, etc.

        return res.json({ status: "ok" });
      } else {
        console.error("Invalid signature. Request is not legitimate.");
        return res.status(400).json({ error: "Invalid signature" });
      }
    } catch (error) {
      console.error("Error handling Razorpay callback:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  }
  static async refetchOrder(req: Request, res: Response) {
    try {
      const { orderId } = req.body;
  
      // Validate input
      if (!orderId) {
        return res.status(400).json({
          success: false,
          message: "Order ID is required.",
        });
      }
  
      // Fetch the Razorpay order
      const order = await razorpayInstance.orders.fetch(orderId);
      if (!order) {
        return res.status(404).json({
          success: false,
          message: "Order not found.",
        });
      }
  
      // Extract userId and serviceIds from the order notes
      const userId = order.notes?.userId;
      const serviceIds = order.notes?.serviceIds
        ? JSON.parse(order.notes.serviceIds as string)
        : [];
  
      if (!userId || !serviceIds.length) {
        return res.status(400).json({
          success: false,
          message: "Invalid order notes. User ID or Service IDs are missing.",
        });
      }
  
      console.log("Order fetched successfully:", order);
  
      // Update payment status in the database
      await prisma.payment.update({
        where: {
          id: orderId,
        },
        data: {
          status: "success",
        },
      });
  
      // Subscribe the user to all services
      const numericUserId = typeof userId === 'string' ? parseInt(userId, 10) : userId;
      const response = await ApiServiceController.subscribeUserToApis(numericUserId, serviceIds);
  
      return res.status(200).json({
        success: true,
        message: "Order fetched successfully.",
        order,
        response,
      });
    } catch (error) {
      console.error("Error fetching order:", error);
  
      return res.status(500).json({
        success: false,
        message: "Internal Server Error",
        error: (error as any).message,
      });
    }
  }
}