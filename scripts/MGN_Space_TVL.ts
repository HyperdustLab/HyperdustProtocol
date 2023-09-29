/** @format */

import { ethers, run } from "hardhat";

async function main() {


  const MGN_Space_TVL = await ethers.deployContract("MGN_Space_TVL");

  await (await MGN_Space_TVL.setRolesCfgAddress("0x57B938452f79959d59e843118C502D995eb1418B")).wait();

  console.info("contractFactory address:", MGN_Space_TVL.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
