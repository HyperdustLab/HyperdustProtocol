/** @format */

import { ethers, run } from "hardhat";

async function main() {


  const MGN_Space_Airdrop = await ethers.deployContract("MGN_Space_Airdrop");

  await (await MGN_Space_Airdrop.setRolesCfgAddress("0x8e0f8f0137F289456322F912a145cC30485CEcBc")).wait();

  console.info("contractFactory address:", MGN_Space_Airdrop.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
