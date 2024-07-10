/** @format */

import { ethers } from 'hardhat'

const xlsx = require('node-xlsx')

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      // 创建一个新的随机钱包
      const wallet = ethers.Wallet.createRandom()

      // 打印钱包的私钥
      console.log('Wallet private key:', wallet.privateKey)
      console.log('Wallet private address:', wallet.address)
    })
  })
})
