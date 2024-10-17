/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (
    await instance.setContractAddress([
      '0x7B33C8D43C52d0c575eACaEcFdAd68487bfB28Ea',
      '0xe138B94334eE720291EF5F7D926CbE18f9eeAB93',
      '0x78648b6a5d4b136E30935B5A22B93625AEb58c51',
      '0x5EE4a2d60762F32a8FF3b0addBcB0f4083e76E67',
      '0x00B0f90d44AFa75E9e83Bed557A94a4bC7F2e222',
      '0x401f50176C74F0aa49FeF7Aea83eeB349bEABF19',
    ])
  ).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x7B33C8D43C52d0c575eACaEcFdAd68487bfB28Ea')

  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  const HyperAGI_GPUMining = await ethers.getContractAt('HyperAGI_GPUMining', '0x00B0f90d44AFa75E9e83Bed557A94a4bC7F2e222')

  await (await HyperAGI_GPUMining.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
