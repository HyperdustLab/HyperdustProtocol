/** @format */

import { ethers, run, upgrades } from "hardhat";

require("dotenv").config()

async function main() {

  const contract = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);

  await instance.waitForDeployment();

  // 将多签名钱包设置为升级管理员
  console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
