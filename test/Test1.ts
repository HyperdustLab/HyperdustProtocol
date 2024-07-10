/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const _HyperAGI_Agent_Epoch_Awards = await ethers.getContractFactory('HyperAGI_Agent_Epoch_Awards')

      const HyperAGI_Agent_Epoch_Awards = await upgrades.upgradeProxy('0x78Be0b13c10519C112789FD401D4C04d8F3c23Bd', _HyperAGI_Agent_Epoch_Awards)

      await (await HyperAGI_Agent_Epoch_Awards.rewards(['0x1100000000000000000000000000000000000000000000000000000000000000'], 1, 0)).wait()
    })
  })
})
