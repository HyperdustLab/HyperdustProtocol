/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contract = await ethers.deployContract("MGN_Roles_Cfg");

  console.info("contractFactory address:", contract.target);



  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.target,
      contract: "contracts/MGN_Roles_Cfg.sol:MGN_Roles_Cfg",
      constructorArguments: [],
    });
  }, 5000);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
