import { Request, Response } from "express";
import { prisma } from "..";
import { Ledger, LedgerType } from "@prisma/client";

export class LedgerController {
    static async createLedger(req: Request, res: Response) {
        try {

            if (!req.user) {
                return res.status(400).json({ success: false, message: "User information missing in request." });
            }
            const { id: userId } = req.user!;

            const { ledgerName, ledgerType, openingBalance } = req.body;
            prisma.ledger.findMany({where:{ledgerName:ledgerName}}).then((data)=>{
                if(data.length>0){
                    return res.status(400).json({ success: false, message: "Ledger Name already exists" });
                }
            })
            console.log("ledgerName :", ledgerName)
            const currentYear = new Date().getFullYear();
            const currentMonth = new Date().getMonth();
            const ledger = await prisma.ledger.create({
                data: { ledgerName, ledgerType, openingBalance, userId,year:currentYear,month:currentMonth},
            });

            return res.json(ledger);
        } catch (error) {
            console.log(error);
            return res.status(500).json({ success: false, message: "Error creating ledger" });
        }
    }

    static async updateLedger(req: Request, res: Response) {
        try {
          const ledgerId = req.params.id;

          
          if (!ledgerId) {
            return res.status(400).json({ success: false, message: "Ledger ID is missing in the request." });
          }

          const { ledgerName, ledgerType, openingBalance } = req.body;

          const updatedLedger = await prisma.ledger.update({
            where: { id: ledgerId },
            data: { ledgerName, ledgerType, openingBalance },
          });

          return res.json(updatedLedger);
        } catch (error) {
          console.error(error);
          return res.status(500).json({ success: false, message: "Error updating ledger" });
        }
      }

      static async deleteLedger(req: Request, res: Response) {
        try {
          const ledgerId = req.params.id;

          if (!ledgerId) {
            return res.status(400).json({ success: false, message: "Ledger ID is missing in the request." });
          }

          console.log("id :", ledgerId)

          const deletedLedger = await prisma.ledger.delete({
            where: { id: ledgerId },
          });

          return res.json({ success: true, deletedLedger, message: "Ledger deleted successfully" });
        } catch (error) {
          console.error(error);
          return res.status(500).json({ success: false, message: "Error deleting ledger" });
        }
      }

    static async getLedgers(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;

            const ledgers = await prisma.ledger.findMany({
                where: {
                    userId,
                }
            });
            return res.status(200).json({ success: true, ledgers });
        } catch (error) {
            return res.status(500).json({ success: false, message: "Error fetching ledgers" });
        }
    }

    static async getLedgerById(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;

            const ledgerId = req.params.id;

            const ledger: Ledger | null = await prisma.ledger.findFirst({ where: { id: ledgerId, userId }});

            if (!ledger) {
                return res.status(404).json({ success: false, message: 'Ledger not found' });
            }

            return res.status(200).json({ success: true, ledger });
        } catch (error) {
            return res.status(500).json({ success: false, message: 'Internal server error' });
        }
    }

    static async getLedgerByPartyId(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;

            const date = new Date();

            const currentYear = date.getFullYear();
            const currentMonth = date.getMonth();

            const { id: partyId } = req.params;

            const { year, month } = req.query;

            const ledger: Ledger | null = await prisma.ledger.findFirst({ where: {
                partyId,
                year: year ? parseInt(year as string) : currentYear,
                month: month ? parseInt(month as string) : currentMonth,
                userId,
            }});

            if (!ledger) {
                return res.status(404).json({ success: false, message: 'Ledger not found' });
            }

            return res.status(200).json({ success: true, ledger });
        } catch (error) {
            return res.status(500).json({ success: false, message: 'Internal server error' });
        }
    }
    static async search(req:Request,res:Response){
        try {
            const { id: userId } = req.user!;
            const { search } = req.query;
            const ledgers = await prisma.ledger.findMany({
                where: {
                    userId,
                    OR: [
                        {
                            ledgerName: {
                                contains: search as string,
                                mode: "insensitive",
                            },
                        },
                        {
                            ledgerType: search as LedgerType,
                        },
                    ],
                },
            });
            return res.status(200).json({ success: true, ledgers });
        } catch (error) {
            return res.status(500).json({ success: false, message: "Error fetching ledgers" });
        }
    }
    static async getCustomerCount(req: Request, res: Response) {
        try {
            const { id: userId} = req.user!;
            const {ledgertype,year,month} = req.body;
            const partyIds = await prisma.ledger.findMany({
                where: { userId ,ledgerType:ledgertype,year:year,month:month},
                select: { partyId: true }
            });

            const uniquePartyIds = [...new Set(partyIds.map(p => p.partyId))];
            const count = uniquePartyIds.length;

            return res.status(200).json({ success: true, unique:uniquePartyIds,count:count });
        } catch (error) {
            return res.status(500).json({ success: false, message: "Error fetching customer count" });
        }
    }
    static async getInactivePartyCount(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;
            const { ledgertype, year, month } = req.body;

            // Step 1: Get all unique party IDs based on filters
            const partyIds = await prisma.ledger.findMany({
                where: { userId, ledgerType: ledgertype, year: year, month: month },
                select: { partyId: true },
            });
            const uniquePartyIds = [...new Set(partyIds.map(p => p.partyId))];

            // Step 2: Get the date 1 year ago
            const oneYearAgo = new Date();
            oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1);

            // Step 3: Find active party IDs through transactions
            const activeTransactions = await prisma.transaction.findMany({
                where: { date: { gte: oneYearAgo } },
                select: { ledgerId: true },
            });

            // Step 4: Map active transactions to ledgers and then to parties
            const activeLedgerIds = activeTransactions.map(t => t.ledgerId);
            const activeParties = await prisma.ledger.findMany({
                where: { id: { in: activeLedgerIds } },
                select: { partyId: true },
            });
            const activePartyIds = new Set(activeParties.map(p => p.partyId));

            // Step 5: Find inactive parties
                        const inactiveCustomers = await prisma.party.findMany({
                            where: {
                                id: { in: uniquePartyIds.filter((pid): pid is string => pid !== null && !activePartyIds.has(pid)) },
                            },
                            select: { id: true, partyName: true }, // Use correct field names
                        });

            // Step 6: Return the result
            const count = inactiveCustomers.length;
            return res.status(200).json({
                success: true,
                inactiveCustomers,
                count,
            });
        } catch (error) {
            console.error(error);
            return res.status(500).json({ success: false, message: "Error fetching customer count" });
        }
    }
    
    static async getfavouraiteparty(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;
            const { ledgertype, year, month } = req.body;

            // Step 1: Get all unique partyIds based on filters
            const partyIds = await prisma.ledger.findMany({
                where: { userId, ledgerType: ledgertype, year: year, month: month },
                select: { partyId: true },
            });

            const uniquePartyIds = [...new Set(
                partyIds
                    .map((p) => p.partyId)
                    .filter((id): id is string => id !== null)
            )];

            // Step 2: Get the date 3 months ago
            const threeMonthsAgo = new Date();
            threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3);

            // Step 3: Find active customers
            const activeCustomers = await prisma.party.findMany({
                where: {
                    id: { in: uniquePartyIds },
                    ledgers: {
                        some: {
                            transactions: {
                                some: { date: { gte: threeMonthsAgo } },
                            },
                        },
                    },
                },
                select: { id: true, partyName: true }, // Use partyName instead of name
            });

            // Step 4: Return the result
            const count = activeCustomers.length;
            return res.status(200).json({
                success: true,
                activeCustomers,
                count,
            });
        } catch (error) {
            console.error(error);
            return res.status(500).json({ success: false, message: "Error fetching customer count" });
        }
    }
    
}
export class JournalEntryController {
    static async createJournalEntry(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;

            const { entryDate, description, transactions } = req.body;

            const journalEntry = await prisma.journalEntry.create({
                data: {
                    entryDate,
                    description,
                    userId,
                    transactions: {
                        create: transactions.map((transaction: any) => ({
                            userId,
                            ...transaction
                        }))
                    }
                },
            });
            return res.status(200).json({ success: true, journalEntry });
        } catch (error) {
            return res.status(500).json({ success: false, message: "Error creating journal entry" });
        }
    }

    static async getJournalEntries(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;
            const journalEntries = await prisma.journalEntry.findMany({
                where: {
                    userId,
                }
            });
            return res.status(200).json({ success: true, journalEntries });
        } catch (error) {
            return res.status(500).json({ success: false, message: "Error fetching journal entries" });
        }
    }
}

export class TransactionController {
    static async getTransactions(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;
            const { ledgerId } = req.body;

            const transactions = await prisma.transaction.findMany({
                where: {
                    userId,
                    ledgerId,
                }
            });
            return res.status(200).json({ success: true, transactions });
        } catch (error) {
            return res.status(500).json({ success: false, message: "Error fetching transactions" });
        }
    }
    static async daybook(req: Request, res: Response) {
        try {
            const { id: userId } = req.user!;
            const { date } = req.query;
            const daybook = await prisma.transaction.findMany({
                where: {
                    userId,
                    date: new Date(date as string),
                },
                include: {
                    ledger: true,
                },
            });
            return res.status(200).json({ success: true, daybook });
        } catch (error) {
            return res.status(500).json({ success: false, message: "Error fetching daybook" });
        }
    }
}