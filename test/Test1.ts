/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()
      const blockNumber = await ethers.provider.getBlockNumber()
      console.log('当前区块高度:', blockNumber)

      // const _HyperAGI_Node_Mgr = await ethers.getContractFactory('HyperAGI_Node_Mgr')

      // const HyperAGI_Node_Mgr = await upgrades.upgradeProxy('0x3212Ef195c7322fe618f62AA147D40090A89ef22', _HyperAGI_Node_Mgr)

      // const HyperAGI_Node_Mgr = await ethers.getContractAt('HyperAGI_Node_Mgr', '0x3212Ef195c7322fe618f62AA147D40090A89ef22')

      // const a = await HyperAGI_Node_Mgr.getNode(1)

      // console.info(a)
    })
  })
})
