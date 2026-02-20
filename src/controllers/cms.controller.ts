  import { Request, Response } from "express";
import cards from "../config/cards.json";
import cards1 from "../config/cards.json";
import { writeFile } from "fs/promises";
import { prisma } from "..";
import { join } from "path";
import { ZodError, z } from "zod";
import { formatErrorMessage } from "../lib/errorMessage";

const cmsFooterSchema = z.object({
  facebook: z.string().min(1, "Facebook link is required"),
  instagram: z.string().min(1, "Instagram link is required"),
  youtube: z.string().min(1, "Youtube link is required"),
  linkedin: z.string().min(1, "Linkedin link is required"),
  whatsapp: z.string().min(1, "Whatsapp link is required"),
  email: z.string().email("Email is invalid").min(1, "Email link is required"),
  phone: z.string().min(1, "Phone link is required"),
  address: z.string().min(1, "Address link is required"),
  addressAlternate: z.string().min(1, "Address alternate link is required"),
  copyright: z.string().min(1, "Copyright notice is required"),
});

export default class CMSController {
  static cardFilePath = join(__dirname, "..", "config/cards.json");

  static async updateCards(cards: object) {
    await writeFile(CMSController.cardFilePath, JSON.stringify(cards));
  }

  static getHomeScreen(req: Request, res: Response) {
    try {
      return res.status(200).json({
        success: true,
        data: cards,
      });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async updateMainHeadingcontent(req: Request, res: Response) {
    try {
      const { upper } = req.body;

      cards.home.upper = upper;

      await CMSController.updateCards(cards);

      return res.status(200).json({
        success: true,
        message: "Main Heading Updated",
        data: cards.home.upper,
      });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async updateNavCards(req: Request, res: Response) {
    try {
      const { navcards } = req.body;

      cards.home.navcards = navcards;

      await CMSController.updateCards(cards);

      return res.status(200).json({
        success: true,
        message: "Navcards Updated Successfully ",
        data: cards.home.navcards,
      });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async updatehomeCard(req: Request, res: Response) {
    try {
      const { cards } = req.body;

      cards1.home.cards = cards;

      await CMSController.updateCards(cards1);

      return res.status(200).json({
        success: true,
        message: "Cards Updated Successfully ",
        data: cards1.home.cards,
      });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async updateOnGoingprojects(req: Request, res: Response) {
    try {
      const { ongoingPro } = req.body;

      cards.home.ongoingPro = ongoingPro;

      await CMSController.updateCards(cards);

      return res.status(200).json({
        success: true,
        message: "On Going Projects Updated Successfully",
        data: cards.home.ongoingPro,
      });
    } catch (error) {
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async updateCorporateprojects(req: Request, res: Response) {
    try {
      const { corporatePro } = req.body;

      if (cards && cards.home) {
        cards.home.corporatePro = corporatePro;
      } else {
        return res
          .status(404)
          .json({ success: false, message: "Home or cards not found." });
      }

      cards.home.corporatePro = corporatePro;

      await CMSController.updateCards(cards);

      return res.status(200).json({
        success: true,
        message: "Carporate Projects Updated Successfully",
        data: cards.home.corporatePro,
      });
    } catch (error) {
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async getUserCount(req: Request, res: Response) {
    try {
      const count = await prisma.user.count();

      return res.status(200).json({ success: true, count });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async getStats(_req: Request, res: Response) {
    try {
      const totalUsers = await prisma.user.count();
      const totalEmails = await prisma.user.count({
        where: { email: { not: undefined } },
      });
      const totalPhoneNumbers = await prisma.user.count({
        where: { phone: { not: null } },
      });

      return res.status(200).json({
        success: true,
        data: {
          totalUsers,
          totalEmails,
          totalPhoneNumbers,
        },
      });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async getMailingList(req: Request, res: Response) {
    try {
      // Pagination parameters
      const { page = 1, limit = 10 } = req.query;
      const parsedPage = parseInt(page.toString(), 10);
      const parsedLimit = parseInt(limit.toString(), 10);

      // Calculate the offset based on the page and limit
      const offset = (parsedPage - 1) * parsedLimit;

      const mailingList = await prisma.user.findMany({
        where: {
          email: {
            not: undefined,
          },
        },
        select: {
          id: true,
          firstName: true,
          lastName: true,
          userType: true,
          email: true,
        },
        skip: offset,
        take: parsedLimit,
      });

      return res.status(200).json({ success: true, mailingList });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async getPhoneList(req: Request, res: Response) {
    try {
      // Pagination parameters
      const { page = 1, limit = 10 } = req.query;
      const parsedPage = parseInt(page.toString(), 10);
      const parsedLimit = parseInt(limit.toString(), 10);

      // Calculate the offset based on the page and limit
      const offset = (parsedPage - 1) * parsedLimit;

      const phoneList = await prisma.user.findMany({
        where: {
          phone: {
            not: null,
          },
        },
        select: {
          id: true,
          firstName: true,
          lastName: true,
          userType: true,
          phone: true,
        },
        skip: offset,
        take: parsedLimit,
      });

      return res.status(200).json({ success: true, phoneList });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  //   Footer
  static async updateFooter(req: Request, res: Response) {
    try {
      const socials = cmsFooterSchema.parse(req.body);
      cards.home.footer.socials = socials;

      await CMSController.updateCards(cards);
      return res.status(200).json({
        success: true,
        message: "Footer Updated",
      });
    } catch (error) {
      if (error instanceof ZodError) {
        console.log("🚀 ~ CMSController ~ updateFooter ~ error:", error);
        return res
          .status(400)
          .json({ success: false, message: formatErrorMessage(error) });
      }
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }

  static async getFooter(req: Request, res: Response) {
    try {
      const footerData = cards.home.footer;

      return res.status(200).json({
        success: true,
        message: "Footer links fetched successfully",
        data: footerData,
      });
    } catch (error) {
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong." });
    }
  }
}
