/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MOSSAI_ERC_721");

  const factory = await contractFactory.deploy("Space NFT", "space");
  const contract = await factory.deployed();
  await contract.deployed();

  console.info("contractFactory address:", contract.address);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/token/MOSSAI_ERC_721.sol:MOSSAI_ERC_721",
      constructorArguments: ["Space NFT", "space"],
    });
  }, 3000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
