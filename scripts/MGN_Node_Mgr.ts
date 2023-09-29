/** @format */

import { ethers, run } from "hardhat";

async function main() {

  const MGN_Node_Mgr = await ethers.deployContract("MGN_Node_Mgr");


  await (await MGN_Node_Mgr.setRolesCfgAddress("0x8e0f8f0137F289456322F912a145cC30485CEcBc")).wait();
  await (await MGN_Node_Mgr.setNodeTypeAddress("0x78aad2a3628840b6b1f8523e4fc569cd1d7a0300")).wait();
  await (await MGN_Node_Mgr.setNodeCheckInAddress("0xBca8D16A228E401d956Fc393383fFFD68F63b803")).wait();

  console.info("contractFactory address:", MGN_Node_Mgr.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
