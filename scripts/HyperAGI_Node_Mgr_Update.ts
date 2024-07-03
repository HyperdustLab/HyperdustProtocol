/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Node_Mgr = await ethers.getContractFactory('HyperAGI_Node_Mgr')

  const HyperAGI_Node_Mgr = await upgrades.upgradeProxy('0x32D068a9955891C25311aeA4194E6658E67249Fc', _HyperAGI_Node_Mgr)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
