/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Pool_Level = await ethers.getContractFactory('HyperAGI_Pool_Level')

  const HyperAGI_Pool_Level = await upgrades.upgradeProxy('0xA7C70bAa098468260a4feCcC9d603EDE56bf7C42', _HyperAGI_Pool_Level)

  const implementationAddress = await upgrades.erc1967.getImplementationAddress(HyperAGI_Pool_Level.target)
  await run('verify:verify', {
    address: implementationAddress,
    constructorArguments: [],
  })
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
