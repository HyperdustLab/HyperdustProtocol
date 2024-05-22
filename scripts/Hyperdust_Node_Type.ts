/** @format */
import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Storage = await ethers.getContractFactory('Hyperdust_Storage')
  const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address])
  await Hyperdust_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('Hyperdust_Node_Type')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setRolesCfgAddress(process.env.RolesCfgAddress)).wait()
  await (await instance.setHyperdustStorageAddress(Hyperdust_Storage.target)).wait()

  console.info('Hyperdust_Storage:', Hyperdust_Storage.target)

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
