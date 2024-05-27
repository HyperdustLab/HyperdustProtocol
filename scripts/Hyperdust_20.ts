/** @format */

import { ethers, run } from 'hardhat'

async function main() {
  const contract = await ethers.deployContract('Hyperdust_20', ['Hyperdust Token', 'HYPT'])
  await contract.waitForDeployment()

  await (await contract.mint('0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f', ethers.parseEther('100000000000000'))).wait()

  console.info('contractFactory address:', contract.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
