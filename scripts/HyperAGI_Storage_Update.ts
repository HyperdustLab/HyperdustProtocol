/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')

  await upgrades.upgradeProxy('0x76b1bd7532ec8Bb2d5a8a0aCDAcFB2dA0584C70c', _HyperAGI_Storage)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
