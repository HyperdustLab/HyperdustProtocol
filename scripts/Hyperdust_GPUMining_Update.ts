/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {



  const Hyperdust_Faucet = await ethers.getContractFactory("Hyperdust_GPUMining");

  const upgraded = await upgrades.upgradeProxy("0x08B6E87284b8B31b591C8Bd5488f433996D4dfc2", Hyperdust_Faucet);



}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
