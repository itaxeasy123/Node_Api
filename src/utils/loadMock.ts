import fs from "fs";
import path from "path";

export function loadMock(fileName: string) {
  const filePath = path.join(
    process.cwd(),
    "src",
    "mocks",
    "gst",
    fileName
  );

  if (!fs.existsSync(filePath)) {
    throw new Error(`Mock file not found: ${filePath}`);
  }

  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}
