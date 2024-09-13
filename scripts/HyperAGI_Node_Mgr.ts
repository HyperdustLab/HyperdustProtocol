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

  await (await instance.setContractAddress(['0x250a7629d076581d3713f016727204341865920C', HyperAGI_Storage.target, '0xcde391F904A8dBEC9A91AB27807851f83cA5F4ce'])).wait()

  // const HyperAGI_Transaction_Cfg = await ethers.getContractAt('HyperAGI_Transaction_Cfg', '0x8373Bd7e299F6d61490993EDadfF8D61357964E1')

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x250a7629d076581d3713f016727204341865920C')

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
