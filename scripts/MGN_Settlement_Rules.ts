/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Settlement_Rules");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.setRoleAddress("0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837")).wait();

  console.info("contractFactory address:", contract.address);

  await run("verify:verify", {
    address: contract.address,
    contract: "contracts/MGN_Settlement_Rules.sol:MGN_Settlement_Rules",
    constructorArguments: [],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
