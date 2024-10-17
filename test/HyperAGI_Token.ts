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

      await (await contract.setMinterAddress(UBAI, accounts[0].address)).wait()
      await (await contract.setMinterAddress(GPU_MINING, accounts[1].address)).wait()
      const fs = require('fs')
      const xlsx = require('xlsx')
      const workbook = xlsx.utils.book_new()
      const worksheetData = [['UBAI_availableMintAmount_last_time', 'UBAI_availableMintAmount', 'UBAI_CurrAward', 'GPU_MINING_availableMintAmount_last_time', 'GPU_MINING_availableMintAmount', 'GPU_MINING_CurrAward']]

      for (let i = 0; i < 100; i++) {
        const lastGpuMiningMintTime = new Date(Number(await contract.lastGpuMiningMintTime()) * 1000).toISOString()
        const lastUbaiMintTime = new Date(Number(await contract.lastUbaiMintTime()) * 1000).toISOString()

        const UBAI_availableMintAmount = await contract.getAvailableMintAmount(UBAI)
        const GPU_MINING_availableMintAmount = await contract.getAvailableMintAmount(GPU_MINING)

        const UBAI_CurrAward = await contract.getCurrAward(UBAI)
        const GPU_MINING_CurrAward = await contract.getCurrAward(GPU_MINING)

        worksheetData.push([lastGpuMiningMintTime, ethers.formatEther(UBAI_availableMintAmount[0]), ethers.formatEther(UBAI_CurrAward), lastUbaiMintTime, ethers.formatEther(GPU_MINING_availableMintAmount[0]), ethers.formatEther(GPU_MINING_CurrAward)])

        await (await contract.mint(UBAI_availableMintAmount[0])).wait()
        await (await contract.connect(accounts[1]).mint(GPU_MINING_availableMintAmount[0])).wait()
        await ethers.provider.send('evm_increaseTime', [600])
        await ethers.provider.send('evm_mine', [])
      }

      const worksheet = xlsx.utils.aoa_to_sheet(worksheetData)
      xlsx.utils.book_append_sheet(workbook, worksheet, 'Minting Data')
      xlsx.writeFile(workbook, 'MintingData.xlsx')
    })
  })
})
