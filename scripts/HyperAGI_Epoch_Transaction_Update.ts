/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Epoch_Transaction = await ethers.getContractFactory('HyperAGI_Epoch_Transaction')

  await upgrades.upgradeProxy('0xC8c0Cb1F6642B8700B4865c47C8C5d0b956b84E5', _HyperAGI_Epoch_Transaction)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
