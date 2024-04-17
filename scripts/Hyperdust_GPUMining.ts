/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('Hyperdust_GPUMining')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address, 60 * 60 * 24 * 365])
  await instance.waitForDeployment()

  await (await instance.setHyperdustTokenAddress('0x1a41f86248E33e5327B26092b898bDfe04C6d8b4')).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
