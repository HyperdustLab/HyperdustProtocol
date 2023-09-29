/** @format */

import { ethers, run } from "hardhat";

async function main() {


  const MGN_Wallet_Account = await ethers.deployContract("MGN_Wallet_Account");



  await (await MGN_Wallet_Account.setErc20Address("0x4241f24ce6ddebd073fe0c76bd5bc5da9c831728")).wait();
  await (await MGN_Wallet_Account.setRolesCfgAddress("0x8e0f8f0137F289456322F912a145cC30485CEcBc")).wait();

  console.info("contractFactory address:", MGN_Wallet_Account.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
