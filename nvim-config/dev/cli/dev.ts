import { fork } from "child_process";
import chokidar from "chokidar";
import path from "path";
import { __DIRS } from "../common/path-defines.js";
import { utils } from "../utils/utils.js";

async function main() {
  const tsx = await utils.findNodeCLI(__DIRS.project, "tsx");
  const watchScript = path.join(__DIRS.dev, "cli/watch.ts");
  const args = [watchScript, ...process.argv.slice(2)];
  let restart = () => {};
  chokidar.watch(__DIRS.dev).on("change", () => restart());
  runWatchScript();
  // ----------------------------------------------
  async function runWatchScript() {
    const abortSignal = new AbortController();
    const waitChange = utils.promiseWrapper();
    const waitClose = utils.promiseWrapper();
    let isClosed = false;
    restart = () => waitChange.resolve();

    const onClose = () => {
      isClosed = true;
      waitChange.resolve();
      waitClose.resolve();
    };
    const progress = fork(tsx, args, {
      stdio: "inherit",
      signal: abortSignal.signal,
    });
    progress.on("error", onClose);
    progress.on("close", onClose);
    await utils.delay(20);
    await waitChange.promise;
    if (!isClosed) abortSignal.abort();
    await waitClose.promise;
    if (progress.exitCode === 0) {
      process.exit(0);
    }
    await runWatchScript();
  }
}
main();
