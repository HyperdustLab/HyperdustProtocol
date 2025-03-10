/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_GPUMining = await ethers.getContractFactory('HyperAGI_GPUMining')

  const instance = await upgrades.upgradeProxy('0x00B0f90d44AFa75E9e83Bed557A94a4bC7F2e222', _HyperAGI_GPUMining)

  const implementationAddress = await upgrades.erc1967.getImplementationAddress(instance.target)
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
