/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contract = await ethers.deployContract("VRFv2Consumer", [6538]);
  await contract.waitForDeployment()


  console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
