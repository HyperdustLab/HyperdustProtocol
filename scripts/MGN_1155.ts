/** @format */

import { ethers } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MOSSAI_1155_NFT");

  const factory = await contractFactory.deploy("MOSSAI 1155", "mos");
  await factory.deployed();

  console.log("contractFactory address:", factory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
