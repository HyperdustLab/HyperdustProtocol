/** @format */

import { ethers, upgrades } from 'hardhat'

const xlsx = require('node-xlsx')

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const _HyperAGI_BaseReward_Release = await ethers.getContractFactory('HyperAGI_BaseReward_Release')

      const HyperAGI_BaseReward_Release = await upgrades.upgradeProxy('0x222Cc33Ed67877C195DE0D8347DDE4D0ebE8bBC7', _HyperAGI_BaseReward_Release)

      await (await HyperAGI_BaseReward_Release.addBaseRewardReleaseRecord(102283105022831050n, '0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f', { value: 102283105022831050n })).wait()
    })
  })
})
