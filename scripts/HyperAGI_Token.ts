/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.deployContract('HyperAGIToken', ['0xD21B836E74109022c3f37676485E479EECce55db'])
  await contract.waitForDeployment()
  console.info('contractFactory address:', contract.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
