/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MOSSAI_ERC_20");

  const factory = await contractFactory.deploy("MGN", "mgn");
  const contract = await factory.deployed();
  await contract.deployed();

  console.info("contractFactory address:", contract.address);

  await run("verify:verify", {
    address: contract.address,
    contract: "contracts/token/MOSSAI_ERC_20.sol:MOSSAI_ERC_20",
    constructorArguments: ["MGN", "mgn"],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
