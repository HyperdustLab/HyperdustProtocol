/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const Hyperdust_Node_Mgr = await ethers.getContractFactory('Hyperdust_Node_Mgr')

  const upgraded = await upgrades.upgradeProxy('0x9b7339B4FE58A2541d4e87FC6e6e35Dc9cBc77D5', Hyperdust_Node_Mgr)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
