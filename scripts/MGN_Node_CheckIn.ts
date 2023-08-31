/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Node_CheckIn");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await run("verify:verify", {
    address: contract.address,
    contract: "contracts/node/MGN_Node_CheckIn.sol:MGN_Node_CheckIn",
    constructorArguments: [],
  });

  console.info("contractFactory address:", contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
