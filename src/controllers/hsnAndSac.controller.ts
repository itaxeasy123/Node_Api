import { Request, Response } from "express";
import fs from "fs"
import hsnfile  from '../config/hsncode.json';
import sacfile from '../config/saccodes.json';
import { writeFile } from "fs/promises";
import { join } from "path";
interface Code {
    HSNCode: string;
    HSNDescription: string;
  }

  interface SACCode {
    SACCode: number;
    SACDescription: string;
  }

export default class HsnAndSacController {

    static FilePath = join(__dirname, '..', 'config/hsncode.json')

    static sacfile = join(__dirname, '..', 'config/saccodes.json')

    static async updatehscode(cards: object) {
        await writeFile(HsnAndSacController.FilePath, JSON.stringify(cards));
    }

    static async updatesaccode(cards: object) {
        await writeFile(HsnAndSacController.sacfile, JSON.stringify(cards));
    }

    // controller for hsn codes

    static getallHsncode(req: Request, res: Response) {
        try {
            return res.status(200).json({
                success: true,
                data: hsnfile
            });
        } catch(e) {
            console.log(e);
            return res.status(500).json({ success: false, message: 'Something went wrong.' });
        }
    }

    static getbyhsncode (req: Request, res: Response){
        try {
            const { hsncode } = req.body;
      
            // Read the content of hsncode.json
            const hsncodeData = JSON.parse(fs.readFileSync(HsnAndSacController.FilePath, 'utf-8'));
      
            // Find the object in the array based on the provided HSN code
            const foundObject = hsncodeData.find((item: Code) => item.HSNCode === hsncode);
      
            if (foundObject) {
              // If the object is found, return it in the response
              return res.status(200).json({
                success: true,
                data: foundObject
              });
            } else {
              // If the object is not found, return a message indicating it
              return res.status(404).json({
                success: false,
                message: 'Object not found for the provided HSN code.'
              });
            }
          } catch (e) {
            console.log(e);
            return res.status(500).json({
              success: false,
              message: 'Something went wrong.'
            });
          }
        
    }

    // contoller for sac codes

    static getallSaccode(req: Request, res: Response) {
        try {
            return res.status(200).json({
                success: true,
                data: sacfile
            });
        } catch(e) {
            console.log(e);
            return res.status(500).json({ success: false, message: 'Something went wrong.' });
        }
    }

    static getbysaccode (req: Request, res: Response){
        try {
            const { saccode } = req.body;
      
            // Read the content of hsncode.json
            const saccodeData = JSON.parse(fs.readFileSync(HsnAndSacController.sacfile, 'utf-8'));
            // Find the object in the array based on the provided HSN code
            const foundObject = saccodeData.find((item: SACCode) => item.SACCode === saccode);

            if (foundObject) {
              // If the object is found, return it in the response
              return res.status(200).json({
                success: true,
                data: foundObject
              });
            } else {
              // If the object is not found, return a message indicating it
              return res.status(404).json({
                success: false,
                message: 'Object not found for the provided SAC code.'
              });
            }
          } catch (e) {
            console.log(e);
            return res.status(500).json({
              success: false,
              message: 'Something went wrong.'
            });
          }
    }


}