import { exec } from "child_process";
import path from "path";
import net from "net";

export async function getEnv(argv) {
  const command = argv.join(" ").trim();
  const server = await initServer();
  let chunkContents = [];
  server.on("connection", (socket) => {
    socket.on("data", (data) => chunkContents.push(data));
  });

  const saveEnvScript = path.join(import.meta.dirname, "socket-env.mjs");
  if (!command) throw "No command provided";
  const logs = [];
  const progress = exec(
    `(${command}) && node ${saveEnvScript} ${server.address().port}`,
    { shell: true },
  );

  progress.stdout.on("data", (buf) => logs.push(buf.toString()));
  progress.stderr.on("data", (buf) => logs.push(buf.toString()));

  await new Promise((resolve) => {
    progress.on("error", resolve);
    progress.on("exit", resolve);
  });

  const newEnv = JSON.parse(
    chunkContents.length
      ? chunkContents.reduce((acc, chunk) => acc + chunk.toString(), "")
      : "{}",
  );

  server.close();
  filterEnv(newEnv);

  return { env: newEnv, logs: logs.join(""), exitCode: progress.exitCode };

  //----------------------------------------
  function filterEnv(newEnv) {
    const oldEnv = process.env;
    delete newEnv.PWD;
    for (const key in newEnv) {
      if (oldEnv[key] !== newEnv[key]) continue;
      delete newEnv[key];
    }
    return newEnv;
  }
}

async function initServer() {
  const server = net.createServer((socket) => {
    socket.on("data", () => {});
    socket.on("error", () => {});
    socket.on("close", () => {});
  });

  await new Promise((resolve, reject) => {
    server.listen(0, resolve);
    server.on("error", (err) => {
      if (err.code !== "EADDRINUSE") return;
      reject(new Error("Port is already in use. Please try again."));
    });
  });
  return server;
}
