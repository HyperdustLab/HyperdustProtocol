/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_Transaction_Cfg', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()

      const Hyperdust_Token = await ethers.deployContract('Hyperdust_Token', ['Hyperdust Token', 'HYPT Test', accounts[0].address])

      await Hyperdust_Token.waitForDeployment()

      const contract = await ethers.getContractFactory('Hyperdust_GPUMining')
      const instance = await upgrades.deployProxy(contract, [accounts[0].address, 600])
      await instance.waitForDeployment()

      Hyperdust_Token.setG
    })
  })
})
