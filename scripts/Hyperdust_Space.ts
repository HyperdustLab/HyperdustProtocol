/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




  const Hyperdust_Storage = await ethers.deployContract("Hyperdust_Storage");
  await Hyperdust_Storage.waitForDeployment()



  const contract = await ethers.getContractFactory("Hyperdust_Space");
  const instance = await upgrades.deployProxy(contract);
  await instance.waitForDeployment();

  console.info("Hyperdust_Storage:", Hyperdust_Storage.target)


  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()


  await (await instance.setHyperdustRolesCfgAddress("0x9bDaf3912e7b4794fE8aF2E748C35898265D5615")).wait()

  await (await instance.setHyperdustStorageAddress(Hyperdust_Storage.target)).wait()



  console.info("contractFactory address:", instance.target);




}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
