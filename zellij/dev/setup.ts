import "./utils/promise.lib"
import fs from "fs/promises";
import { __DIRS } from "./commons/dirs";
import { die, downloadFile } from "./utils/utils";
import axios from "axios";
import inquirer from "inquirer"
import { release } from "process";
import path from "path";


async function main() {
  process.on("unhandledRejection", (reason) => {
    die(`Unhandled Rejection: ${reason}`);
  })
  await initDirs();
  if (process.platform === "win32") {
    await setupWSL();
  } else {
    console.log("No setup required for non-Windows platforms.");
  }
}

function initDirs() {
  return Promise.allSettled([__DIRS.assets].map((dir) => fs.mkdir(dir, { recursive: true })));
}

async function setupWSL() {
  const releaseVersion = await (async () => {
    // fetch all releases from github api
    const releases = await (async () => {
      console.log("Fetching releases from GitHub...");
      const owner = "zellij-org"
      const repository = "zellij"
      const apiGetReleasesURL = `https://api.github.com/repos/${owner}/${repository}/releases`;
      const [resp, err] = await axios.get(apiGetReleasesURL).safe()
      if (err) die(`Failed to fetch releases: ${err}`);
      if (!resp || !resp.data) die("No data received from GitHub API");
      const releases = (resp.data as ReleaseItem[]).filter((release) => !release.prerelease && !release.draft);
      if (!releases.length) die("No releases found");
      return releases
    })()

    // pick the latest release that has a suitable asset
    const releasePicked: ReleaseItem = (await inquirer.prompt([{
      type: "list",
      name: "release",
      message: "Select a release to install:",
      choices: releases.map((release, idx) => ({ name: [`[${(idx + 1).toString().padStart(2, ' ')}] => ${release.name} (${release.tag_name}) => published at ${new Date(release.published_at).toLocaleDateString()}`].join("\n   - "), value: release, })),
      pageSize: 10
    }])).release

    const assets = releasePicked.assets.filter((asset) => {
      if (!asset.name.endsWith(".tar.gz")) return false
      if (!asset.name.includes("x86_64")) return false
      if (!asset.name.includes("unknown-linux-musl")) return false
      return true
    })
    if (!assets.length) die("No suitable assets found for the selected release");

    const asset = (await inquirer.prompt([{
      type: "list",
      name: "asset",
      message: "Select an asset to download:",
      choices: assets.map((asset) => ({ name: asset.name, value: asset, })),
    }])).asset as AssetItem
    releasePicked.assets = [asset]
    return releasePicked
  })()

  // download the asset
  await (async () => {
    const [asset] = releaseVersion.assets;
    const asssetFileName = `${releaseVersion.tag_name}-${asset.name}`
    const assetFilePath = path.join(__DIRS.assets, asssetFileName);
    const [stat] = await fs.stat(assetFilePath).safe()
    if (stat && stat.isFile() && stat.size === asset.size)
      return console.log(`Asset ${asset.name} already downloaded at ${assetFilePath}`);
    console.log(`Downloading asset ${asset.name}`);
    await downloadFile((await asset).browser_download_url, assetFilePath);
    console.log(`Downloaded asset to ${assetFilePath}`);
  })()
}


main();

// ----------------------------------------
interface ReleaseItem {
  [n: string]: any,
  tag_name: string,
  name: string,
  assets: AssetItem[]
  published_at: string,
}

interface AssetItem {
  [n: string]: any,
  name: string,
  browser_download_url: string
}
