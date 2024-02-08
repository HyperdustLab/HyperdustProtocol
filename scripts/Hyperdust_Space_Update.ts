/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {






  const Hyperdust_Space = await ethers.getContractFactory("Hyperdust_Space");

  const upgraded = await upgrades.upgradeProxy("0x8063C4C604d956b51D3e8708b8E68935833aA86a", Hyperdust_Space);


  await (await upgraded.setHyperdustRolesCfgAddress("0x9bDaf3912e7b4794fE8aF2E748C35898265D5615")).wait()

  await (await upgraded.setHyperdustStorageAddress("0x82550086EB9C80962cE81225F8966217dEC4f9df")).wait()




}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
