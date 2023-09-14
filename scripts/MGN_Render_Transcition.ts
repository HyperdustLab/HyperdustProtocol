/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Render_Transcition");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  console.info("contractFactory address:", contract.address);

  await (await contract.setRolesCfgAddress("0x57B938452f79959d59e843118C502D995eb1418B")).wait();
  await (await contract.setErc20Address("0x7a798E8eC045f911684dAa28B38a54b883b9523C")).wait();
  await (await contract.setNodeMgrAddress("0x7423928ad6FAfD4653DCC221510EB16cC2b40E8D")).wait();
  await (await contract.setSettlementRulesAddress("0x7381f57a7504E4a4222c75efF60bcd331631867b")).wait();

  const MGN_Role = await ethers.getContractAt("MGN_Roles_Cfg", "0x57B938452f79959d59e843118C502D995eb1418B");
  await (
    await MGN_Role.addAdmin(contract.address)
  ).wait;

  const MGNToken = await ethers.getContractAt("MGN_20", "0x7a798E8eC045f911684dAa28B38a54b883b9523C");

  await MGNToken.approve(contract.address, 1000000000000000);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/MGN_Render_Transcition.sol:MGN_Render_Transcition",
      constructorArguments: [],
    });
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
