import { AadhaarData, PanData } from "../controllers/ocr.controller";

function extractAadhaarData(ocrText: string): AadhaarData {
  const aadhaarNumberPattern = /\b\d{4}\s\d{4}\s\d{4}\b/;
  //   const namePattern = /^[A-Z][a-z]+\s[A-Z][a-z]+(?:\s[A-Z][a-z]+)*$/m;
  const namePattern = /^[A-Z][a-zA-Z]+(?:\s[A-Z][a-zA-Z]+)*$/;
  const dobPattern = /DOB\s*[:-]?\s*([0-9]{2}\/[0-9]{2}\/[0-9]{4})/i;
  const genderPattern = /\b(MALE|FEMALE)\b/i;
  const data: AadhaarData = {};

  const aadhaarMatch = ocrText.match(aadhaarNumberPattern);
  const nameMatch = ocrText.match(namePattern);
  const dobMatch = ocrText.match(dobPattern);
  const genderMatch = ocrText.match(genderPattern);

  const lines = ocrText.split("\n");
  console.log("🚀 ~ extractAadhaarData ~ lines:", lines);
  let name = "";

  for (const line of lines) {
    if (namePattern.test(line.trim())) {
      name = line.trim();
      break;
    }
  }

  if (name) {
    console.log("Extracted Name:", name);
  } else {
    console.log("Name not found");
  }

  if (aadhaarMatch) {
    data["AadhaarNumber"] = aadhaarMatch[0];
  }
  if (nameMatch) {
    data["Name"] = nameMatch[0].trim();
  }
  if (dobMatch) {
    data["DateOfBirth"] = dobMatch[1].trim();
  }
  if (genderMatch) {
    data["Gender"] = genderMatch[0].toUpperCase();
  }

  return data;
}

function extractPanData(ocrText: string[]): PanData {
  const data: PanData = {};

  const panPattern = /[A-Z]{5}[0-9]{4}[A-Z]{1}/;
  for (const line of ocrText) {
    const panMatch = line.match(panPattern);
    if (panMatch) {
      data["PAN"] = panMatch[0];
      break;
    }
  }

  for (let i = 0; i < ocrText.length; i++) {
    const line = ocrText[i].trim();

    const namePattern = /\bName\b(?!(?:\s*:|\s*-\s*)\s*Father['’]s\s+Name)/;
    if (
      namePattern.test(line) &&
      !line.includes("Father's Name") &&
      i + 1 < ocrText.length
    ) {
      data["Name"] = ocrText[i + 1]
        .replace(/[[]\(\)\{\}]/g, "")
        .replace(/[^A-Z\s]/g, "")
        .trim()
        .split(" ")
        .slice(0, 3)
        .join(" ");
    }

    if (line.includes("Father's Name") && i + 1 < ocrText.length) {
      data["Father's Name"] = ocrText[i + 1]
        .replace(/[[\](){}]/g, "")
        .replace(/[:]/g, "")
        .trim();
    }

    const dobPattern = /(\d{2}\/\d{2}\/\d{4})/;
    if (/Date\s+of\s+Birth\s*[:=]/i.test(line) || dobPattern.test(line)) {
      const dobMatch =
        line.match(dobPattern) ||
        (ocrText[i + 1] ? ocrText[i + 1].match(dobPattern) : null);
      if (dobMatch) {
        data["Date of Birth"] = dobMatch[0].trim();
      }
    }
  }

  return data;
}

export { extractAadhaarData, extractPanData };
