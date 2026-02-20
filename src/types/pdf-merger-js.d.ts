declare module 'pdf-merger-js' {
    class PDFMerger {
        constructor();
        add(inputFile: string, pages?: string | undefined): Promise<void>;
        merge(outputFile?: string): Promise<Buffer | void>;
        save(outputFile: string): Promise<void>;
    }
    export default PDFMerger;
}
