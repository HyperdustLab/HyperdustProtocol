/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_BaseReward_Release = await ethers.getContractFactory('HyperAGI_BaseReward_Release')

  await upgrades.upgradeProxy('0x9D665ee3229Ad9ebBD1022E13Ae460E3c8dD1f24', _HyperAGI_BaseReward_Release)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
