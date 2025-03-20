/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  // const _HyperAGI_AgentWallet = await ethers.getContractFactory('HyperAGI_AgentWallet')

  // const instance = await upgrades.upgradeProxy('0x6759Aa64749b8fE3E294E7A73Ce6ee14eBF4270d', _HyperAGI_AgentWallet)

  const implementationAddress = await upgrades.erc1967.getImplementationAddress('0x6759Aa64749b8fE3E294E7A73Ce6ee14eBF4270d')
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
