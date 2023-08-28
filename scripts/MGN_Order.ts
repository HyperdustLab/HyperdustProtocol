/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Order");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();


  await (await contract.setRoleAddress("0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837")).wait();
  await (await contract.setErc20Address("0x7a798E8eC045f911684dAa28B38a54b883b9523C")).wait();
  await (await contract.setMinerNodeAddress("0x2D2a3648D73BE67ac8e6a3a925E33E94c029679F")).wait();
  await (await contract.setSettlementRulesAddress("0x8373Bd7e299F6d61490993EDadfF8D61357964E1")).wait();
  await (await contract.setSettlementRulesAddress("0x8373Bd7e299F6d61490993EDadfF8D61357964E1")).wait();

  const MGN_Role = await ethers.getContractAt("MGN_Role", "0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837");
  await (
    await MGN_Role.addAdmin(contract.address)
  ).wait;

  await run("verify:verify", {
    address: contract.address,
    contract: "contracts/MGN_Order.sol:MGN_Order",
    constructorArguments: [],
  });

  console.info("contractFactory address:", contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
