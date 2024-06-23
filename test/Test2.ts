/** @format */

import { ethers } from 'hardhat'

const xlsx = require('node-xlsx')

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()
      const HyperAGI_1155 = await ethers.getContractAt('HyperAGI_1155', '0x7A3709f067FFc984cd0D16934a9d88f0D255D326')

      await (await HyperAGI_1155.burn('0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f', 1, 1)).wait()
    })
  })
})
