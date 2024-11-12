/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  // const contract = await ethers.deployContract('HyperAGI_BatchTransfer')
  // await contract.waitForDeployment()

  // console.info('contractFactory address:', contract.target)

  await run('verify:verify', {
    address: '0x4036149e5458BB9c541AF7768576998b7Bd379c0',
    constructorArguments: [],
  })
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
