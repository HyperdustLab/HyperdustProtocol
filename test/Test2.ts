/** @format */

import { Interface, InterfaceAbi } from 'ethers'
import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {


      const HyperAGI_Mint_Token = await ethers.getContractAt('HyperAGI_Mint_Token', '0x1B74cf43bF9Dc309918DB5162498fE436e161e9B')

      await (await HyperAGI_Mint_Token.mint([1], ['0xdeFC8022e6151ac596ab4136D902c988a8560679'], [0], [1], ['0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f'])).wait()


    })
  })
})
