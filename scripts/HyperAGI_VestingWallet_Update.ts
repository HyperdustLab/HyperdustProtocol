/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_VestingWallet = await ethers.getContractFactory('HyperAGI_VestingWallet')

  const instance = await upgrades.upgradeProxy('0x24BC301057A61405C7b1Ab19F3f51cA985255117', _HyperAGI_VestingWallet)

  console.info('contractFactory address:', instance.target)

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
