/** @format */

import { ethers, run } from "hardhat";

async function main() {


  const MGN_Uniswap_liquidity_Cfg = await ethers.deployContract("MGN_Uniswap_liquidity_Cfg");


  await (await MGN_Uniswap_liquidity_Cfg.setRolesCfgAddress("0x8e0f8f0137F289456322F912a145cC30485CEcBc")).wait();

  console.info("contractFactory address:", MGN_Uniswap_liquidity_Cfg.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
