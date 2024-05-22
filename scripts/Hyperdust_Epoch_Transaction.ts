/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Storage = await ethers.getContractFactory('Hyperdust_Storage')
  const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address])
  await Hyperdust_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('Hyperdust_Epoch_Transaction')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  console.info('Hyperdust_Storage:', Hyperdust_Storage.target)

  await (
    await instance.setContractAddress(['0x9bDaf3912e7b4794fE8aF2E748C35898265D5615', '0xfcb8A945DC86D72f906D9C63222Dc470b5A35548', '0x9b7339B4FE58A2541d4e87FC6e6e35Dc9cBc77D5', '0xe8ADeF97900b154f89417817C6621cd33D39d009', '0x6b3F5603cbD8909cEBD804638E7E29D73e5334dA', Hyperdust_Storage.target])
  ).wait()

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

  const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x9bDaf3912e7b4794fE8aF2E748C35898265D5615')
  await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
