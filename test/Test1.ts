/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const _HyperAGI_Agent = await ethers.getContractFactory('HyperAGI_Agent')

      const HyperAGI_Agent = await upgrades.upgradeProxy('0x01D8B9D4C932E3A3b29FAe1135cBBcB31EeA8CEE', _HyperAGI_Agent)

      await (await HyperAGI_Agent.rechargeEnergy(1719481201509, '0xcd50d870ffaae3b6a8490016b435c7cbbbe7a55d03d578e289326ee41fc31393')).wait()
    })
  })
})
