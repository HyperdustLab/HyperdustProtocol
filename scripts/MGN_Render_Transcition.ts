/** @format */

import { ethers, run } from "hardhat";

async function main() {


  const MGN_Render_Transcition = await ethers.deployContract("MGN_Render_Transcition");


  console.info("contractFactory address:", MGN_Render_Transcition.target);

  await (await MGN_Render_Transcition.setContractAddress([
    "0x8e0f8f0137F289456322F912a145cC30485CEcBc",
    "0x4241f24ce6ddebd073fe0c76bd5bc5da9c831728",
    "0x1841a1CE522fc9C8bE47a30812687e194b837384",
    "0x1525BB0d0FFCb61E003D68453Ca75A8B10854F8a",
    "0x2b8b17D0d4D1A7D362e8Ed8b827117F7B9563c0e",
    "0xe61673C1c920027B45830Dfc1A112E2ab3717a2f",
    "0x513521e80A9d4854bb71ddbE768792B46f2ce9E8",
    "0x3d8da5E9eE733411C16BE87A86EF666D15332104"
  ])).wait();


  const MGN_Roles_Cfg = await ethers.getContractAt("MGN_Roles_Cfg", "0x8e0f8f0137F289456322F912a145cC30485CEcBc");
  await (
    await MGN_Roles_Cfg.addAdmin(MGN_Render_Transcition.target)
  ).wait;

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
