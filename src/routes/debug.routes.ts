import { Router } from "express";
import { redisClient } from "../middlewares/redis-adder";

const router = Router();

router.get("/redis-token/:gstin", async (req, res) => {
  const { gstin } = req.params;
  const token = await redisClient.get(`gst-token:${gstin}`);
  return res.json({ gstin, token });
});

export default router;
