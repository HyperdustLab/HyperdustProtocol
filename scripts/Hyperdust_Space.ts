/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contract = await ethers.deployContract("Hyperdust_Space");
  await contract.waitForDeployment()

  await (await contract.setHyperdustRolesCfgAddress("0xd5A7E4eFb8Ae98aadE6d0078B3FeCf06c44c55Ae")).wait()

  console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
