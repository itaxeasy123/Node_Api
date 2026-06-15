
import { Request, Response } from 'express';
import { prisma } from '../index';
import TokenService from '../services/token.service';

export default class PaymentsController {

  // ✅ CREATE PAYMENT
  public static async createPayment(req: Request, res: Response): Promise<Response> {
    try {
      const { razorpay_order_id, razorpay_payment_id, status } = req.body;

      const token = TokenService.getTokenFromAuthHeader(req);
      const { id: userId } = TokenService.decodeToken(token!);

      const user = await prisma.user.findUnique({ where: { id: userId } });

      if (!user) {
        return res.status(401).json({ success: false, message: 'User not found' });
      }

      const payment = await prisma.payment.create({
        data: {
          razorpay_order_id,
          razorpay_payment_id,
          status,
          userId,
        },
      });

      return res.json({
        success: true,
        message: 'Payment created successfully',
        data: payment,
      });

    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to create payment',
      });
    }
  }

  // ✅ GET ALL PAYMENTS
  public static async getPayments(req: Request, res: Response): Promise<Response> {
    try {
      const token = TokenService.getTokenFromAuthHeader(req);
      const { id: userId } = TokenService.decodeToken(token!);

      const payments = await prisma.payment.findMany({
        where: { userId },
      });

      return res.json({
        success: true,
        message: 'Payments fetched successfully',
        data: payments,
      });

    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch payments',
      });
    }
  }

  // ✅ GET SINGLE PAYMENT
  public static async getPaymentById(req: Request, res: Response): Promise<Response> {
    const { id } = req.params;

    try {
      const token = TokenService.getTokenFromAuthHeader(req);
      const { id: userId } = TokenService.decodeToken(token!);

      const payment = await prisma.payment.findFirst({
        where: { id, userId },
      });

      if (!payment) {
        return res.status(404).json({
          success: false,
          message: 'Payment not found',
        });
      }

      return res.json({
        success: true,
        message: 'Payment fetched successfully',
        data: payment,
      });

    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch payment',
      });
    }
  }

  // ✅ UPDATE PAYMENT
  public static async updatePayment(req: Request, res: Response): Promise<Response> {
    const { id } = req.params;
    const { razorpay_order_id, razorpay_payment_id, status } = req.body;

    try {
      const token = TokenService.getTokenFromAuthHeader(req);
      const { id: userId } = TokenService.decodeToken(token!);

      const payment = await prisma.payment.findUnique({ where: { id } });

      if (payment?.userId !== userId) {
        return res.status(403).json({
          success: false,
          message: 'Unauthorized Access',
        });
      }

      const updatedPayment = await prisma.payment.update({
        where: { id },
        data: {
          razorpay_order_id,
          razorpay_payment_id,
          status,
        },
      });

      return res.json({
        success: true,
        message: 'Payment updated successfully',
        data: updatedPayment,
      });

    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to update payment',
      });
    }
  }

  // ✅ DELETE PAYMENT
  public static async deletePayment(req: Request, res: Response): Promise<Response> {
    const { id } = req.params;

    try {
      const token = TokenService.getTokenFromAuthHeader(req);
      const { id: userId } = TokenService.decodeToken(token!);

      const payment = await prisma.payment.findUnique({ where: { id } });

      if (payment?.userId !== userId) {
        return res.status(403).json({
          success: false,
          message: 'Unauthorized Access',
        });
      }

      await prisma.payment.delete({ where: { id } });

      return res.json({
        success: true,
        message: 'Payment deleted successfully',
      });

    } catch (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: 'Failed to delete payment',
      });
    }
  }
}