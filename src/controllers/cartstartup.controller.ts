import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import TokenService from '../services/token.service';

const prisma = new PrismaClient();

export const addStartupToCart = async (req: Request, res: Response) => {
    try {
      console.log("step 1: Starting addStartupToCart");
  
      // Step 1: Get token
      const token = TokenService.getTokenFromAuthHeader(req);
      if (!token) return res.status(401).json({ message: 'Unauthorized' });
  
      console.log("step 2: Token retrieved");
  
      // Step 2: Verify token
      const user = TokenService.verifyToken(token);
      const { id } = user as { id: number | string };
      const userId = typeof id === "string" ? parseInt(id) : id;
  
      console.log("step 3 - userId:", userId);
  
      // Step 3: Ensure user exists
      const userExists = await prisma.user.findUnique({
        where: { id: userId }
      });
  
      if (!userExists) {
        return res.status(400).json({ message: 'User not found' });
      }
  
      // Step 4: Extract startup data   
      const { id: startupId } = req.body;
      
      console.log("step 4: Extracted startupId:", startupId);
  
      // Step 5: Verify the startup exists
      const startup = await prisma.registerStartup.findUnique({
        where: { id: startupId }
      });
  
      if (!startup) {
        return res.status(404).json({ message: 'Startup registration service not found' });
      }
  
      console.log("step 5: Startup found");
  
      // Step 6: Check if user's cart exists
      let cart = await prisma.cart.findUnique({
        where: { userId },
        include: { 
          registrationStartup: true,
          services: true,
          registrationServices: true 
        }
      });
  
      console.log("step 6: Checked cart existence");
  
      // Step 7: Create cart if it doesn't exist
      if (!cart) {
        cart = await prisma.cart.create({
          data: {
            userId,
            category: "STARTUP_REGISTRATION"
          },
          include: { 
            registrationStartup: true,
            services: true,
            registrationServices: true 
          }
        });
      }
  
      console.log("step 7: Cart ensured");
  
      // Step 8: Check if startup is already in cart
      const isAlreadyInCart = cart.registrationStartup.some(item => item.id === startupId);
      if (isAlreadyInCart) {
        return res.status(400).json({ message: 'Startup registration already in cart' });
      }
  
      console.log("step 8: Checked if already in cart");
  
      // Step 9: Add startup to cart
      await prisma.cart.update({
        where: { userId },
        data: {
          registrationStartup: {
            connect: { id: startupId }
          },
          category: "STARTUP_REGISTRATION"
        }
      });
  
      console.log("step 9: Added startup to cart");
  
      return res.status(200).json({ 
        message: 'Startup registration added to cart',
        startup: startup
      });
  
    } catch (err) {
      console.error("Error in addStartupToCart:", err);
      return res.status(500).json({ message: 'Something went wrong', error: err });
    }
  };    

export const getStartupItemsFromCart = async (req: Request, res: Response) => {
  try {
    console.log("Getting startup items from cart - step 1");

    // Step 1: Get token
    const token = TokenService.getTokenFromAuthHeader(req);
    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized",
      });
    }

    console.log("Getting startup items from cart - step 2");

    // Step 2: Verify token
    const user = TokenService.verifyToken(token);
    const { id } = user as { id: number | string };
    const userId = typeof id === "string" ? parseInt(id) : id;

    console.log("Getting startup items from cart - step 3 - userId:", userId);

    // Step 3: Ensure user exists
    const userExists = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!userExists) {
      return res.status(400).json({
        success: false,
        message: "User not found",
      });
    }

    // Step 4: Get user's cart with startup registrations
    const cart = await prisma.cart.findUnique({
      where: { userId },
      include: {
        registrationStartup: true,
      },
    });

    console.log("Getting startup items from cart - step 4");

    // ✅ IMPORTANT FIX — NO 404
    if (!cart) {
      return res.status(200).json({
        success: true,
        items: [],
        itemCount: 0,
      });
    }

    const startupItems = cart.registrationStartup || [];

    return res.status(200).json({
      success: true,
      items: startupItems,
      itemCount: startupItems.length,
    });
  } catch (error) {
    console.error("getStartupItemsFromCart error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

  
  // For getting all items in cart (combined function)
  export const removeStartupFromCart = async (req: Request, res: Response) => {
    try {
      console.log("step 1: Starting removeStartupFromCart");
  
      // Step 1: Get token
      const token = TokenService.getTokenFromAuthHeader(req);
      if (!token) return res.status(401).json({ message: 'Unauthorized' });
  
      console.log("step 2: Token retrieved");
  
      // Step 2: Verify token
      const user = TokenService.verifyToken(token);
      const { id } = user as { id: number | string };
      const userId = typeof id === "string" ? parseInt(id) : id;
  
      console.log("step 3 - userId:", userId);
  
      // Step 3: Extract startup ID from request body
      const { id: startupId } = req.body;
      
      if (!startupId || isNaN(Number(startupId))) {
        return res.status(400).json({ message: 'Invalid startup ID' });
      }
  
      const parsedStartupId = Number(startupId);
      console.log("step 4 - startupId:", parsedStartupId);
  
      // Step 4: Check if user's cart exists
      const cart = await prisma.cart.findUnique({
        where: { userId },
        include: { registrationStartup: true }
      });
  
      if (!cart) {
        return res.status(404).json({ message: 'Cart not found' });
      }
  
      console.log("step 5: Cart found");
  
      // Step 5: Check if startup is in the cart
      const isInCart = cart.registrationStartup.some(item => item.id === parsedStartupId);
      
      if (!isInCart) {
        return res.status(404).json({ message: 'Startup not found in cart' });
      }
  
      console.log("step 6: Startup is in cart");
  
      // Step 6: Remove startup from cart
      await prisma.cart.update({
        where: { userId },
        data: {
          registrationStartup: {
            disconnect: { id: parsedStartupId }
          }
        }
      });
  
      console.log("step 7: Startup removed from cart");
  
      // Step 7: Update cart category if it's now empty
      const updatedCart = await prisma.cart.findUnique({
        where: { userId },
        include: { 
          registrationStartup: true,
          services: true,
          registrationServices: true 
        }
      });
  
      if (updatedCart && 
          updatedCart.registrationStartup.length === 0 && 
          updatedCart.services.length === 0 && 
          updatedCart.registrationServices.length === 0) {
        // Cart is empty, update the category
        await prisma.cart.update({
          where: { userId },
          data: { category: null }
        });
        console.log("step 8: Cart is now empty, category updated");
      }
  
      return res.status(200).json({ 
        success: true,
        message: 'Startup registration removed from cart'
      });
  
    } catch (err) {
      console.error("Error in removeStartupFromCart:", err);
      return res.status(500).json({ message: 'Something went wrong', error: err });
    }
  };