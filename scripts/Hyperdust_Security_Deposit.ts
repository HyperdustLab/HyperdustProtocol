/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Storage = await ethers.getContractFactory('Hyperdust_Storage')
  const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address])
  await Hyperdust_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('Hyperdust_Security_Deposit')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0x9D88106Ba510D3852eC03B22b8F754F2bcd16739', '0xaea9e80F367363c4255A055cA11080DaA5BB840B', Hyperdust_Storage.target, '0xCe25B74F7C6C26c3A02B61e2eca6f9EBC10CcC17', '0xad20ce3a9dce85708074BD7a0E6F4b355151e040'])).wait()

  const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x9D88106Ba510D3852eC03B22b8F754F2bcd16739')
  await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

  console.info('Hyperdust_Storage:', Hyperdust_Storage.target)

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
