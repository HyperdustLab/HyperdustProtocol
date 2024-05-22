/** @format */

import { ethers, run, upgrades } from 'hardhat';

async function main() {
  const Hyperdust_Space = await ethers.getContractFactory('Hyperdust_Space');

  await upgrades.upgradeProxy('0x605DC1c559315Cc3ea65E2a6840a5523029d0bbe', Hyperdust_Space);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
