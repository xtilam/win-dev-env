import { getEnv } from "./get-env.mjs";
import { die } from "./utils.mjs";

async function main() {
  if (process.argv.length < 3)
    die("No command provided. Usage: node write-env.mjs [EnvName] ...command");
  console.log(JSON.stringify(await getEnv(process.argv.slice(2))));
}
main();
