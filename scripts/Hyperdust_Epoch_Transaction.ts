/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Storage = await ethers.getContractFactory('Hyperdust_Storage')
  const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address])
  await Hyperdust_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('Hyperdust_Epoch_Transcition')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  console.info('Hyperdust_Storage:', Hyperdust_Storage.target)

  await (
    await instance.setContractAddress(['0x213b5E4FF6B805dC5C9AF66B0e1f84A035Fa80D5', '0x1a41f86248E33e5327B26092b898bDfe04C6d8b4', '0x7a798E8eC045f911684dAa28B38a54b883b9523C', '0x9c9294920f180321FC0Aa4EE090E4e96FbeB98Ac', '0xDa3e9fD7d9b447fbaf1383E61458B1FA55Bff94F', Hyperdust_Storage.target])
  ).wait()

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

  const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x213b5E4FF6B805dC5C9AF66B0e1f84A035Fa80D5')
  await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
