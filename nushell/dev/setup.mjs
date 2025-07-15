import { existsSync } from "fs";
import fs from "fs/promises";
import path from "path";

async function main() {
  const linkDir = path.join(process.env.APPDATA, "nushell");
  const configDir = path.join(import.meta.dirname, "../config");
  if (existsSync(linkDir)) {
    await fs.rm(linkDir, { recursive: true });
    console.log(`Removed existing link at ${linkDir}`);
  }
  await fs.symlink(configDir, linkDir);
  console.log(`Linked config directory to ${linkDir}`);
}

main();
