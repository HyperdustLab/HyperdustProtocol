/** @format */

import { Interface, InterfaceAbi } from 'ethers'
import { ethers, upgrades } from 'hardhat'
import { access } from '../typechain-types/@openzeppelin/contracts'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()

      const contract = await ethers.deployContract('HyperAGI_Token', ['Test Token', 'TestToken0914', accounts[0].address])
      await contract.waitForDeployment()

      await (await contract.startTGE()).wait()

      const UBAI = await contract.UBAI()
      const GPU_MINING = await contract.GPU_MINING()
      const PUBLIC_SALE = await contract.PUBLIC_SALE()

      await (await contract.setMinterAddress(UBAI, accounts[0].address)).wait()
      let UBAI_availableMintAmount = await contract.getAvailableMintAmount(UBAI)
      let GPU_MINING_availableMintAmount = await contract.getAvailableMintAmount(GPU_MINING)
      let PUBLIC_SALE_availableMintAmount = await contract.getAvailableMintAmount(PUBLIC_SALE)

      console.info('UBAI_availableMintAmount', ethers.formatEther(UBAI_availableMintAmount))
      console.info('GPU_MINING_availableMintAmount', ethers.formatEther(GPU_MINING_availableMintAmount))
      console.info('PUBLIC_SALE_availableMintAmount', ethers.formatEther(PUBLIC_SALE_availableMintAmount))

      await (await contract.mint(ethers.parseEther('700000'))).wait()

      // 增加区块时间10分钟
      await ethers.provider.send('evm_increaseTime', [600])
      await ethers.provider.send('evm_mine', [])

      UBAI_availableMintAmount = await contract.getAvailableMintAmount(UBAI)

      console.info('UBAI_availableMintAmount2', ethers.formatEther(UBAI_availableMintAmount))
    })
  })
})
