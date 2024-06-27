/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()

      const _HyperAGI_Node_Mgr = await ethers.getContractFactory('HyperAGI_Node_Mgr')

      const HyperAGI_Node_Mgr = await upgrades.upgradeProxy('0xb5965619C95373587444DaAd217157624545C58b', _HyperAGI_Node_Mgr)

      await (await HyperAGI_Node_Mgr.addNode(['1'], ['1'], ['1'], [accounts[0].address], 0)).wait()
    })
  })
})
