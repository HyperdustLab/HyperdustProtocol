/** @format */

import { ethers } from 'hardhat'

import { promisify } from 'util'

const request = require('request')

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const Hyperdust_Token = await ethers.getContractAt('Hyperdust_Token', '0x1a41f86248E33e5327B26092b898bDfe04C6d8b4')

      await (await Hyperdust_Token.startTGETimestamp()).wait()

      await (await Hyperdust_Token.setMinterAddeess(ethers.keccak256(ethers.toUtf8Bytes('CORE_TEAM')), '0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f')).wait()

      await (await Hyperdust_Token.mint(ethers.parseEther('100000'))).wait()
    })
  })
})
