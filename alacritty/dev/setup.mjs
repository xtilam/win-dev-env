import path from "path";
import fs from "fs/promises";
import { existsSync } from "fs";

async function main() {
  let alacrityOsConfigDir = "";
  switch (process.platform) {
    case "darwin":
      alacrityOsConfigDir = path.join(process.env.HOME, ".config", "alacritty");
      break;
    case "linux":
      alacrityOsConfigDir = path.join(process.env.HOME, ".config", "alacritty");
      break;
    case "win32":
      alacrityOsConfigDir = path.join(process.env.APPDATA, "alacritty");
      break;
    default:
      console.error("Unsupported OS");
      return;
  }
  const configDir = path.join(import.meta.dirname, "../configs");
  if (existsSync(alacrityOsConfigDir)) {
    await fs.rm(alacrityOsConfigDir, { recursive: true, force: true });
    console.log(
      `Removed existing Alacritty config directory: ${alacrityOsConfigDir}`,
    );
  }

  await fs.symlink(configDir, alacrityOsConfigDir);
  console.log(
    `Symlinked Alacritty config directory to: ${alacrityOsConfigDir}`,
  );
}
main();
