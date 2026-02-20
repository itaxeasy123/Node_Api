import { Request, Response } from "express";
import { prisma } from "..";
import { Gstr1_4A, Prisma } from "@prisma/client";


function findUniqueGSTRecords(records: Gstr1_4A[]) {
    const uniqueRecordsMap = new Map<string, Gstr1_4A>();
    records.forEach(record => {
        if (!uniqueRecordsMap.has(record.GSTN)) {
            uniqueRecordsMap.set(record.GSTN, record);
        }
    });
    const uniqueRecords = Array.from(uniqueRecordsMap.values());
    const uniqueGSTNs = Array.from(uniqueRecordsMap.keys());

    return { uniqueRecords, uniqueGSTNs };
}

export default class GSTR1Controller {
    // GSTR1 - 4A
    static async create (req:Request,res:Response){

        try {
              const user = req.user!; 
              
              const {LegalName,GSTN,pos,invoice_No,invoice_date,
              invoice_value,rate,nature,source,cgst,igst,
              sgst,supply_type,fy,period,trade_Name,taxpayer_type,processed_records,status} =req.body
      
              if(!LegalName || !GSTN || !invoice_No || !pos  ){
                return  res.status(400).json({success:false,message:"Please fill Required Feilds"})
              }
      
              const gstr1  = await prisma.gstr1_4A.create({
                  data:{
                  userId: user.id,
                  LegalName,
                  GSTN,
                  pos,
                  invoice_No,
                  invoice_date,
                  invoice_value,
                  rate,nature,
                  source,
                  cgst,
                  igst,
                  sgst,
                  supply_type,
                  fy,
                  period,
                  trade_Name,
                  taxpayer_type,
                  processed_records,
                  status
                  }
              })
      
              res.status(201).
              json({success:true,
              message:"successfully created Record",
              data:gstr1})
    
        
        } catch (error) {
            return res.status(500)
            .json({ success: false, 
            message: 'Internal server error' });
        }

    }

    static async getsingle (req: Request,res: Response){
        try {
            const id=req.params.id;
            const user = req.user!;

            if(!id){
                return res.status(404)
                .json({success:false,message:"id Prarams required for this operation"})
            }

            const single= await prisma.gstr1_4A.findFirst({where:{id:+id,userId:user.id}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            return res.status(200).json({success:true,message:"record Found",data:single});
            
        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"})    
        }
    }

    static async getll ( req: Request,res: Response){
        try {
            const user = req.user!; 

            const allgstr1 = await prisma.gstr1_4A.findMany({
                where:{userId:user.id}
            })

            if(allgstr1.length === 0){
                res.status(404)
                .json({success:false,message:"no Records found"})
            }

            res.status(200)
            .json({success:true,
            message:"reccords fetch successfully",
            data:allgstr1})

        } catch (error) {
            return res.status(500)
            .json({ success: false, 
            message: 'Internal server error' });
        }
    }

    static async getallview4A ( req: Request,res: Response){
        try {
            const allRecords = await prisma.gstr1_4A.findMany(); // Assuming gstr1_4A is your Prisma model
    
            const { uniqueRecords, uniqueGSTNs  } = findUniqueGSTRecords(allRecords);
            
            if (uniqueRecords.length === 0) {
                return res.status(404).json({ success: false, message: "No records found" });
            }

            const getgstcount = await Promise.all(uniqueGSTNs.map(item => {
                return prisma.gstr1_4A.count({
                    where: {
                        GSTN: item
                    }
                });
            }));
            
            if (getgstcount.length === 0) {
                return res.status(404).json({ success: false, message: "No records found" });
            }

            
            res.status(200).json({ success: true, message: "Records with unique GSTN fetched successfully", data: uniqueRecords,getgstcount });
        } catch (error) {
            console.error('Error:', error);
            res.status(500).json({ success: false, message: 'Internal server error' });
        }
    }

    static async getbygstin4A ( req: Request, res: Response){
        try {
            const GSTN=req.params.id;
            
            if(!GSTN){
                return res.status(404)
                .json({success:false,message:"GSTN Prarams required for this operation"})
            }

            const single= await prisma.gstr1_4A.findFirst({where:{GSTN:GSTN}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            return res.status(200).json({success:true,message:"record Found",data:single});
            
        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"})    
        }
    }

    static async update (req: Request, res: Response){
        try {

     const {LegalName,GSTN,pos,invoice_No,invoice_date,
     invoice_value,rate,nature,source,cgst,igst,
     sgst,supply_type,fy,period, taxpayer_type,trade_Name,
     processed_records,status} =req.body


           const id= req.params.id;

           const user = req.user!;

           if (!id) {
            return res.
            status(400).
            json({ success: true,
                 message: 'Post ID is required for this operation' });
           }

          if(!LegalName || !GSTN || !invoice_No || !pos  ){
          return  res.status(400).json({success:false,message:"Please fill Required Feilds"})
        }
        const gstr1  = await prisma.gstr1_4A.update({
            where:{id:+id},
            data:{
            userId: user.id,
            LegalName,
            GSTN,
            pos,
            invoice_No,
            invoice_date,
            invoice_value,
            rate,nature,
            source,
            cgst,
            igst,
            sgst,
            supply_type,
            fy,
            period,
            trade_Name,
            taxpayer_type,
            processed_records,
            status
            }
        })

        res.status(201).
        json({success:true,          
        message:"successfully updated Record",
        data:gstr1})
        
        } catch (error) {
            return res.status(500)
            .json({ success: false, 
            message: 'Internal server error' });
        }
    }

    static async delete (req: Request, res: Response){
        try {
            const id=req.params.id;
            const user = req.user!;

            if(!id){
                return res.status(404)
                .json({success:false,message:"id Prarams required for this operation"})
            }

            const single= await prisma.gstr1_4A.findFirst({where:{id:+id,userId:user.id}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            await prisma.gstr1_4A.delete({where:{id:+id}})

            return res.status(200).json({success:true,message:"record deleted "})
            
        } catch (error) {
            return res.status(500).json({success:false,message:" internal server error: "})
        }
    }

    // GSTR1 - 5A 

    static async create5A (req:Request, res:Response){
       try {
        const  user = req.user!; 

        const {pos,invoice_No,supply_type,invoice_date,total_taxable_value,integrated_tax,
            cess,invoice_value,total_invoice_value,gstr1_5A_items} =req.body

            const formattedGSTR15AItems = gstr1_5A_items
                ? gstr1_5A_items.map(({ tax_rate, Ammmout_of_tax, Igst,cess }: { tax_rate: string; Ammmout_of_tax: string; Igst: string ,cess:string}) => ({
                    tax_rate,
                    Ammmout_of_tax,
                    Igst,
                    cess
                }))
                : [];
                const totalItems = await prisma.gstr1_5A.count();
                const nextSrNo = totalItems + 1;

            const GSTR1_5A_DATA : Prisma.Gstr1_5ACreateInput  =    {
                sr_no:nextSrNo,
                pos,
                invoice_No,
                supply_type,
                invoice_date,
                invoice_value,
                total_taxable_value,
                integrated_tax,
                cess,
                total_invoice_value,
                gstr1_5A_items:{
                    create :formattedGSTR15AItems
                },
                user: {
                    connect: { id: user.id },
                },
            }  

            const GSTR1_5A = await prisma.gstr1_5A.create({
                data:GSTR1_5A_DATA,
                include:{
                    gstr1_5A_items:true
                }
            })

             return res.status(201)
            .json({success:true,message:"successfully Created Record",data:GSTR1_5A});
       } catch (error) {
        return res.status(500).json({success:false,message:"internal server error"})
       }
    }

    static async update5A (req:Request, res:Response){
        try {
     
            const {pos,invoice_No,supply_type,invoice_date,total_taxable_value,integrated_tax,
                cess,invoice_value,total_invoice_value,gstr1_5A_items} =req.body
             const  user = req.user!; 

             const id =req.params.id;
    
             if (!id) {
                return res.
                status(400).
                json({ success: true,
                     message: 'Post ID is required for this operation' });
               }
 
               const formattedGSTR15AItems = gstr1_5A_items
               ? gstr1_5A_items.map(({ tax_rate, Ammmout_of_tax, Igst,cess }: { tax_rate: string; Ammmout_of_tax: string; Igst: string ,cess:string}) => ({
                   tax_rate,
                   Ammmout_of_tax,
                   Igst,
                   cess
               }))
               : [];

 
             const GSTR1_5A_DATA : Prisma.Gstr1_5AUpdateInput  =    {
                pos,
                invoice_No,
                supply_type,
                invoice_date,
                total_taxable_value,
                integrated_tax,
                cess,
                invoice_value,
                total_invoice_value,
                gstr1_5A_items:{
                    create :formattedGSTR15AItems
                },
                user: {
                    connect: { id: user.id },
                },
             }  
 
             const GSTR1_5A = await prisma.gstr1_5A.update({
                where:{id:+id},
                 data:GSTR1_5A_DATA,
                 include:{
                     gstr1_5A_items:true
                 }
             })

             if(!GSTR1_5A){
                return res.status(500).json({success:false,message:"user not created This Record"})
             }
 
             return res.status(201)
             .json({success:true,message:"successfully Updated Record",data:GSTR1_5A});
        } catch (error) {
         return res.status(500).json({success:false,message:"internal server error"})
        }
     }

    static async getall5A (req: Request, res: Response){
        try {
            const user = req.user!; 

            const allgstr1 = await prisma.gstr1_5A.findMany({
                where:{userId:user.id}
            })

            if(allgstr1.length === 0){
               return res.status(404)
                .json({success:false,message:"no Records found"})
            }

          return  res.status(200)
            .json({success:true,
            message:"reccords fetch successfully",
            data:allgstr1})

        } catch (error) {
            return res.status(500)
            .json({ success: false, 
            message: 'Internal server error' });
        }
    } 

    static async delete5A (req: Request, res: Response){
        try {
            const id=req.params.id;
            const user = req.user!;

            if(!id){
                return res.status(404)
                .json({success:false,message:"id Prarams required for this operation"})
            }

            const single= await prisma.gstr1_5A.findFirst({where:{id:+id,userId:user.id}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            await prisma.gstr1_5A.delete({where:{id:+id}})

            const remainingItems = await prisma.gstr1_5A.findMany();
            for (let i = 0; i < remainingItems.length; i++) {
              await prisma.gstr1_5A.update({
                where: {
                  id: remainingItems[i].id
                },
                data: {
                  sr_no: i + 1
                }
              });
            }

            return res.status(200).json({success:true,message:"record deleted "})
            
        } catch (error) {
            return res.status(500).json({success:false,message:" internal server error: "})
        }
    }

    // GSTR1 - 6A
    static async create6A (req: Request, res: Response){
     try {
         const  user = req.user!;
       
        const {pos,invoice_no,supply_type,invoice_data,invoice_value,
            total_value,gst_payement,total_taxable_value,
            integarted_tax,cess,gstr1_6A_items} =req.body;

            if(!pos || !invoice_no || !supply_type || !invoice_data || !invoice_value 
                || !total_value || !gst_payement || !total_taxable_value
                 || !integarted_tax || !cess || gstr1_6A_items.length===0){
                return res.status(404).json({success:false,message:"Please fill Required fields"})
            }

            if(!user.id){
                return res.status(404).json({success: false,message:"User Not found"});
             }

            const formatted_GSTR1_6A_Items = gstr1_6A_items
            ? gstr1_6A_items.map(({ pecentage, integrated_value, cgst,sgst }: { pecentage: string; integrated_value: string; cgst: string ,sgst:string}) => ({
                pecentage,
                integrated_value,
                cgst,
                sgst
            }))
            : [];

            const totalItems = await prisma.gstr1_6A.count();
            const nextSrNo = totalItems + 1;

            const gstr1_6A_data : Prisma.Gstr1_6ACreateInput =  {
                sr_no:nextSrNo,
                pos,
                invoice_no,
                supply_type,
                invoice_data,
                invoice_value,
                total_value,
                gst_payement,
                total_taxable_value,
                integarted_tax,
                cess,
                gstr1_6A_items:{
                    create :formatted_GSTR1_6A_Items
                },
                user: {
                    connect: { id: user.id },
                },
            }
            const GSTR1_6A = await prisma.gstr1_6A.create({
                data:gstr1_6A_data,
                include:{
                    gstr1_6A_items:true
                }
            })

            return res.status(201)
            .json({success:true,message:"successfully Created Record",data:GSTR1_6A});

     } catch (error) {
     return res.status(500)
     .json({success:false,message:"internal Server Error"})
     }
    }

    static async update6A(req: Request, res: Response) {
        try {
            const user = req.user!;
            const { pos, invoice_no, supply_type, invoice_data, invoice_value,
                total_value, gst_payement, total_taxable_value,
                integarted_tax, cess, gstr1_6A_items } = req.body;
            const id = req.params.id;
    
            if (!pos || !invoice_no || !supply_type || !invoice_data || !invoice_value
                || !total_value || !gst_payement || !total_taxable_value
                || !integarted_tax || !cess || gstr1_6A_items.length === 0) {
                return res.status(400).json({ success: false, message: "Please fill all required fields" });
            }
    
            if (!user.id) {
                return res.status(404).json({ success: false, message: "User not found" });
            }
    
            if (!id) {
                return res.status(400).json({ success: false, message: 'Post ID is required for this operation' });
            }

           const  notexist= await prisma.gstr1_6A.findFirst({
                where:{
                    id:+id
                }
            })

            if(!notexist){
                return res.status(400).json({ success: false, message: 'Record Not Found !!' });
            }
    
            const formattedGstr1_6AItems = gstr1_6A_items.map(({ pecentage, integrated_value, cgst, sgst }: { pecentage: string; integrated_value: string; cgst: string, sgst: string }) => ({
                pecentage,
                integrated_value,
                cgst,
                sgst
            }));
    
            const gstr1_6A_data: Prisma.Gstr1_6AUpdateInput = {
                pos,
                invoice_no,
                supply_type,
                invoice_data,
                invoice_value,
                total_value,
                gst_payement,
                total_taxable_value,
                integarted_tax,
                cess,
                gstr1_6A_items: {
                    create: formattedGstr1_6AItems
                },
                user: {
                    connect: { id: user.id },
                },
            };
    
            const updatedGstr1_6A = await prisma.gstr1_6A.update({
                where: { id: parseInt(id) },
                data: gstr1_6A_data,
                include: {
                    gstr1_6A_items: true
                }
            });
    
            return res.status(200).json({ success: true, message: "Record updated successfully", data: updatedGstr1_6A });
    
        } catch (error) {
            console.error("Error:", error);
            return res.status(500).json({ success: false, message: "Internal server error" });
        }
    }

    static async getall6A (req: Request, res: Response){
        try {
            const user = req.user!; 

            const allgstr1 = await prisma.gstr1_6A.findMany({
                where:{userId:user.id}
            })

            if(allgstr1.length === 0){
               return res.status(404)
                .json({success:false,message:"no Records found"})
            }

          return  res.status(200)
            .json({success:true,
            message:"reccords fetch successfully",
            data:allgstr1})

        } catch (error) {
            return res.status(500)
            .json({ success: false, 
            message: 'Internal server error' });
        }
    } 

    static async delete6A (req: Request, res: Response){
        try {
            const id=req.params.id;
            const user = req.user!;

            if(!id){
                return res.status(404)
                .json({success:false,message:"id Prarams required for this operation"})
            }

            const single= await prisma.gstr1_6A.findFirst({where:{id:+id,userId:user.id}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            await prisma.gstr1_6A.delete({where:{id:+id}})

            const remainingItems = await prisma.gstr1_6A.findMany();
            for (let i = 0; i < remainingItems.length; i++) {
              await prisma.gstr1_6A.update({
                where: {
                  id: remainingItems[i].id
                },
                data: {
                  sr_no: i + 1
                }
              });
            }

            return res.status(200).json({success:true,message:"record deleted Successfully !!"}); 
            
        } catch (error) {
            return res.status(500).json({success:false,message:" internal server error !! "})
        }
    }

    // GSTR1-7B2C

    static async Create7B (req: Request, res: Response){
        try {
            const  user = req.user!;

            const { gstn ,pos ,taxable_value ,supply_type ,
                rate , central_tax ,state_tax ,cess ,place_of_supply ,
                total_taxable , integrated } =req.body;

            if(!gstn || !pos || !taxable_value  || !supply_type 
              || !rate || !central_tax || !state_tax || !cess){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"})
            }

                    if(!user.id){
                        return res.status(404).json({success: false,message:"User Not found"});
                     }

                     const totalItems = await prisma.gstr1_7B.count();
                     const nextSrNo = totalItems + 1;

                     const gstr1_7B_Data  = await prisma.gstr1_7B.create({
                        data:{
                        gstn,
                        sr_no: nextSrNo,
                        pos,
                        taxable_value,
                        supply_type,
                        rate,
                        central_tax,
                        state_tax,
                        cess,
                        place_of_supply,
                        total_taxable,
                        integrated,
                        userId:user.id
                 }
            })

            res.status(201).
            json({success:true,          
            message:"successfully created Record",
            data:gstr1_7B_Data})

        } catch (error) {
            return res.status(404)
            .json({success:false,message:"internal server error"})
        }
    }

    static async update7B (req: Request, res: Response){
        try {
            const  user = req.user!;

            const id =req.params.id;

            const { gstn ,pos ,taxable_value ,supply_type ,
                rate , central_tax ,state_tax ,cess ,place_of_supply ,
                total_taxable , integrated } =req.body;

            if(!gstn || !pos || !taxable_value  || !supply_type 
              || !rate || !central_tax || !state_tax || !cess){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"})
            }

                    if(!user.id){
                        return res.status(404).json({success: false,message:"User Not found"});
                     }

                     if (!id) {
                        return res.status(400).json({ success: false, message: 'Post ID is required for this operation' });
                    }

                    const  notexist= await prisma.gstr1_7B.findFirst({
                        where:{
                            id:+id
                        }
                    })
        
                    if(!notexist){
                        return res.status(400).json({ success: false, message: 'Record Not Found !!' });
                    }

                     const gstr1_7B_Data_update  = await prisma.gstr1_7B.update({
                       where:{id:+id},
                        data:{
                        gstn,
                        pos,
                        taxable_value,
                        supply_type,
                        rate,
                        central_tax,
                        state_tax,
                        cess,
                        place_of_supply,
                        total_taxable,
                        integrated,
                        userId:user.id
                 }
            })

            res.status(200).
            json({success:true,          
            message:"successfully Updated Record",
            data:gstr1_7B_Data_update})

        } catch (error) {
            return res.status(404)
            .json({success:false,message:"internal server error"})
        }
    }

    static async  getall7B (req: Request, res: Response){
        try {
            const user = req.user!; 

            const allgstr1 = await prisma.gstr1_7B.findMany({
                where:{userId:user.id}
            })

            if(allgstr1.length === 0){
               return res.status(404)
                .json({success:false,message:"no Records found"})
            }

          return  res.status(200)
            .json({success:true,
            message:"reccords fetch successfully",
            data:allgstr1})

        } catch (error) {
            return res.status(500)
            .json({ success: false, 
            message: 'Internal server error' });
        }
    }

    static async delete7B (req: Request, res: Response){
        try {
            const id=req.params.id;
            const user = req.user!;

            if(!id){
                return res.status(404)
                .json({success:false,message:"id Prarams required for this operation"})
            }

            const single= await prisma.gstr1_7B.findFirst({where:{id:+id,userId:user.id}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            await prisma.gstr1_7B.delete({where:{id:+id}})

            const remainingItems = await prisma.gstr1_7B.findMany();
            for (let i = 0; i < remainingItems.length; i++) {
              await prisma.gstr1_7B.update({
                where: {
                  id: remainingItems[i].id
                },
                data: {
                  sr_no: i + 1
                }
              });
            }

            return res.status(200).json({success:true,message:"record deleted Successfully !!"}); 
            
        } catch (error) {
            return res.status(500).json({success:false,message:" internal server error !! "})
        }
    }

    // GSTR1 - 8ABCD

    static async create8ABCD (req: Request, res: Response){
        try {
            const  user = req.user!;
            const { gstn ,pos ,taxable_value ,supply_type ,
                rate ,central_tax ,state_tax ,cess }=req.body;

                if(!gstn || !pos || !taxable_value  || !supply_type 
                    || !rate || !central_tax || !state_tax || !cess){
                    return res.status(404)
                    .json({success:false,message :"Please fill Required fields"})
           }
           if(!user.id){
            return res.status(404).json({success: false,message:"User Not found"});
         }

         const totalItems = await prisma.gstr1_8ABCD.count();
         const nextSrNo = totalItems + 1;    
         
         const data = await prisma.gstr1_8ABCD.create({
            data:{
                sr_no: nextSrNo,
                gstn,
                pos,
                taxable_value ,
                supply_type ,
                rate ,
                central_tax ,
                state_tax ,
                cess,
                userId:user.id
            }
         })

         return res.status(201).json({success:true,message:"successfully created Record !!",data:data})
            
        } catch (error) {
            return res.status(500).json({success:false,message:" internal server error !! "})
        }
    }

    static async getsingle8ABCD ( req: Request, res: Response){
        try {
            const id=req.params.id;
            const user = req.user!;

            if(!id){
                return res.status(404)
                .json({success:false,message:"id Prarams required for this operation"})
            }

            const single= await prisma.gstr1_8ABCD.findFirst({where:{id:+id,userId:user.id}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            return res.status(200).json({success:true,message:"record Found",data:single});
            
        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"})    
        }
    }

    // GSTR1 - 9B

    static async create9B (req: Request, res: Response){
        try {
            const  user = req.user!;
            const {gstn,recipient_name,name_as_master ,
                debit_credit_note_no ,debit_credit_note_date ,state_tax ,
                note_type ,supply_type ,items_details ,select_rate ,
                note_values ,state_tax_rs ,central_tax ,cess } =req.body;

                if(!recipient_name){
                    return res.status(404)
                    .json({success:false,message :"Please fill Required fields"}) 
                }

                if(!user.id){
                    return res.status(404).json({success: false,message:"User Not found"});
                 }

                 const totalItems = await prisma.gstr1_9B.count();
                 const nextSrNo = totalItems + 1;   

                 const data = await prisma.gstr1_9B.create({
                    data:{
                        gstn,
                        sr_no:nextSrNo,
                        recipient_name,
                        name_as_master ,
                        debit_credit_note_no ,
                        debit_credit_note_date ,
                        state_tax ,
                        note_type ,
                        supply_type ,
                        items_details ,
                        select_rate ,
                        note_values ,
                        state_tax_rs ,
                        central_tax ,
                        cess,
                        userId:user.id
                    }
                 })

          
        return res.status(201).
        json({success:true,message:"successfully created Record !!"
        ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"})    
        }
    }

    static async update9B (req: Request, res: Response){
        try {
            const  user = req.user!;
            const id = req.params.id
            const {gstn,recipient_name,name_as_master ,
                debit_credit_note_no ,debit_credit_note_date ,state_tax ,
                note_type ,supply_type ,items_details ,select_rate ,
                note_values ,state_tax_rs ,central_tax ,cess } =req.body;

                if(!recipient_name){
                    return res.status(404)
                    .json({success:false,message :"Please fill Required fields"}) 
                }

                if(!user.id){
                    return res.status(404).json({success: false,message:"User Not found"});
                 }

                 if (!id) {
                    return res.status(400).json({ success: false, message: ' ID is required for this operation' });
                }


                 const data = await prisma.gstr1_9B.update({
                    where:{id:+id},
                    data:{
                        gstn,
                        recipient_name,
                        name_as_master ,
                        debit_credit_note_no ,
                        debit_credit_note_date ,
                        state_tax ,
                        note_type ,
                        supply_type ,
                        items_details ,
                        select_rate ,
                        note_values ,
                        state_tax_rs ,
                        central_tax ,
                        cess,
                    }
                 })

          
        return res.status(201).
        json({success:true,message:"successfully Updated Record !!"
        ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"})    
        } 
    }

    static async  getall9B (req: Request, res: Response){
        try {
            const user = req.user!; 

            const allgstr1 = await prisma.gstr1_9B.findMany({
                where:{userId:user.id}
            })

            if(allgstr1.length === 0){
               return res.status(404)
                .json({success:false,message:"no Records found"})
            }

          return  res.status(200)
            .json({success:true,
            message:"reccords fetch successfully",
            data:allgstr1})

        } catch (error) {
            return res.status(500)
            .json({ success: false, 
            message: 'Internal server error' });
        }
    }

    static async delete9B (req: Request, res: Response){
        try {
            const id=req.params.id;
            const user = req.user!;

            if(!id){
                return res.status(404)
                .json({success:false,message:"id Prarams required for this operation"})
            }

            const single= await prisma.gstr1_9B.findFirst({where:{id:+id,userId:user.id}})

            if(!single){
                return res.status(404)
                .json({success:false,message:"record Not Found"});
            }

            await prisma.gstr1_9B.delete({where:{id:+id}})

            const remainingItems = await prisma.gstr1_9B.findMany();
            for (let i = 0; i < remainingItems.length; i++) {
              await prisma.gstr1_9B.update({
                where: {
                  id: remainingItems[i].id
                },
                data: {
                  sr_no: i + 1
                }
              });
            }

            return res.status(200).json({success:true,message:"record deleted Successfully !!"}); 
            
        } catch (error) {
            return res.status(500).json({success:false,message:" internal server error !! "})
        }
    }

    // GSTR1 - 9B UNREGISTER
    
    static async create9Bunregister (req: Request, res: Response){
        try {
            const  user = req.user!;
            const {
                type ,
                debit_credit_note_no ,
                debit_credit_note_date ,
                state_tax ,
                note_type ,
                supply_type ,
                item_details ,
                select_rate ,
                note_value ,
                state_tax_rs ,
                central_tax_rs ,
                cess } =req.body;
            if(!debit_credit_note_no || !type ){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"}) 
            }

            if(!user.id){
                return res.status(404).json({success: false,message:"User Not found"});
             }

             const exist= await prisma.gstr1_9B_un.findFirst({where:{userId:user.id}})

             if(exist){
                return res.status(404).json({message:"Record allready existed!"})
             }

             const totalItems = await prisma.gstr1_9B_un.count();
             const nextSrNo = totalItems + 1;   
             const data = await prisma.gstr1_9B_un.create({
                data:{
                    sr_no:nextSrNo,
                    type ,
                    debit_credit_note_no ,
                    debit_credit_note_date ,
                    state_tax ,
                    note_type ,
                    supply_type ,
                    item_details ,
                    select_rate ,
                    note_value ,
                    state_tax_rs ,
                    central_tax_rs ,
                    cess ,
                    userId:user.id
                }
             })
             return res.status(201).
             json({success:true,message:"successfully created Record !!"
             ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"}) 
        }
    }
    static async update9Bunregister (req: Request, res: Response){
        try {
            const  user = req.user!;
            const {
                type ,
                debit_credit_note_no ,
                debit_credit_note_date ,
                state_tax ,
                note_type ,
                supply_type ,
                item_details ,
                select_rate ,
                note_value ,
                state_tax_rs ,
                central_tax_rs ,
                cess } =req.body;
            if(!debit_credit_note_no || !type ){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"}) 
            }

            if(!user.id){
                return res.status(404).json({success: false,message:"User Not found"});
             }

             const exist= await prisma.gstr1_9B_un.findFirst({where:{userId:user.id}})

             if(!exist){
                return res.status(404).json({message:"Record not existed!"})
             }

             
             const data = await prisma.gstr1_9B_un.update({
                where:{id:exist.id},
                data:{
                    type ,
                    debit_credit_note_no ,
                    debit_credit_note_date ,
                    state_tax ,
                    note_type ,
                    supply_type ,
                    item_details ,
                    select_rate ,
                    note_value ,
                    state_tax_rs ,
                    central_tax_rs ,
                    cess 
                }
             })
             return res.status(200).
             json({success:true,message:"successfully updated Record !!"
             ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"}) 
        }
    }

    static async get9bunregster (req: Request, res: Response){
       try {
                const user = req.user!;

                const single= await prisma.gstr1_9B_un.findFirst({where:{userId:user.id}})
    
                if(!single){
                    return res.status(404)
                    .json({success:false,message:"record Not Found"});
                }
    
                return res.status(200).json({success:true,message:"record Found",data:single});
                
            }  catch (error) {
                return res.status(500).json({success:false,message:"internal server error"}) 
            }
     }

    //  Gstr1_11A2A2

    static async create11A2A2 (req: Request, res: Response){
        try {
            const  user = req.user!;
            const {pos,supply ,cess} =req.body;
            if(!pos || !supply ){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"}) 
            }

            if(!user.id){
                return res.status(404).json({success: false,message:"User Not found"});
             }

             const exist= await prisma.gstr1_11A2A2.findFirst({where:{userId:user.id}})

             if(exist){
                return res.status(404).json({message:"Record allready existed!"})
             }

             const totalItems = await prisma.gstr1_11A2A2.count();
             const nextSrNo = totalItems + 1;   
             const data = await prisma.gstr1_11A2A2.create({
                data:{
                    sr_no:nextSrNo,
                    pos,
                    supply,
                    cess,
                    userId:user.id
                }
             })
             return res.status(201).
             json({success:true,message:"successfully created Record !!"
             ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"}) 
        }
    }

    static async update11A2A2 (req: Request, res: Response){
        try {
            const  user = req.user!;
            const {pos,supply ,cess} =req.body;
            if(!pos || !supply ){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"}) 
            }

            if(!user.id){
                return res.status(404).json({success: false,message:"User Not found"});
             }

             const exist= await prisma.gstr1_11A2A2.findFirst({where:{userId:user.id}})

             if(!exist){
                return res.status(404).json({message:"Record not existed!"})
             }

             const data = await prisma.gstr1_11A2A2.update({
                where:{id:exist.id},
                data:{
                    pos,
                    supply,
                    cess,
                }
             })
             return res.status(200).
             json({success:true,message:"successfully updated Record !!"
             ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"}) 
        }
    }

    static async get11A2A2 (req: Request, res: Response){
        try {
                 const user = req.user!;
 
                 const single= await prisma.gstr1_11A2A2.findFirst({where:{userId:user.id}})
     
                 if(!single){
                     return res.status(404)
                     .json({success:false,message:"record Not Found"});
                 }
     
                 return res.status(200).json({success:true,message:"record Found",data:single});
                 
             }  catch (error) {
                 return res.status(500).json({success:false,message:"internal server error"}) 
             }
    }

    //   Gstr1_11B1B2

    static async create11B1B2 (req: Request, res: Response){
        try {
            const  user = req.user!;
            const { 
                pos , taxable_value , rate ,supply_type ,
                cess , igst , cgst , sgst } =req.body;
            if(!pos || !taxable_value ){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"}) 
            }

            if(!user.id){
                return res.status(404).json({success: false,message:"User Not found"});
             }

             const exist= await prisma.gstr1_11B1B2.findFirst({where:{userId:user.id}})

             if(exist){
                return res.status(404).json({message:"Record allready existed!"})
             }

             const totalItems = await prisma.gstr1_11B1B2.count();
             const nextSrNo = totalItems + 1;   
             const data = await prisma.gstr1_11B1B2.create({
                data:{
                    sr_no:nextSrNo,
                    pos ,
                    taxable_value ,
                    rate ,
                    supply_type ,
                    cess ,
                    igst ,
                    cgst ,
                    sgst,
                    userId:user.id
                }
             })
             return res.status(201).
             json({success:true,message:"successfully created Record !!"
             ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"}) 
        }
    }

    static async update11B1B2 (req: Request, res: Response){
        try {
            const  user = req.user!;
            const { 
                pos , taxable_value , rate ,supply_type ,
                cess , igst , cgst , sgst } =req.body;
            if(!pos || !taxable_value ){
                return res.status(404)
                .json({success:false,message :"Please fill Required fields"}) 
            }

            if(!user.id){
                return res.status(404).json({success: false,message:"User Not found"});
             }

             const exist= await prisma.gstr1_11B1B2.findFirst({where:{userId:user.id}})

             if(!exist){
                return res.status(404).json({message:"Record Not existed!"})
             }

            
             const data = await prisma.gstr1_11B1B2.update({
                where:{id:exist.id},
                data:{
                    pos ,
                    taxable_value ,
                    rate ,
                    supply_type ,
                    cess ,
                    igst ,
                    cgst ,
                    sgst
                }
             })
             return res.status(200).
             json({success:true,message:"successfully upadted Record !!"
             ,data:data})

        } catch (error) {
            return res.status(500).json({success:false,message:"internal server error"}) 
        }
    }

    static async get11B1B2 (req: Request, res: Response){
        try {
                 const user = req.user!;
 
                 const single= await prisma.gstr1_11B1B2.findFirst({where:{userId:user.id}})
     
                 if(!single){
                     return res.status(404)
                     .json({success:false,message:"record Not Found"});
                 }
     
                 return res.status(200).json({success:true,message:"record Found",data:single});
                 
             }  catch (error) {
                 return res.status(500).json({success:false,message:"internal server error"}) 
             }
    }


}
