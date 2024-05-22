/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const Hyperdust_Epoch_Awards = await ethers.getContractAt('Hyperdust_Epoch_Awards', '0x1803EE20F036B0ab1d8dD499df6bAa8BbCB4ed23')
  const Hyperdust_GPUMining = await ethers.getContractAt('Hyperdust_GPUMining', '0x12991d54B51945c167b8d6Eb378290F1e83fc1D9')

  const hasRole1 = await Hyperdust_GPUMining.hasRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', '0x1803EE20F036B0ab1d8dD499df6bAa8BbCB4ed23')

  console.info(hasRole1)

  //   const Hyperdust_Epoch_Awards = await upgrades.upgradeProxy('0x1803EE20F036B0ab1d8dD499df6bAa8BbCB4ed23', _Hyperdust_Epoch_Awards)

  await (await Hyperdust_Epoch_Awards.rewards(['0x1100000000000000000000000000000000000000000000000000000000000000'], 1)).wait()
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
