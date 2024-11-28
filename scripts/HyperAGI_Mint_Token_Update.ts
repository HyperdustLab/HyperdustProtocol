/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Mint_Token = await ethers.getContractFactory('HyperAGI_Mint_Token')

  const HyperAGI_Mint_Token = await upgrades.upgradeProxy('0x6A838AEbC2bDcD7AE2d3192d54f41BeEFaD3c2De', _HyperAGI_Mint_Token)

  const implementationAddress = await upgrades.erc1967.getImplementationAddress(HyperAGI_Mint_Token.target)
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
