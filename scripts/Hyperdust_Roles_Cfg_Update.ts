/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


  const adminAddress = await upgrades.erc1967.getAdminAddress("0x34d65F8A20a35bD3c5eA2B42aF80d7F165DF4b46");

  console.log("ProxyAdmin deployed to:", adminAddress);

  // const contract = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
  // const upgraded = await upgrades.prepareUpgrade("0x34d65F8A20a35bD3c5eA2B42aF80d7F165DF4b46", contract);

  // console.log("New implementation deployed to:", upgraded);



}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
