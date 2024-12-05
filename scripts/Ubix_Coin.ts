/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  // const contract = await ethers.deployContract('Ubix_Coin', ['0x19aa5b4bB6Ca72515845D6Faf1A69c1e06ff20C0'])
  // await contract.waitForDeployment()
  // console.info('contractFactory address:', contract.target)

  await run('verify:verify', {
    address: '0xE9A092f24f077Cc17F939d56273b7E140D9bB728',
    constructorArguments: ['0x19aa5b4bB6Ca72515845D6Faf1A69c1e06ff20C0'],
    contract: 'contracts/finance/Ubix_Coin.sol:Ubix_Coin',
  })
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
