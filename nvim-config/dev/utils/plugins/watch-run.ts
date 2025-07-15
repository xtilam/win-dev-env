import { FSWatcher } from "chokidar";
import chokidar from "chokidar";

export default async function watchRun(
  initWatcher: CBInitWatcher,
  runCallback: CBRun
) {}

type CBInitWatcher = (api: APIInitWatcher) => void;
type CBRun = (api: WatchRunApi) => void;
type APIInitWatcher = {
  chokidar: typeof chokidar;
  restart: () => void;
  useFilter: (...ext: string[]) => (file: string) => boolean;
};
type WatchRunApi = {
  abortSignal: () => AbortController["signal"];
  abort: () => void;
  isClosed(): boolean;
};
