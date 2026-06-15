import { Request, Response } from 'express';
import { Library, Prisma, PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// create library

class LibraryController {
      static async createLibrary(req: Request, res: Response): Promise<void> {
        try {
          const {
            pan, section, sub_section, subject, ao_order, itat_no, rsa_no
            , bench, appeal_no, appellant, respondent, appeal_type, appeal_filed_by,
            order_result, tribunal_order_date, assessment_year, judgment, conclusion, download, upload
          } = req.body;

          const Library = await prisma.library.create({
            data: {
              pan, section, sub_section, subject, ao_order, itat_no, rsa_no
              , bench, appeal_no, appellant, respondent, appeal_type, appeal_filed_by,
              order_result, tribunal_order_date, assessment_year, judgment, conclusion, download, upload

            },
          });

          res.status(201).json({ message: 'Library added successfully', result: Library });
        } catch (error) {
          //console.log(error)
          res.status(500).json({ success: false, message: 'Internal server error', errors: error });
        }
      }

  // find All library — server-side search, filtering, sorting & pagination.
  // Returns only one page of rows (was: the entire table incl. full judgment
  // text on every load), so the payload stays small as the table grows.
  static async findAllLibrary(req: Request, res: Response): Promise<void> {
    try {
      const page = Math.max(1, parseInt((req.query.page as string) || '1', 10) || 1);
      const limit = Math.min(100, Math.max(1, parseInt((req.query.limit as string) || '20', 10) || 20));
      const search = ((req.query.search as string) || '').trim();
      const section = (req.query.section as string) || '';
      const bench = (req.query.bench as string) || '';
      const assessmentYear = (req.query.assessmentYear as string) || '';
      const sortKey = (req.query.sortKey as string) || '';
      const sortDir = (req.query.sortDir as string) === 'descending' ? 'desc' : 'asc';

      const and: Prisma.LibraryWhereInput[] = [];
      if (section) and.push({ section });
      if (bench) and.push({ bench });
      if (assessmentYear) and.push({ assessment_year: assessmentYear });
      if (search) {
        const ins = { contains: search, mode: Prisma.QueryMode.insensitive };
        and.push({
          OR: [
            { pan: ins }, { section: ins }, { sub_section: ins }, { subject: ins },
            { ao_order: ins }, { itat_no: ins }, { rsa_no: ins }, { bench: ins },
            { appeal_no: ins }, { appellant: ins }, { respondent: ins },
            { appeal_type: ins }, { appeal_filed_by: ins }, { order_result: ins },
            { tribunal_order_date: ins }, { assessment_year: ins },
            { judgment: ins }, { conclusion: ins },
          ],
        });
      }
      const where: Prisma.LibraryWhereInput = and.length ? { AND: and } : {};

      const sortable = new Set([
        'id', 'pan', 'section', 'sub_section', 'subject', 'bench',
        'appeal_no', 'appellant', 'assessment_year',
      ]);
      const orderBy = (sortable.has(sortKey)
        ? { [sortKey]: sortDir }
        : { id: 'desc' }) as Prisma.LibraryOrderByWithRelationInput;

      const [total, rows] = await prisma.$transaction([
        prisma.library.count({ where }),
        prisma.library.findMany({ where, orderBy, skip: (page - 1) * limit, take: limit }),
      ]);

      // Filter dropdown options only need to travel on the first page; the
      // client keeps them while paginating, so we skip the distinct scans after.
      let filters: { sections: string[]; benches: string[]; assessmentYears: string[] } | undefined;
      if (page === 1) {
        const [sections, benches, years] = await prisma.$transaction([
          prisma.library.findMany({ distinct: ['section'], select: { section: true }, orderBy: { section: 'asc' } }),
          prisma.library.findMany({ distinct: ['bench'], select: { bench: true }, orderBy: { bench: 'asc' } }),
          prisma.library.findMany({ distinct: ['assessment_year'], select: { assessment_year: true }, orderBy: { assessment_year: 'asc' } }),
        ]);
        filters = {
          sections: sections.map((s) => s.section).filter(Boolean),
          benches: benches.map((b) => b.bench).filter(Boolean),
          assessmentYears: years.map((y) => y.assessment_year).filter(Boolean),
        };
      }

      res.status(200).json({
        success: true,
        allLibrary: rows,
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit) || 1,
        ...(filters ? { filters } : {}),
      });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Internal server error', errors: error });
    }
  }

  //get library by id

  static async findOneLibrary(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);

      const library: Library | null = await prisma.library.findUnique({
        where: {
          id,
        },
      });

      if (!library) {
        res.status(404).json({ success: false, message: 'library not found' });
        return;
      }

      res.status(200).json(library);
    } catch (error) {
      console.error(error);
      res.status(500).json({ success: false, message: 'Internal server error' });
    }
  }

  //profile update by id
  static async updateLibrary(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const {
        pan, section, sub_section, subject, ao_order, itat_no, rsa_no
        , bench, appeal_no, appellant, respondent, appeal_type, appeal_filed_by,
        order_result, tribunal_order_date, assessment_year, judgment, conclusion, download, upload
      } = req.body;
      const updatedLibrary: Library | null = await prisma.library.update({
        where: { id: id },
        data: {
          pan, section, sub_section, subject, ao_order, itat_no, rsa_no
          , bench, appeal_no, appellant, respondent, appeal_type, appeal_filed_by,
          order_result, tribunal_order_date, assessment_year, judgment, conclusion, download, upload
        }
      })
      if (!updatedLibrary) {
        res.status(404).json({ sucess: false, message: 'library not found' });
        return;
      }

      res.status(200).json({ sucess: true, updatedLibrary });

    } catch (error) {
      console.error(error);
      res.status(500).json({ success: false, message: 'Internal server error' });
    }

  }

  //delete library by id
  static async deleteLibrary(req: Request, res: Response): Promise<void> {
    try {
      const Id = parseInt(req.params.id);

      // Delete the profile
      const deletedLibrary: Library | null = await prisma.library.delete({ where: { id: Id } });

      if (!deletedLibrary) {
        res.status(404).json({ success: false, message: 'library not found' });
        return;
      }

      res.status(200).json({ success: true, deletedLibrary });
    } catch (error) {
      console.error(error);
      res.status(500).json({ success: false, message: 'Internal server error' });
    }
  }
}


export default LibraryController