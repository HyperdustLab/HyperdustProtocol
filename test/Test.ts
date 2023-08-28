/** @format */

import { ethers } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Test");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();

  console.info(contract);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
