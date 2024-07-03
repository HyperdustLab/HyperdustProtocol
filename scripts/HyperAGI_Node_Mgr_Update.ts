/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Node_Mgr = await ethers.getContractFactory('HyperAGI_Node_Mgr')

  await upgrades.upgradeProxy('0x3212Ef195c7322fe618f62AA147D40090A89ef22', _HyperAGI_Node_Mgr)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
