/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Space_Airdrop");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.setRolesCfgAddress("0x57B938452f79959d59e843118C502D995eb1418B")).wait();

  console.info("contractFactory address:", contract.address);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/space/MGN_Space_Airdrop.sol:MGN_Space_Airdrop",
      constructorArguments: [],
    });
  }, 5000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
