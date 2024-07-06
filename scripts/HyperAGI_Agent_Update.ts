/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Agent = await ethers.getContractFactory('HyperAGI_Agent')

  const HyperAGI_Agent = await upgrades.upgradeProxy('0x01D8B9D4C932E3A3b29FAe1135cBBcB31EeA8CEE', _HyperAGI_Agent)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
