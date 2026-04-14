// build.js
const fs = require('fs')
const path = require('path')

const SRC_DIR = "src";
const OUT_DIR = "out";

// Clean output
fs.rmSync(OUT_DIR, { recursive: true, force: true });
fs.mkdirSync(OUT_DIR, { recursive: true });

// Recursively collect files
function walk(dir) {
  let results = [];
  const list = fs.readdirSync(dir, { withFileTypes: true });

  for (const file of list) {
    const fullPath = path.join(dir, file.name);

    if (file.isDirectory()) {
      results = results.concat(walk(fullPath));
    } else if (file.name.endsWith(".lua") || file.name.endsWith(".luau")) {
      results.push(fullPath);
    }
  }

  return results;
}

// Transform function (equivalent to your sed rules)
function transform(content) {
  return content
    .replace(/require\((['"`])@pkg\/([^'"]+)\1\)/g, "require('@game/ReplicatedStorage/packages/$2')")
    .replace(/require\((['"`])@spkg\/([^'"]+)\1\)/g, "require('@game/ServerScriptService/packages/$2')")
    .replace(/require\((['"`])@client\/([^'"]+)\1\)/g, "require('@game/ReplicatedStorage/client/$2')")
    .replace(/require\((['"`])@server\/([^'"]+)\1\)/g, "require('@game/ServerScriptService/server/$2')")
    .replace(/require\((['"`])@ui\/([^'"]+)\1\)/g, "require('@game/ReplicatedStorage/client/interface/$2')")
    .replace(/require\((['"`])@types\/([^'"]+)\1\)/g, "require('@game/ReplicatedStorage/shared/types/$2')")
    .replace(/require\((['"`])@shared\/([^'"]+)\1\)/g, "require('@game/ReplicatedStorage/shared/$2')");
}

const files = walk(SRC_DIR);

for (const file of files) {
  const relPath = path.relative(SRC_DIR, file);
  const outPath = path.join(OUT_DIR, relPath);

  fs.mkdirSync(path.dirname(outPath), { recursive: true });

  const input = fs.readFileSync(file, "utf8");
  const output = transform(input);

  fs.writeFileSync(outPath, output);
}

console.log(`Build complete: ${SRC_DIR}/ → ${OUT_DIR}/`);