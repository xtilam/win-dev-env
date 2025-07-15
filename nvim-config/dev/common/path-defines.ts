import path from "path";

const projectDir = path.join(import.meta.dirname, "../../");
const devDir = path.join(projectDir, "dev");
const luaDir = path.join(projectDir, "lua");
const luaCacheDir = path.join(projectDir, "lua-cache");
const luaDev = path.join(devDir, "lua-dev");

export const __DIRS = {
  project: projectDir,
  dev: devDir,
  bin: path.join(projectDir, "bin"),
  nvimConfig: path.join(luaDir),
  nvimCache: path.join(luaCacheDir),
  dist: path.join(projectDir, "dist"),
  src: path.join(projectDir, "src"),
};
