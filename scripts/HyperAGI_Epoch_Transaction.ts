/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
  const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
  await HyperAGI_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('HyperAGI_Epoch_Transaction')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  console.info('HyperAGI_Storage:', HyperAGI_Storage.target)

  await (await instance.setContractAddress(['0x7B33C8D43C52d0c575eACaEcFdAd68487bfB28Ea', '0xe138B94334eE720291EF5F7D926CbE18f9eeAB93', '0x9f106E08EfF47a4E1b3340937A14B465E5B74fff', '0x401f50176C74F0aa49FeF7Aea83eeB349bEABF19', HyperAGI_Storage.target])).wait()

  await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x7B33C8D43C52d0c575eACaEcFdAd68487bfB28Ea')
  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
