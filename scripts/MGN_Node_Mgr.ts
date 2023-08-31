/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Node_Mgr");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.setRolesCfgAddress("0xB05c1453486195DD7bd572571ce7131707DA9411")).wait();
  await (await contract.setNodeTypeAddress("0xdd1A079FaCB45bC2d8c698A426bB2E24F075393D")).wait();
  await (await contract.setNodeCheckInAddress("0xBca8D16A228E401d956Fc393383fFFD68F63b803")).wait();

  console.info("contractFactory address:", contract.address);

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/MGN_Node_Mgr.sol:MGN_Node_Mgr",
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
