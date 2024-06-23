/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()

      const _HyperAGI_AI_Node_Mgr = await ethers.getContractFactory('HyperAGI_AI_Node_Mgr')

      const HyperAGI_AI_Node_Mgr = await upgrades.upgradeProxy('0x7398A010cAeb507F37fD11215e8b8f53C1Ce943E', _HyperAGI_AI_Node_Mgr)

      const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x5745090BFB28C3399223215DfbBb4e729aeF8cFD')

      await (
        await HyperAGI_Roles_Cfg.addAdmin(HyperAGI_AI_Node_Mgr.target)
      ).wait

      await (await HyperAGI_AI_Node_Mgr.active(1, { value: 356636039062500n })).wait()
    })
  })
})
