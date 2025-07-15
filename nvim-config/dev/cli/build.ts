import esbuild from "esbuild";
import path from "path";
import { __DIRS } from "../common/path-defines.js";
import { existsSync, mkdir, mkdirSync, rmSync } from "fs";

async function build() {
  const distBuild = path.join(__DIRS.dist);

  if (existsSync(distBuild)) {
    console.log("Cleaning dist directory...");
    rmSync(distBuild, { recursive: true });
    mkdirSync(distBuild);
  }

  const context = await esbuild.context({
    outdir: distBuild,
    entryPoints: [path.join(__DIRS.src, "/**/*.ts")],
    bundle: true,
    platform: "node",
    target: "node14",
    sourcemap: true,
    format: "esm",
  });

  await context.rebuild();
  console.log("Build complete!");
}

build();
