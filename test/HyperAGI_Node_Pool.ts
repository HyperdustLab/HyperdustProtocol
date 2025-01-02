/** @format */

import { ethers, upgrades } from 'hardhat'

const mysql = require('mysql2')

import fs from 'fs'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()

      const _HyperAGI_Roles_Cfg = await ethers.getContractFactory('HyperAGI_Roles_Cfg')
      const HyperAGI_Roles_Cfg = await upgrades.deployProxy(_HyperAGI_Roles_Cfg, [accounts[0].address])

      await HyperAGI_Roles_Cfg.waitForDeployment()

      const _HyperAGI_Node_Pool = await ethers.getContractFactory('HyperAGI_Node_Pool')
      const HyperAGI_Node_Pool = await upgrades.deployProxy(_HyperAGI_Node_Pool, [accounts[0].address, 1])

      await HyperAGI_Node_Pool.waitForDeployment()

      console.info('contractFactory address:', HyperAGI_Node_Pool.target)

      const HyperAGI_1155 = await ethers.deployContract('HyperAGI_1155', ['HyperAGI_KEY_Token', 'KEY Token', accounts[0].address])
      await HyperAGI_1155.waitForDeployment()

      const HyperAGI_Pool_Level = await deployHyperAGI_Pool_Level()

      await (await HyperAGI_Node_Pool.setContractAddresses([HyperAGI_Roles_Cfg.target, HyperAGI_1155.target, HyperAGI_Pool_Level.target])).wait()

      await (await HyperAGI_1155.mint(accounts[0].address, 1, 1, '1', '0x')).wait()

      await (await HyperAGI_1155.setApprovalForAll(HyperAGI_Node_Pool.target, true)).wait()

      const HyperAGI_Node_Mgr = await deployHyperAGI_Node_Mgr()

      const tx = await HyperAGI_Node_Mgr.active(1, ethers.parseEther('2'), 1, { value: ethers.parseEther('2.0001') })

      const logs = await tx.wait()
      for (const log of logs.logs) {
        if (log.address === HyperAGI_Node_Pool.target) {
          const parsedLog = HyperAGI_Node_Pool.interface.parseLog(log)
          console.log(`Event ${parsedLog?.name} with args:`, parsedLog?.args)
        } else if (log.address === HyperAGI_Pool_Level.target) {
          const parsedLog = HyperAGI_Pool_Level.interface.parseLog(log)
          console.log(`Event ${parsedLog?.name} with args:`, parsedLog?.args)
        } else if (log.address === HyperAGI_Node_Pool.target) {
          const parsedLog = HyperAGI_Node_Pool.interface.parseLog(log)
          console.log(`Event ${parsedLog?.name} with args:`, parsedLog?.args)
        }
      }

      async function deployHyperAGI_Node_Mgr() {
        const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
        const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [accounts[0].address])
        await HyperAGI_Storage.waitForDeployment()

        const contract = await ethers.getContractFactory('HyperAGI_Node_Mgr')
        const instance = await upgrades.deployProxy(contract, [accounts[0].address])
        await instance.waitForDeployment()

        console.info('HyperAGI_Storage:', HyperAGI_Storage.target)

        await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

        await (await instance.setContractAddress([HyperAGI_Roles_Cfg.target, HyperAGI_Storage.target, HyperAGI_Node_Pool.target])).wait()

        await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

        // await (await HyperAGI_Transaction_Cfg.setNodeMgrAddress(instance.target)).wait()
        console.info('contractFactory address:', instance.target)

        await (await instance.addNode(['192.168.1.1'], ['test'], [accounts[0].address], ethers.parseEther('0.0001'))).wait()

        return instance
      }

      async function deployHyperAGI_Pool_Level() {
        const contract = await ethers.getContractFactory('HyperAGI_Pool_Level')
        const instance = await upgrades.deployProxy(contract, [accounts[0].address])
        await instance.waitForDeployment()

        await (await instance.setRolesCfgAddress(HyperAGI_Roles_Cfg.target)).wait()

        // await (await HyperAGI_Transaction_Cfg.setNodeMgrAddress(instance.target)).wait()
        console.info('contractFactory address:', instance.target)

        const INFERENCE_NODE = await instance.INFERENCE_NODE()

        await (await instance.addLevelInfo(INFERENCE_NODE, 'test', ethers.parseEther('1'), 100)).wait()

        return instance
      }
    })
  })
})
