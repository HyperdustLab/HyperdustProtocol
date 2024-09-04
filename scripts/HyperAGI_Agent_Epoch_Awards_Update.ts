/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Agent_Epoch_Awards = await ethers.getContractFactory('HyperAGI_Agent_Epoch_Awards')

  const HyperAGI_Agent_Epoch_Awards = await upgrades.upgradeProxy('0x78Be0b13c10519C112789FD401D4C04d8F3c23Bd', _HyperAGI_Agent_Epoch_Awards)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
