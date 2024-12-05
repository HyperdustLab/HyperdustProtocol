/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Agent = await ethers.getContractFactory('HyperAGI_Agent')

  const HyperAGI_Agent = await upgrades.upgradeProxy('0xb90F1d2b0eF4aC49548cad06d44Bc1145793332C', _HyperAGI_Agent)

  console.info('contractFactory address:', HyperAGI_Agent.target)

  const implementationAddress = await upgrades.erc1967.getImplementationAddress(HyperAGI_Agent.target)
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
