/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {
  //   const _Hyperdust_Storage = await ethers.getContractFactory("Hyperdust_Storage");
  //   const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address]);
  //   await Hyperdust_Storage.waitForDeployment();

  const Hyperdust_Storage = await ethers.getContractAt("Hyperdust_Storage", "0x57bC049608f0202C44D74a4DB9A2193F85C97932");

  const contract = await ethers.getContractFactory("Hyperdust_Space");
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);
  await instance.waitForDeployment();

  console.info("Hyperdust_Storage:", Hyperdust_Storage.target);

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait();

  await (await instance.setHyperdustStorageAddress(Hyperdust_Storage.target)).wait();

  await (await instance.setContractAddress(["0x9bDaf3912e7b4794fE8aF2E748C35898265D5615", Hyperdust_Storage.target])).wait();

  console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
