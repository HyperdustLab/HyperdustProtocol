/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Render_Transcition");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.setRolesCfgAddress("0xB05c1453486195DD7bd572571ce7131707DA9411")).wait();
  await (await contract.setErc20Address("0x7a798E8eC045f911684dAa28B38a54b883b9523C")).wait();
  await (await contract.setNodeAddress("0x7423928ad6FAfD4653DCC221510EB16cC2b40E8D")).wait();
  await (await contract.setSettlementRulesAddress("0x7423928ad6FAfD4653DCC221510EB16cC2b40E8D")).wait();

  const MGN_Role = await ethers.getContractAt("MGN_Roles_Cfg", "0xB05c1453486195DD7bd572571ce7131707DA9411");
  await (
    await MGN_Role.addAdmin(contract.address)
  ).wait;

  console.info("contractFactory address:", contract.address);

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
