import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import * as CartController from "../controllers/cartstartup.controller";

const cartStartupRouter = Router();

// Get the user's cart
// cartRouter.get("/", verifyToken, CartController.getCart);

// Add or remove service/registration from cart
cartStartupRouter.put("/", verifyToken, CartController.addStartupToCart);


cartStartupRouter.get("/", verifyToken, CartController.getStartupItemsFromCart);

cartStartupRouter.delete("/", verifyToken, CartController.removeStartupFromCart);
// Clear cart or a specific type (service/registration)
// cartRouter.delete("/", verifyToken, CartController.removeFromCart);



export default cartStartupRouter;

