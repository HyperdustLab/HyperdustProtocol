/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Node_Pool')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address, 1])
  await instance.waitForDeployment()

  console.info(instance.fragments)

  await (await instance.setContractAddresses(['0x7B33C8D43C52d0c575eACaEcFdAd68487bfB28Ea', '0xf1abC280EF2a13a2b56D326cD6D60ADC5368eE54', '0xA7C70bAa098468260a4feCcC9d603EDE56bf7C42'])).wait()

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
