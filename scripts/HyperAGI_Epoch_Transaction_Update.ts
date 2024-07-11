/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Epoch_Transaction = await ethers.getContractFactory('HyperAGI_Epoch_Transaction')

  await upgrades.upgradeProxy('0xA0339F349D2BfA2fE2393686DBA3823ea1b9B96e', _HyperAGI_Epoch_Transaction)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
