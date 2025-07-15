import { exec, execSync } from "child_process";
import path from "path";
async function main() {
  try {
    const rs = execSync(
      `debian run "cp ./layouts/default-config.kdl ~/.config/zellij/config.kdl"`,
      { cwd: path.join(import.meta.dirname, "../") },
    );
    console.log(rs.toLocaleString());
    console.log("Zellij config copied to ~/.config/zellij/config.kdl");
  } catch (error) {
    console.log(error.stderr.toString());
  }
}

const toWSLPath = (filePath) => {
  const truePath = path.resolve(filePath);
  const drive = truePath.split(path.sep)[0].toLowerCase().slice(0, -1);
  const wslPath = `/mnt/${drive}${truePath.slice(2).replace(/\\/g, "/")}`;
  return wslPath;
};

main();
