/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_1155");

  const factory = await contractFactory.deploy("Space_1155", "Space");
  const contract = await factory.deployed();
  await contract.deployed();

  console.info("contractFactory address:", contract.address);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/token/MGN_1155.sol:MGN_1155",
      constructorArguments: ["Space_1155", "Space"],
    });
  }, 5000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
