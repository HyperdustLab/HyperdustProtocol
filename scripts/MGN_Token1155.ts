/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MOSSAI_1155_NFT");

  const factory = await contractFactory.deploy("MOSSAI ERC 1155 Token", "mos");
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", "0x2EBDe3e744d0a870a17A2d51fd9079f14BF2137B")).wait();

  console.info("contractFactory address:", contract.address);

  await run("verify:verify", {
    address: contract.address,
    contract: "contracts/token/MOSSAI_1155_NFT.sol:MOSSAI_1155_NFT",
    constructorArguments: ["MOSSAI ERC 1155 Token", "mos"],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
