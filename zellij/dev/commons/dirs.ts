import path from "path"

const root = path.join(import.meta.dirname, "../../")

export const __DIRS = {
  root,
  config: path.join(root, "config"),
  assets: path.join(root, "assets"),
}

