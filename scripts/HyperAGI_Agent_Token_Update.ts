/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Agent_Token = await ethers.getContractFactory('HyperAGI_Agent_Token')

  const HyperAGI_Agent_Token = await upgrades.upgradeProxy('0x709722ed57452a5B25860e4C8D1F7BB5275ac00B', _HyperAGI_Agent_Token)

  const implementationAddress = await upgrades.erc1967.getImplementationAddress(HyperAGI_Agent_Token.target)
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
