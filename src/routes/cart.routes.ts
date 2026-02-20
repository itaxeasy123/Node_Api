import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import * as CartController from "../controllers/cart.controller";

const cartRouter = Router();

// Get the user's cart
// cartRouter.get("/", verifyToken, CartController.getCart);
cartRouter.get("/", verifyToken, CartController.getCart);

// Add or remove service/registration from cart
cartRouter.put("/", verifyToken, CartController.addToCart);

// Clear cart or a specific type (service/registration)
cartRouter.delete("/", verifyToken, CartController.removeFromCart);



export default cartRouter;

