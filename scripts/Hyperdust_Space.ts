/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contract = await ethers.deployContract("Hyperdust_Space");
  await contract.waitForDeployment()

  await (await contract.setHyperdustRolesCfgAddress("0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14")).wait()

  console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
