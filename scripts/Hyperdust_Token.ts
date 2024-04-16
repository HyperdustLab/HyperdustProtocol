/** @format */

import { ethers, run } from 'hardhat'

async function main() {
  const contract = await ethers.deployContract('Hyperdust_Token', ['Hyperdust Token', 'HYPT Test V0001', '0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2'])

  await contract.waitForDeployment()

  console.info('contractFactory address:', contract.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
