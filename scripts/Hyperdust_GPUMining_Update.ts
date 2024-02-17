/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {



  const Hyperdust_Faucet = await ethers.getContractFactory("Hyperdust_GPUMining");

  const upgraded = await upgrades.upgradeProxy("0xb7f89B8dF2523034C664CD768eE587Fe729B0E1b", Hyperdust_Faucet);



}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
