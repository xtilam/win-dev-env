import path from "path";
import fs from "fs/promises";
import os from "os";
import { existsSync } from "fs";
async function main() {
  const targetDir = path.join(os.homedir(), ".config/wezterm");
  const sourceDir = path.join(import.meta.dirname, "../config");
  if (existsSync(targetDir)) {
    await fs.rmdir(targetDir, { recursive: true });
    console.log(`Removed existing directory: ${targetDir}`);
  }
  await fs.symlink(sourceDir, targetDir);
  console.log(`Created symlink from ${sourceDir} to ${targetDir}`);
}
main();
