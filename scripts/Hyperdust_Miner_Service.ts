/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Storage = await ethers.getContractFactory('Hyperdust_Storage')
  const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address])
  await Hyperdust_Storage.waitForDeployment()
  const contract = await ethers.getContractFactory('Hyperdust_Miner_Service')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  console.info('Hyperdust_Storage:', Hyperdust_Storage.target)

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

  await (
    await instance.setContractAddress(['0x9bDaf3912e7b4794fE8aF2E748C35898265D5615', '0x9D88106Ba510D3852eC03B22b8F754F2bcd16739', '0xE78Edff405764547c7Baf904c8834F74b41c9015', '0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f', Hyperdust_Storage.target, '0x6f1f77abeC447B2eAeaA49093385Dc61e1E91606'])
  ).wait()

  const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x9bDaf3912e7b4794fE8aF2E748C35898265D5615')
  await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

  await (await instance.setHyperdustStorageAddress(Hyperdust_Storage.target)).wait()

  const Hyperdust_721 = await ethers.getContractAt('Hyperdust_721', '0x6f1f77abeC447B2eAeaA49093385Dc61e1E91606')

  await (await Hyperdust_721.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()
  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
