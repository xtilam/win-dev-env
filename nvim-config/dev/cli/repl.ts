import repl, { REPLEval } from "repl";

import { Context, runInContext } from "vm";
import nvimConfig from "../../config.js";

async function main() {
  const server = repl.start({ prompt: "$: " });
  const serverEval: REPLEval = async function (code, ctx, repl, finish) {
    try {
      const rs = runInContext(code, ctx);
      if (!(rs instanceof Promise)) return finish(null, rs);
      await rs;
      return finish(null, undefined);
    } catch (error) {
      finish(error, undefined);
    }
  };
  Object.assign(server, { eval: serverEval });
  const ctx = server.context;
  ctx.nvim = nvimConfig;
  const ctxWrapper = new ContextWrapper(ctx);
  ctxWrapper.addGetterAction(nvimConfig.clearCache);
  ctxWrapper.addGetterAction(nvimConfig.linkConfig);
  ctxWrapper.addGetterAction(console.clear, "cls");
}

class ContextWrapper {
  ctx: Context;
  constructor(context: Context) {
    this.ctx = context;
  }
  set(name: string, value: any) {
    this.ctx[name] = value;
    return this;
  }
  addGetterAction(callback, name = "") {
    return this.addAction(() => callback(), name || callback?.name);
  }
  addAction(callback, name = "") {
    if (!name) name = callback.name;
    name = "$" + name;
    Object.defineProperty(this.ctx, name, {
      get: callback,
    });
    return this;
  }
}

main();
