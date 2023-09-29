/** @format */

import { ethers, run } from "hardhat";

async function main() {

  const MGN_Space_Template = await ethers.deployContract("MGN_Space_Template");


  await (await MGN_Space_Template.setRolesCfgAddress("0xB05c1453486195DD7bd572571ce7131707DA9411")).wait();

  console.info("contractFactory address:", MGN_Space_Template.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
