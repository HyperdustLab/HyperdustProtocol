/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Security_Deposit = await ethers.getContractFactory('HyperAGI_Security_Deposit')

  await upgrades.upgradeProxy('0xDf3DDF0762F16cAe14aC1db4fFA78D61fADb72d0', _HyperAGI_Security_Deposit)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
