import path from "path";
import fs from "fs/promises";
import { Command } from "commander";

async function main() {
  const weztermDir = path.join(import.meta.dirname, "../../wezterm/config");
  const alacrityDir = path.join(import.meta.dirname, "../../alacritty/configs");
  const oldConfigJSONPath = path.join(import.meta.dirname, "./old-config.json");
  const oldConfig = JSON.parse(await fs.readFile(oldConfigJSONPath, "utf8"));
  console.log(oldConfig);
  const program = new Command();
  program.option(
    "-o, --opacity <opacity>",
    "Set opacity for the terminal",
    oldConfig.opacity + "",
  );
  program.option(
    "--fz, --font-size <size>",
    "Set font size",
    oldConfig.fontSize,
  );
  // program.parse([...process.argv.slice(0, 2), "-o", "90", "--fz", "11"]);
  program.parse(process.argv);
  const opts = program.opts();

  const opacity = Number("0." + opts.opacity);
  const fontSize = Number(opts.fontSize);
  console.log({ opacity, fontSize });
  if (isNaN(opacity) || opacity < 0 || opacity > 1) {
    console.error("Opacity must be a number between 0 and 100.");
    process.exit(1);
  }
  if (isNaN(fontSize) || fontSize <= 0) {
    console.error("Font size must be a positive number.");
    process.exit(1);
  }

  await Promise.all([writeNewConfig(), writeAlacrity(), writeWezterm()]);
  //----------------------------------------
  async function writeNewConfig() {
    await fs.writeFile(
      oldConfigJSONPath,
      JSON.stringify({ opacity: opacity * 100, fontSize }, null, 2),
      "utf-8",
    );
  }
  async function writeAlacrity() {
    const tomlPath = path.join(alacrityDir, "opts.toml");
    const content = [
      "[font]",
      `size = ${fontSize}`,
      "[window]",
      `opacity = ${opacity}`,
    ].join("\n");
    await fs.writeFile(tomlPath, content, "utf-8");
  }

  async function writeWezterm() {
    const luaPath = path.join(weztermDir, "opts.lua");
    const content = [
      `return {`,
      `  font_size = ${fontSize},`,
      `  opacity = ${opacity},`,
      `}`,
    ].join("\n");
    await fs.writeFile(luaPath, content, "utf-8");
  }
}

main();
