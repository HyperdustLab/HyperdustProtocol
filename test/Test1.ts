/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      // const _HyperAGI_Epoch_Awards_Test = await ethers.getContractFactory('HyperAGI_Epoch_Awards_Test')

      // const HyperAGI_Epoch_Awards_Test = await upgrades.upgradeProxy('0x517c1883C1051e2029f6a7B637c4EDF2fC3D9D7A', _HyperAGI_Epoch_Awards_Test)

      const HyperAGI_Epoch_Awards_Test = await ethers.getContractAt('HyperAGI_Epoch_Awards_Test', '0x517c1883C1051e2029f6a7B637c4EDF2fC3D9D7A')

      await (await HyperAGI_Epoch_Awards_Test.rewards(['0x1100111100001100000000000000000000000000000000000000000000000000'], 0, 0)).wait()
    })
  })
})
