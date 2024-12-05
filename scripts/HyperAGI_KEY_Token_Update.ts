/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Epoch_Transaction = await ethers.getContractFactory('HyperAGI_KEY_Token')

  await upgrades.upgradeProxy('0x34F1Ec39e529c1c57078d12d20c4e7564809AB5C', _HyperAGI_Epoch_Transaction)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
