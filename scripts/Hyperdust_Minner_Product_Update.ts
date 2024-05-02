/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Minner_Product = await ethers.getContractFactory('Hyperdust_Minner_Product')

  await upgrades.upgradeProxy('0x8f1cDf8491c76cb6c192D7C4d552b3588A30C3fF', _Hyperdust_Minner_Product)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
