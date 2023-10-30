/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contract = await ethers.deployContract("Hyperdust_Space");
  await contract.waitForDeployment()

  await (await contract.setHyperdustRolesCfgAddress("0xba9b4229C58A7eD1De9eaa1773fEd064D8c8B88F")).wait()

  console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
