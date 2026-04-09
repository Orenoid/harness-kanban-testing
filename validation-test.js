const fs = require("fs");

const readme = fs.readFileSync("README.md", "utf8").trimEnd();
const lines = readme.split(/\r?\n/);
const lastLine = lines[lines.length - 1];

if (lastLine !== "Test") {
  throw new Error('README.md must end with a line containing "Test".');
}
