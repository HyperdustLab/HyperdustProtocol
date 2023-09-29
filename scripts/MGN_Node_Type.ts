/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contract = await ethers.deployContract("MGN_Node_Type");

  await (await contract.setRolesCfgAddress("0x8e0f8f0137F289456322F912a145cC30485CEcBc")).wait();

  console.info("contractFactory address:", contract.target);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.target,
      contract: "contracts/node/MGN_Node_Type.sol:MGN_Node_Type",
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
