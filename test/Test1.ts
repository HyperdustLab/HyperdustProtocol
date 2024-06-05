/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()

      const _HyperAGI_mNFT_Mint = await ethers.getContractFactory('HyperAGI_mNFT_Mint')

      const HyperAGI_mNFT_Mint = await upgrades.upgradeProxy('0x7028141A2BCc684f2204cE7DE4f5C0806b86F987', _HyperAGI_mNFT_Mint)

      await (await HyperAGI_mNFT_Mint.mint(1, 1, { value: ethers.parseEther('0.01') })).wait()
    })
  })
})
