/** @format */

import { ethers, run } from "hardhat";

async function main() {

  const MGN_721 = await ethers.deployContract("MGN_721", ["Space NFT", "space"]);
  console.info("contractFactory address:", MGN_721.target);

}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
