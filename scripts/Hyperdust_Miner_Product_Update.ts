/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Miner_Product = await ethers.getContractFactory('Hyperdust_Miner_Product')

  await upgrades.upgradeProxy('0xE78Edff405764547c7Baf904c8834F74b41c9015', _Hyperdust_Miner_Product)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
