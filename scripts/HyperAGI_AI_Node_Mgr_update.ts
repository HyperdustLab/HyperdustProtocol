/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_AI_Node_Mgr = await ethers.getContractFactory('HyperAGI_AI_Node_Mgr')

  await upgrades.upgradeProxy('0x7398A010cAeb507F37fD11215e8b8f53C1Ce943E', _HyperAGI_AI_Node_Mgr)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
