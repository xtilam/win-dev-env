import "./promise.lib"
import path from "path"
import fs from "fs/promises"
import axios from "axios"

export const delay = (ms: number) => new Promise<void>((resolve) => setTimeout(resolve, ms));
export const toWSLPath = (filePath: string) => {
  const truePath = path.resolve(filePath);
  const drive = truePath.split(path.sep)[0].toLowerCase().slice(0, -1);
  const wslPath = `/mnt/${drive}${truePath.slice(2).replace(/\\/g, "/")}`;
  return wslPath;
};

export const initPromise = <T = void>() => {
  let resolve, reject;
  const promise = new Promise<T>((res, rej) => {
    resolve = res;
    reject = rej;
  })
  return { promise, resolve, reject }
}

export const initOutputDir = async (outputPath: string) => {
  const parentDir = path.dirname(outputPath);
  const [stat] = await fs.stat(parentDir).safe()
  if (stat?.isDirectory()) return
  if (stat)
    await fs.rm(parentDir, { recursive: true, force: true })
  await fs.mkdir(parentDir, { recursive: true })
}

export const die = (msg: string) => {
  console.error(msg);
  process.exit(0);
}

export const downloadFile = async (url: string, outputPath: string) => {
  await initOutputDir(outputPath)

  // download file with axios
  const response = await axios.get(url, { responseType: "stream" });
  const writer = (await fs.open(outputPath, "w")).createWriteStream();
  response.data.pipe(writer);
  const rs = initPromise<void>()
  writer.on("finish", () => rs.resolve())
  writer.on("error", (err) => rs.reject(err));
  await rs.promise;
}
