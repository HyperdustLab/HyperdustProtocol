/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {

  const contract = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
  const instance = await upgrades.deployProxy(contract, ["0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f"]);

  await instance.waitForDeployment();



  // 将多签名钱包设置为升级管理员
  await upgrades.admin.transferProxyAdminOwnership(instance.target, "0x4299d8Ca8075b208BaAB8c05a95099f69396433c");


  console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
