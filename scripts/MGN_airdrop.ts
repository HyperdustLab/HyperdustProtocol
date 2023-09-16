/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Airdrop");

  const accounts = await ethers.getSigners();

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  console.info("contractFactory address:", contract.address);

  await (await contract.setRolesCfgAddress("0x57B938452f79959d59e843118C502D995eb1418B")).wait();
  await (await contract.setErc20Address("0x7a798E8eC045f911684dAa28B38a54b883b9523C")).wait();

  const MGN_20 = await ethers.getContractAt("MGN_20", "0x7a798E8eC045f911684dAa28B38a54b883b9523C");

  await (await MGN_20.approve(contract.address, ethers.utils.parseEther("500"))).wait();

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/MGN_Airdrop.sol:MGN_Airdrop",
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
