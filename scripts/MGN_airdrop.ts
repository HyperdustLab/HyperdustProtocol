/** @format */

import { ethers, run } from "hardhat";

async function main() {



  const MGN_Airdrop = await ethers.deployContract("MGN_Airdrop");


  console.info("contractFactory address:", MGN_Airdrop.target);

  await (await MGN_Airdrop.setRolesCfgAddress("0x57B938452f79959d59e843118C502D995eb1418B")).wait();
  await (await MGN_Airdrop.setErc20Address("0x7a798E8eC045f911684dAa28B38a54b883b9523C")).wait();

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
