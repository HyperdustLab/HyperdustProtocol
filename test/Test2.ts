/** @format */

import { ethers, upgrades } from 'hardhat'

const xlsx = require('node-xlsx')

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      // const _HyperAGI_Roles_Cfg = await ethers.getContractFactory('HyperAGI_Roles_Cfg')
      // const HyperAGI_Roles_Cfg = await upgrades.deployProxy(_HyperAGI_Roles_Cfg, [process.env.ADMIN_Wallet_Address])
      // await HyperAGI_Roles_Cfg.waitForDeployment()
      // console.info('contractFactory address:', instance.target)
      // const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
      // const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
      // await HyperAGI_Storage.waitForDeployment()
      // const contract = await ethers.getContractFactory('HyperAGI_mNFT_Mint')
      // const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
      // await instance.waitForDeployment()
      // console.info('HyperAGI_Storage:', HyperAGI_Storage.target)
      // await (await instance.setContractAddress(['0xF13842B9E794A0970DCbCa245B963d3d0d804317', '0x7a798E8eC045f911684dAa28B38a54b883b9523C', HyperAGI_Storage.target, '0x8373Bd7e299F6d61490993EDadfF8D61357964E1'])).wait()
      // await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()
      // const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0xF13842B9E794A0970DCbCa245B963d3d0d804317')
      // await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()
      // console.info('contractFactory address:', instance.target)
    })
  })
})
