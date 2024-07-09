/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const _HyperAGI_Ecpoch_Awards = await ethers.getContractFactory('HyperAGI_Ecpoch_Awards')

      await upgrades.upgradeProxy('0x7d95f40C84eE93D77aD6bF7f1Ba1dE807C46cE43', _HyperAGI_Ecpoch_Awards)
    })
  })
})
