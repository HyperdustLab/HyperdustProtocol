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

  await (await instance.setContractAddress(['0xF13842B9E794A0970DCbCa245B963d3d0d804317', '0xE39E20A5c54e0342201BBAd3dc322e79BA54a8CF', '0x8373Bd7e299F6d61490993EDadfF8D61357964E1', '0x7a798E8eC045f911684dAa28B38a54b883b9523C', HyperAGI_Storage.target])).wait()

  await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0xF13842B9E794A0970DCbCa245B963d3d0d804317')
  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
