/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
  const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
  await HyperAGI_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('HyperAGI_Node_Mgr')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  console.info('HyperAGI_Storage:', HyperAGI_Storage.target)

  await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0xF13842B9E794A0970DCbCa245B963d3d0d804317', HyperAGI_Storage.target, '0x58c71FeE5bd026e8E0A39E0545F278Ee4b9b1C7E'])).wait()

  // const HyperAGI_Transaction_Cfg = await ethers.getContractAt('HyperAGI_Transaction_Cfg', '0x8373Bd7e299F6d61490993EDadfF8D61357964E1')

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0xF13842B9E794A0970DCbCa245B963d3d0d804317')

  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  // await (await HyperAGI_Transaction_Cfg.setNodeMgrAddress(instance.target)).wait()
  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
