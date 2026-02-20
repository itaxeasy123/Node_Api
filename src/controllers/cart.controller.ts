import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import TokenService from '../services/token.service';

const prisma = new PrismaClient();

export const addToCart = async (req: Request, res: Response) => {
  try {
    console.log("step 1");

    // Step 1: Get token
    const token = TokenService.getTokenFromAuthHeader(req);
    if (!token) return res.status(401).json({ message: 'Unauthorized' });

    console.log("step 2");

    // Step 2: Verify token
    const user = TokenService.verifyToken(token);
    const { id } = user as { id: number | string };
    const userId = typeof id === "string" ? parseInt(id) : id;

    console.log("step 3 - userId:", userId);

    // Step 3.5: Ensure user exists
    const userExists = await prisma.user.findUnique({
      where: { id: userId }
    });

    if (!userExists) {
      return res.status(400).json({ message: 'User not found' });
    }

    // Step 4: Extract service data
    const {
      id: serviceId, title, overview, price, upcoming,
      endpoint, bodyParams, response, responseJSON, category
    } = req.body;

    console.log("step 4");

    // Step 5: Check if user's cart exists
    let cart = await prisma.cart.findUnique({
      where: { userId },
      include: { services: true }
    });

    console.log("step 5");

    // Step 6: Create cart if it doesn't exist
    if (!cart) {
      cart = await prisma.cart.create({
        data: {
          userId,
          services: {
            create: [] // optional at creation
          }
        },
        include: { services: true }
      });
    }

    console.log("step 6");

    // Step 7: Check if service is already added
    const isAlreadyInCart = cart.services.some(service => service.id === serviceId);
    if (isAlreadyInCart) {
      return res.status(400).json({ message: 'Service already in cart' });
    }

    console.log("step 7");

    // Step 8: Find or create the API service
    let apiService = await prisma.apiService.findUnique({ where: { id: serviceId } });

    if (!apiService) {
      apiService = await prisma.apiService.create({
        data: {
          id: serviceId,
          title,
          overview,
          price,
          upcoming,
          endpoint,
          bodyParams,
          response,
          responseJSON,
          category
        }
      });
    }

    console.log("step 8");

    // Step 9: Connect service to cart
    await prisma.cart.update({
      where: { userId },
      data: {
        services: {
          connect: { id: apiService.id }
        }
      }
    });

    console.log("step 9");

    return res.status(200).json({ message: 'Service added to cart' });

  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: 'Something went wrong', error: err });
  }
};

export const removeFromCart = async (req: Request, res: Response) => {
  try {
    // Step 1: Get token and verify user
    const token = TokenService.getTokenFromAuthHeader(req);
    if (!token) return res.status(401).json({ message: 'Unauthorized' });

    const user = TokenService.verifyToken(token);
    const { id: userId } = user as { id: number };

    // Step 2: Get service ID from request body or params
    const { serviceId } = req.body;
    if (!serviceId) {
      return res.status(400).json({ message: 'Service ID is required' });
    }

    // Step 3: Check if cart exists
    const cart = await prisma.cart.findUnique({
      where: { userId },
      include: { services: true }
    });

    if (!cart) {
      return res.status(404).json({ message: 'Cart not found' });
    }

    // Step 4: Check if the service is in the cart
    const isInCart = cart.services.some(service => service.id === serviceId);
    if (!isInCart) {
      return res.status(404).json({ message: 'Service not in cart' });
    }

    // Step 5: Disconnect the service from the cart
    await prisma.cart.update({
      where: { userId },
      data: {
        services: {
          disconnect: { id: serviceId }
        }
      }
    });

    return res.status(200).json({ message: 'Service removed from cart' });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: 'Something went wrong' });
  }
};


export const getCart = async (req: Request, res: Response) => {
  try {
    // ✅ userId middleware (verifyToken) se
    const userId = (req as any).user?.id;

    if (!userId) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized: User not logged in",
      });
    }

    // ✅ cart fetch
    const cart = await prisma.cart.findUnique({
      where: { userId },
      include: {
        services: true, // API services
      },
    });

    // ✅ cart nahi mila to EMPTY cart return karo (404 ❌)
    if (!cart) {
      return res.status(200).json({
        success: true,
        services: [],
        count: 0,
      });
    }

    return res.status(200).json({
      success: true,
      services: cart.services,
      count: cart.services.length,
    });
  } catch (error) {
    console.error("getCart error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};



// export const getCart = async (req: Request, res: Response) => {
//   try {
//     // Step 1: Get token from authorization header or cookies
//     const token = TokenService.getTokenFromAuthHeader(req);
//     if (!token) return res.status(401).json({ message: 'Unauthorized' });

//     // Step 2: Verify token and get user data
//     const user = TokenService.verifyToken(token);
//     const { id: userId } = user as { id: number };

//     // Step 3: Get the user's cart
//     const cart = await prisma.cart.findUnique({
//       where: { userId },
//       include: { services: true }
//     });

//     if (!cart) {
//       return res.status(404).json({ message: 'Cart not found' });
//     }

//     // Step 4: Return the cart data
//     return res.status(200).json(cart);
//   } catch (err) {
//     console.error(err);
//     return res.status(500).json({ message: 'Something went wrong' });
//   }
// }




