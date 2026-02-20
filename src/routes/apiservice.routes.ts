import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import ApiServiceController from '../controllers/apiservice.controller';
import SuperadminCheck from "../middlewares/super-admin";


const apirouter = Router();

apirouter.get('/get-all-apis',ApiServiceController.getallapis);
apirouter.post('/create-api',verifyToken,SuperadminCheck,ApiServiceController.createapi);

apirouter.post('/add-api',verifyToken,ApiServiceController.addApiToCart);

// Get the user's cart
apirouter.get('/',verifyToken,ApiServiceController.getCart);

// Remove an API from the cart
apirouter.delete('/delete-api',verifyToken,ApiServiceController.deleteApiFromCart);

// Subscribe to a single API from the cart
apirouter.post('/subscribe-single-api',verifyToken,ApiServiceController.subscribeToSingleApi);

// Subscribe to all APIs in the cart
apirouter.post('/subscribe-all-apis',verifyToken,ApiServiceController.subscribeToAllApis);

apirouter.get('/get-all-categories',verifyToken,ApiServiceController.getAllApiCategories);

apirouter.get('/get-all-subscriptions/:id',verifyToken,SuperadminCheck,ApiServiceController.getSubscriptionsById);

apirouter.get('/get-all-subscriptions',verifyToken,SuperadminCheck,ApiServiceController.getAllSubscriptions);

apirouter.get('/subscription-user',verifyToken,ApiServiceController.getAllSubscriptionsForUser);

apirouter.post('/create-subscription',verifyToken,ApiServiceController.createSubscription);

apirouter.put('/update-subscription', verifyToken, ApiServiceController.updateSubscription);


apirouter.get(
  '/get-transaction-status-counts',
  verifyToken,
  SuperadminCheck,
  ApiServiceController.getTransactionStatusCounts
);

export default apirouter;