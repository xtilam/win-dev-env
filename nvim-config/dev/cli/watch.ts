import { spawn } from "child_process";
import chokidar from "chokidar";
import neovim from "neovim";
import { createServer } from "net";
import path from "path";
import { portToPid } from "pid-port";
import nvimConfig from "../../config.js";
import { __DIRS } from "../common/path-defines.js";
import { utils } from "../utils/utils.js";

export async function watch() {
  const debugScriptDir = path.join(__DIRS.dev, "/lua/debug.lua");
  const freePort = await findFreePort();
  const args = getArgs(freePort);
  let restart = () => {};

  watchChokidar();
  console.log(args.join(" "));
  startNVIM();

  // ----------------------------------------------
  async function startNVIM() {
    await utils.delay(20);
    const restartPromise = utils.promiseWrapper();
    const waitClose = utils.promiseWrapper();
    let isClosed = false;
    restart = restartPromise.resolve;
    const abortSignal = new AbortController();
    const progress = spawn("nvim", args, {
      stdio: "inherit",
      cwd: process.cwd(),
      signal: abortSignal.signal,
    });
    progress.on("close", onClose);
    progress.on("error", onClose);
    const client = await getClient();
    await restartPromise.promise;
    if (!isClosed) {
      client?.command(":qa!");
      client?.command(":qa!");
      client?.command(":qa!");
      utils.delay(1000).then(() => abortSignal.abort());
    }
    await waitClose.promise;
    if (progress.exitCode === 1000) return process.exit(0);
    startNVIM();
    // ----------------------------------------------
    function onClose() {
      isClosed = true;
      waitClose.resolve();
      restartPromise.resolve();
    }
    async function getClient(delay = 100) {
      if (isClosed) return;
      const [pid] = await portToPid(Number(freePort)).safe();
      if (!pid) {
        await utils.delay(20);
        return await getClient(delay);
      }
      if (isClosed) return;
      await utils.delay(50);
      return neovim.attach({ socket: freePort });
    }
  }
  async function watchChokidar() {
    chokidar.watch([__DIRS.nvimConfig]).on("change", (file) => {
      if (!nvimConfig.extWatch.has(path.extname(file))) return;
      restart();
    });
  }
  function getArgs(freePort: string | number) {
    const addressTCP = `127.0.0.1:${freePort}`;
    const args = ["--listen", addressTCP];
    args.push("-c", `lua dofile(${JSON.stringify(debugScriptDir)})`);
    process.argv.slice(2).forEach((v) => {
      if (!v.startsWith("test")) return args.push(v);
      const scriptName = v.split(".")[1];
      if (!scriptName) return;
      args.push("-c", `lua require('${v}')`);
    });
    return args;
  }
}

async function findFreePort() {
  const server = createServer({});
  server.listen(0);
  const promise = utils.promiseWrapper();
  server.on("listening", promise.resolve);
  server.on("error", promise.reject);
  await promise.promise;
  const address = server.address();
  server.close();
  if (!address) throw new Error("Unexpected address type");
  if (typeof address === "string") return new URL(address).port;
  return address.port + "";
}

watch();
