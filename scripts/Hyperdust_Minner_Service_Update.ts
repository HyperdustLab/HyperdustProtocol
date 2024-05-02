/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Minner_Service = await ethers.getContractFactory('Hyperdust_Minner_Service')

  await upgrades.upgradeProxy('0x068aD13aFa73F742533fDf4fDDc577f8A9925E65', _Hyperdust_Minner_Service)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
