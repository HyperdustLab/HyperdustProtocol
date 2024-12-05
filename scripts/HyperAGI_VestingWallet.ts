/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const HyperAGI_VestingWallet = await ethers.getContractFactory('HyperAGI_VestingWallet')

  const instance = await upgrades.deployProxy(HyperAGI_VestingWallet, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

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
