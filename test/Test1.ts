/** @format */

import { ethers } from 'hardhat'

import { promisify } from 'util'

const request = require('request')

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const Hyperdust_Transaction_Cfg = await ethers.getContractAt('Hyperdust_Transaction_Cfg', '0x9c9294920f180321FC0Aa4EE090E4e96FbeB98Ac')

      const tx = await Hyperdust_Transaction_Cfg.getGasFee('epoch')
      
      console.info(tx)
    })
  })
})
