import { platform } from "os";
import path from "path";
import fs from "fs/promises";
import "@dinz41/utils/plugins/safe-promise";
import { __DIRS } from "../common/path-defines.js";

export default class NVIMConfig {
  extWatch = new Set<string>([".lua"]);
  nvimConfigDir: string;
  nvimCacheDir: string;

  constructor() {
    this.useDefaultNVimOSDir();
  }
  addExtWatch(ext: string) {
    this.extWatch.add(ext);
    return this;
  }
  setNvimConfigDir = (dir: string) => {
    this.nvimConfigDir = path.resolve(dir);
    return this;
  };
  setNvimCacheDir = (dir: string) => {
    this.nvimCacheDir = path.resolve(dir);
    return this;
  };
  linkConfig = async () => {
    const { nvimCacheDir, nvimConfigDir } = this;
    if (!nvimCacheDir) throw new Error("Nvim config directory is not set");
    if (!nvimConfigDir) throw new Error("Nvim cache directory is not set");
    if (!(await fs.stat(__DIRS.nvimCache).safe()).value)
      await fs.mkdir(__DIRS.nvimCache);
    await Promise.all([
      linkDir(__DIRS.nvimCache, nvimCacheDir),
      linkDir(__DIRS.nvimConfig, nvimConfigDir),
    ]);
    return this;
    // ----------------------------------------------
  };
  clearCache = async () => {
    const { nvimCacheDir } = this;
    if (!nvimCacheDir) throw new Error("Nvim cache directory is not set");
    const [stats] = await fs.stat(__DIRS.nvimCache).safe();
    if (stats) {
      console.log(`Removing ${nvimCacheDir}`);
      await fs.rm(__DIRS.nvimCache, { recursive: true });
    }
    await fs.mkdir(__DIRS.nvimCache);
    await linkDir(__DIRS.nvimCache, nvimCacheDir);
    return this;
  };
  useDefaultNVimOSDir() {
    const { env } = process;
    const { setNvimCacheDir, setNvimConfigDir } = this;
    switch (platform()) {
      case "win32": {
        const appDataDir = env.LOCALAPPDATA;
        setNvimConfigDir(`${appDataDir}/nvim`);
        setNvimCacheDir(`${appDataDir}/nvim-data`);
        break;
      }
      case "linux": {
        throw new Error("Not implemented yet");
        // const homeDir = env.HOME;
        // setNvimConfigDir(`${homeDir}/.config/nvim`);
      }
    }
    return this;
  }
}

async function linkDir(source: string, target: string) {
  const [stat] = await fs.stat(target).safe();
  if (stat) {
    console.log(`Removing ${target}`);
    await fs.rm(target, { recursive: true });
  }
  await fs.symlink(source, target);
  console.log(`Linked ${source} to ${target}`);
}
