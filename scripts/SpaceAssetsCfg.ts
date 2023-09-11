/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("SpaceAssetsCfg");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (
    await contract.setContractAddress([
      "0x419387c8843D29b0E085326710c495350DEA3d1D",
      "0x7a798E8eC045f911684dAa28B38a54b883b9523C",
      "0xe685F0CaBe192749ec54870bb86cdD68223E4C14",
      "0x57B938452f79959d59e843118C502D995eb1418B",
    ])
  ).wait();

  console.info("contractFactory address:", contract.address);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/spaceAssets/SpaceAssetsCfg.sol:SpaceAssetsCfg",
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
