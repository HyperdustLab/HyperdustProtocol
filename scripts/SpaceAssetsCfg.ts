/** @format */

import { ethers, run } from "hardhat";

async function main() {

  const SpaceAssetsCfg = await ethers.deployContract("SpaceAssetsCfg");



  await (
    await SpaceAssetsCfg.setContractAddress([
      "0x014e7d6A38A860B2B80379d0BF71a52A902c2E6c",
      "0x4241f24ce6ddebd073fe0c76bd5bc5da9c831728",
      "0x513521e80A9d4854bb71ddbE768792B46f2ce9E8",
      "0x8e0f8f0137F289456322F912a145cC30485CEcBc",
    ])
  ).wait();

  console.info("contractFactory address:", SpaceAssetsCfg.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
