/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Mint");

  const accounts = await ethers.getSigners();

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.setRoleAddress("0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837")).wait();
  await (await contract.setSettlementAddress(accounts[0].getAddress())).wait();
  await (await contract.setErc20Address("0x7a798E8eC045f911684dAa28B38a54b883b9523C")).wait();

  console.info("contractFactory address:", contract.address);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/MGN_Mint.sol:MGN_Mint",
      constructorArguments: [],
    });
  }, 3000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
