/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Storage = await ethers.getContractFactory('Hyperdust_Storage')
  const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address])
  await Hyperdust_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('Hyperdust_Node_Mgr')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  console.info('Hyperdust_Storage:', Hyperdust_Storage.target)

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0x2D2a3648D73BE67ac8e6a3a925E33E94c029679F', '0x2D2a3648D73BE67ac8e6a3a925E33E94c029679F', Hyperdust_Storage.target, '0xad20ce3a9dce85708074BD7a0E6F4b355151e040'])).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
