import { Request, Response } from "express";
import {
  Prisma,
  Invoice,
  Item,
  LedgerType,
  Party,
  PartyType,
  InvoiceType,
  InvoiceStatus,
} from "@prisma/client";
import { prisma } from "../index";

class InvoiceController {
  static async summary(req: Request, res: Response) {
    try {
      const { id: userId } = req.user!;

      const totalSales = await prisma.invoice.aggregate({
        where: {
          userId,
          type: { in: ["sales", "sales_return"] },
        },
        _sum: {
          totalAmount: true,
        },
      });

      const totalPurchases = await prisma.invoice.aggregate({
        where: {
          userId,
          type: { in: ["purchase", "purchase_return"] },
        },
        _sum: {
          totalAmount: true,
        },
      });

      const numberOfParties = await prisma.party.count({
        where: {
          userId,
        },
      });

      const numberOfItems = await prisma.item.count({
        where: {
          userId,
        },
      });

      return res.status(200).json({
        success: true,
        summary: {
          total_sales: totalSales._sum.totalAmount ?? 0,
          total_purchases: totalPurchases._sum.totalAmount ?? 0,
          number_of_parties: numberOfParties,
          number_of_items: numberOfItems,
        },
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const { id: userId } = req.user!;

      // Create the invoice
      const {
        invoiceNumber,
        gstNumber,
        type,
        partyId,
        totalAmount,
        totalGst,
        stateOfSupply,
        invoiceDate,
        dueDate,
        isInventory,
        cgst,
        sgst,
        igst,
        utgst,
        details,
        extraDetails,
        invoiceItems,
        modeOfPayment,
        credit = false,
        status,
      } = req.body;

      if (partyId) {
        const party = await prisma.party.findUnique({ where: { id: partyId } });

        if (!party) {
          return res
            .status(401)
            .json({ success: false, message: "Party not found" });
        }
      }

      const gstRegex = /^\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d[Z]{1}[A-Z\d]{1}$/;

      if (!gstRegex.test(gstNumber)) {
        return res.status(400).json({ error: "Invalid GST number" });
      }

      // Check if invoiceItems is defined and is an array

      const formattedInvoiceItems = invoiceItems
        ? invoiceItems.map(
            ({
              itemId,
              quantity,
              discount,
              taxPercent,
            }: {
              itemId: string;
              quantity: number;
              discount: number;
              taxPercent: number;
            }) => ({
              item: {
                connect: {
                  id: itemId,
                },
              },
              quantity,
              discount,
              taxPercent,
            })
          )
        : [];

      const invoiceData: Prisma.InvoiceCreateInput = {
        invoiceNumber,
        gstNumber,
        type,
        party: {
          connect: { id: partyId },
        },
        totalAmount,
        totalGst,
        stateOfSupply,
        cgst,
        sgst,
        igst,
        utgst,
        details,
        extraDetails,
        modeOfPayment,
        invoiceDate,
        dueDate,
        isInventory,
        credit,
        status,
        invoiceItems: {
          create: formattedInvoiceItems,
        },
        user: {
          connect: { id: userId },
        },
      };

      const invoice = await prisma.invoice.create({
        data: invoiceData,
        include: {
          invoiceItems: {
            include: {
              item: true,
            },
          },
        },
      });

      return res.status(201).json(invoice);
    } catch (error) {
      console.log("🚀 ~ InvoiceController ~ create ~ error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    try {
      const { id: userId } = req.user!;

      // Pagination parameters
      const { page = 1, limit = 10, type, search, status } = req.query;
      const parsedPage = parseInt(page.toString(), 10);
      const parsedLimit = parseInt(limit.toString(), 10);

      // Calculate the offset based on the page and limit
      const offset = (parsedPage - 1) * parsedLimit;

      // Build the where clause for filters
      const whereClause: Prisma.InvoiceWhereInput = { userId };

      if (type) {
        whereClause.type = type.toString() as InvoiceType;
      }

      if (search) {
        whereClause.OR = [
          { gstNumber: { contains: search.toString() } },
          { invoiceNumber: { contains: search.toString() } },
        ];
      }

      if (status) {
        if (!whereClause.OR) whereClause.OR = [];
        whereClause.OR.push({
          status: {
            equals: status.toString() as InvoiceStatus,
          },
        });
      }

      const count = await prisma.invoice.count({ where: whereClause });

      // Get all invoices for the user with pagination and filters
      const invoices: Invoice[] = await prisma.invoice.findMany({
        where: whereClause,
        skip: offset,
        take: parsedLimit,
        include: {
          invoiceItems: {
            include: {
              item: true,
            },
          },
        },
      });

      res.status(200).json({
        success: true,
        invoices,
        pagination: {
          pages: Math.ceil(count / parsedLimit),
          currentPage: parsedPage,
          limit: parsedLimit,
          totalItems: count,
        },
      });
    } catch (error) {
      console.log("🚀 ~ InvoiceController ~ getAll ~ error:", error);
      res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      const invoiceId = req.params.id;

      // Get the invoice by ID
      const invoice: Invoice | null = await prisma.invoice.findUnique({
        where: { id: invoiceId },
        include: {
          invoiceItems: {
            include: {
              item: true,
            },
          },
        },
      });

      if (!invoice) {
        res.status(404).json({ sucess: false, message: "Invoice not found" });
        return;
      }

      res.status(200).json(invoice);
    } catch (error) {
      res.status(500).json({ sucess: false, message: "Internal server error" });
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const { id: userId } = req.user!;
      console.log(userId)
      const {
        invoiceNumber,
        gstNumber,
        type,
        partyId,
        totalAmount,
        totalGst,
        stateOfSupply,
        invoiceDate,
        dueDate,
        isInventory,
        cgst,
        sgst,
        igst,
        utgst,
        details,
        extraDetails,
        invoiceItems,
        modeOfPayment,
        credit = false,
        status,
      } = req.body;

      const invoiceid = req.params.id;

      if (!invoiceid) {
        return res.status(400).json({
          success: false,
          message: "Invoice ID not provided",
        });
      }

      if (partyId) {
        const party = await prisma.party.findUnique({ where: { id: partyId } });

        if (!party) {
          return res
            .status(404)
            .json({ success: false, message: "Party not found" });
        }
      }

      const gstRegex = /^\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d[Z]{1}[A-Z\d]{1}$/;

      if (gstNumber && !gstRegex.test(gstNumber)) {
        return res.status(400).json({ error: "Invalid GST number" });
      }

      const formattedInvoiceItems =
        invoiceItems?.map(
          (item: { itemId: string; quantity: number; discount: number }) => ({
            itemId: item.itemId,
            quantity: item.quantity,
            discount: item.discount,
          })
        ) || [];

      const invoiceData: Prisma.InvoiceUpdateInput = {
        invoiceNumber,
        gstNumber,
        type,
        totalAmount,
        totalGst,
        stateOfSupply,
        cgst,
        sgst,
        igst,
        utgst,
        details,
        extraDetails,
        modeOfPayment,
        invoiceDate,
        dueDate,
        isInventory,
        credit,
        status,
        party: partyId ? { connect: { id: partyId } } : undefined,
        invoiceItems: {
          deleteMany: {},
          create: formattedInvoiceItems,
        },
        user: { connect: { id: userId } },
      };

      await prisma.invoice.update({
        where: { id: invoiceid },
        data: invoiceData,
        include: {
          invoiceItems: {
            include: {
              item: true,
            },
          },
        },
      });

      return res
        .status(200)
        .json({ success: true, message: "Successfully updated invoice" });
    } catch (error) {
      console.error("Error ==> ", error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async delete(req: Request, res: Response) {
    try {
      const invoiceId = req.params.id;

      const { id: userId } = req.user!;

      const invoice = await prisma.invoice.findFirst({
        where: { id: invoiceId, userId },
      });

      if (!invoice) {
        return res
          .status(200)
          .json({ success: false, message: "Invoice not found" });
      }

      await prisma.invoiceItem.deleteMany({ where: { invoiceId } });

      // Delete the invoice
      const deletedInvoice: Invoice | null = await prisma.invoice.delete({
        where: { id: invoiceId },
      });

      return res.status(200).json({ success: true, deletedInvoice });
    } catch (error) {
      console.log(error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async createParty(req: Request, res: Response) {
    try {
      const { id: userId } = req.user!;

      const date = new Date();

      const currentYear = date.getFullYear();
      const currentMonth = date.getMonth();

      // Extract data for creating the party and ledger
      const {
        partyName,
        type,
        gstin,
        pan,
        tan,
        upi,
        email,
        phone,
        address,
        bankName,
        bankAccountNumber,
        bankIfsc,
        bankBranch,
        openingBalance,
        year = currentYear,
        month = currentMonth,
      } = req.body;

      // Create the Party and its associated Ledger
      const party = await prisma.party.create({
        data: {
          partyName,
          type,
          gstin,
          pan,
          tan,
          upi,
          email,
          phone,
          address,
          bankName,
          bankAccountNumber,
          bankIfsc,
          bankBranch,
          userId,
          ledgers: {
            create: {
              ledgerName: partyName,
              ledgerType:
                type === PartyType.customer
                  ? LedgerType.accountsReceivable
                  : LedgerType.accountsPayable,
              openingBalance,
              year,
              month,
              userId,
            },
          },
        },
        include: {
          ledgers: true,
        },
      });

      return res.status(201).json({ success: true, party });
    } catch (error) {
      console.log(error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

static async updateParty(req: Request, res: Response) {
  try {
    const { id: userId } = req.user!;
    
    // Log all request parameters for debugging
    console.log("Request params:", req.params);
    console.log("Request URL:", req.originalUrl);
    console.log("Request body:", req.body);
    
    // Get party ID from different possible sources
    const partyId = req.params.id || req.body.id || req.query.id;
    
    console.log("Extracted partyId:", partyId);
    
    if (!partyId) {
      return res.status(400).json({ 
        success: false, 
        message: "Party ID is required but not found in request params, body, or query" 
      });
    }

    // Extract data for updating the party and ledger
    const {
      partyName,
      type,
      gstin,
      pan,
      tan,
      upi,
      email,
      phone,
      address,
      bankName,
      bankAccountNumber,
      bankIfsc,
      bankBranch,
      openingBalance,
      year,
      month,
    } = req.body;

    // First verify the party exists and belongs to this user
    const existingParty = await prisma.party.findFirst({
      where: {
        id: partyId,
        userId
      },
      include: {
        ledgers: true
      }
    });

    if (!existingParty) {
      return res.status(404).json({ 
        success: false, 
        message: "Party not found or you don't have permission to update it" 
      });
    }

    console.log("Found existing party:", existingParty.id);

    // Update the Party data - explicitly casting the ID to string to ensure it's handled correctly
    const updatedParty = await prisma.party.update({
      where: {
        id: String(partyId)
      },
      data: {
        partyName,
        type,
        gstin,
        pan,
        tan,
        upi,
        email,
        phone,
        address,
        bankName,
        bankAccountNumber,
        bankIfsc,
        bankBranch
      },
      include: {
        ledgers: true
      }
    });

    // If there's a ledger associated and opening balance/ledger data should be updated
    if (existingParty.ledgers.length > 0 && openingBalance !== undefined) {
      const ledgerId = existingParty.ledgers[0].id;
      
      // Update the ledger type if party type changed
      const ledgerType = type === PartyType.customer
        ? LedgerType.accountsReceivable
        : LedgerType.accountsPayable;
        
      await prisma.ledger.update({
        where: {
          id: ledgerId
        },
        data: {
          ledgerName: partyName, // Update ledger name to match party name
          ledgerType,
          openingBalance,
          ...(year && { year }),
          ...(month !== undefined && { month })
        }
      });
    }

    // Get the updated party with fresh ledger data
    const updatedPartyWithLedger = await prisma.party.findUnique({
      where: {
        id: partyId
      },
      include: {
        ledgers: true
      }
    });

    return res.status(200).json({ 
      success: true, 
      party: updatedPartyWithLedger 
    });
    
  } catch (error) {
    console.log("Error in updateParty:", error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
}

  static async deleteParty(req: Request, res: Response) {
    try {
      const partyId = req.params.id;

      const { id: userId } = req.user!;

      const party = await prisma.party.findFirst({
        where: { id: partyId, userId },
      });

      if (!party) {
        return res
          .status(200)
          .json({ success: false, message: "Party not found" });
      }

      // Delete the party
      const deletedParty: Party | null = await prisma.party.delete({
        where: { id: partyId },
      });

      return res.status(200).json({ success: true, deletedParty });
    } catch (error) {
      console.log(error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async createItem(req: Request, res: Response) {
    try {
      // Extract user ID from the authenticated request
      const { id: userId } = req.user!;
  
      // Check if the user exists
      const user = await prisma.user.findFirst({ where: { id: userId } });
      if (!user) {
        return res.status(404).json({
          success: false,
          message: "User does not exist",
        });
      }
  
      // Check if the user has inventory enabled
      if (!user.inventory) {
        return res.status(403).json({
          success: false,
          message: "Inventory is not enabled for this user. Cannot create items.",
        });
      }
  
      // Extract item details from the request body
      const {
        itemName,
        unit,
        price = 0, // Default values for numeric fields
        openingStock = 0,
        closingStock = 0,
        purchasePrice = 0,
        cgst = 0,
        sgst = 0,
        igst = 0,
        utgst = 0,
        taxExempted = false,
        description = "",
        hsnCode = "",
        categoryId,
        supplierId,
      } = req.body;
      console.log(req.body);
      // Validate required fields
      if (!itemName || !unit) {
        return res.status(400).json({
          success: false,
          message: "Missing required fields: itemName, unit",
        });
      }
  
      // Create the item in the database
      const item = await prisma.item.create({
        data: {
          itemName,
          unit,
          price,
          openingStock,
          closingStock,
          purchasePrice,
          cgst,
          sgst,
          igst,
          utgst,
          userId,
          taxExempted,
          description,
          hsnCode,
          categoryId,
          supplierId,
        },
      });
  
      // Respond with the created item
      return res.status(201).json({
        success: true,
        message: "Item created successfully.",
        item,
      });
    } catch (error) {
      console.error("Error creating item:", error);
      // Handle specific error scenarios if necessary
      return res.status(500).json({
        success: false,
        message: "Internal server error",
      });
    }
  }

  static async updateItem(req: Request, res: Response): Promise<void> {
    try {
      const itemId = req.params.id;
      const { itemName } = req.body;
      const { id: userId } = req.user!;
      const item = await prisma.item.findFirst({
        where: { id: itemId, userId },
      });

      if (!item) {
        res.status(200).json({ success: false, message: "Item not found" });
        return;
      }
      // Update the item
      const updatedItem: Item | null = await prisma.item.update({
        where: { id: itemId },
        data: {
          itemName,
        },
      });
      console.log("updateItem");
      console.log(updatedItem);
      res.status(200).json({ sucess: true, item: updatedItem });
    } catch (error) {
      res.status(500).json({ sucess: false, message: "Internal server error" });
    }
  }

  static async deleteItem(req: Request, res: Response) {
    try {
      const itemId = req.params.id;

      const { id: userId } = req.user!;

      const item = await prisma.item.findFirst({
        where: { id: itemId, userId },
      });

      if (!item) {
        return res
          .status(404)
          .json({ success: false, message: "Item does not exists." });
      }

      // Delete the invoice
      const deletedItem: Item | null = await prisma.item.delete({
        where: { id: itemId },
      });

      return res.status(200).json({ success: true, deletedItem });
    } catch (error) {
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async getAllParties(req: Request, res: Response) {
    try {
      const { id: userId } = req.user!;
  
      // Pagination parameters
      const { page = 1, limit = 10, search } = req.query;
      const parsedPage = parseInt(page.toString(), 10);
      const parsedLimit = parseInt(limit.toString(), 10);
  
      // Calculate the offset based on the page and limit
      const offset = (parsedPage - 1) * parsedLimit;
  
      // Construct the `where` clause
      const where: Prisma.PartyWhereInput = search
        ? {
            userId,
            partyName: {
              contains: search.toString(), // Use `contains` for string-based search
              mode: "insensitive", // Optional: Makes the search case-insensitive
            },
          }
        : {
            userId,
          };
  
      // Get all parties of the user with pagination
      const parties: Party[] = await prisma.party.findMany({
        where,
        skip: offset,
        take: parsedLimit,
      });
  
      return res.status(200).json({ success: true, parties });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async getPartyById(req: Request, res: Response) {
    try {
      const { id: userId } = req.user!;

      const partyId = req.params.id;

      // Get the party by ID
      const party: Party | null = await prisma.party.findFirst({
        where: { id: partyId, userId },
        include: {
          ledgers: true,
        },
      });

      if (!party) {
        return res
          .status(404)
          .json({ success: false, message: "Party not found" });
      }

      return res.status(200).json({ success: true, party });
    } catch (error) {
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

static async getAllItems(req: Request, res: Response) {
  try {
    const { id: userId } = req.user!;

    // Pagination parameters
    const { page = 1, limit = 10, search } = req.query;
    const parsedPage = parseInt(page.toString(), 10);
    const parsedLimit = parseInt(limit.toString(), 10);

    // Calculate the offset based on the page and limit
    const offset = (parsedPage - 1) * parsedLimit;

    // Construct the `where` clause
    const where: Prisma.ItemWhereInput = search
      ? {
          userId,
          itemName: {
            contains: search.toString(), // Use `contains` for string-based search
            mode: "insensitive", // Optional: Makes the search case-insensitive
          },
        }
      : {
          userId,
        };

    // Get all items of the user with pagination
    const items: Item[] = await prisma.item.findMany({
      where,
      skip: offset,
      take: parsedLimit,
    });

    return res.status(200).json({ success: true, items });
  } catch (error) {
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
}


  static async getItemById(req: Request, res: Response) {
    try {
      const { id: userId } = req.user!;

      const itemId = req.params.id;

      // Get the party by ID
      const item: Item | null = await prisma.item.findFirst({
        where: { id: itemId, userId },
      });

      if (!item) {
        return res
          .status(404)
          .json({ success: false, message: "Item not found" });
      }

      return res.status(200).json({ success: true, item });
    } catch (error) {
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }
}

export default InvoiceController;
