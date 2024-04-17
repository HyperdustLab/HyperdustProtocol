/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_Security_Deposit', () => {
  describe('Hyperdust_Security_Deposit', () => {
    it('Hyperdust_Security_Deposit', async () => {
      const accounts = await ethers.getSigners()

      const _Hyperdust_Roles_Cfg = await ethers.getContractFactory('Hyperdust_Roles_Cfg')
      const Hyperdust_Roles_Cfg = await upgrades.deployProxy(_Hyperdust_Roles_Cfg)

      const Hyperdust_Token = await ethers.deployContract('Hyperdust_Token_Test', ['TEST', 'TEST', accounts[0].address])
      await Hyperdust_Token.waitForDeployment()

      await (await Hyperdust_Token.setPrivateSaleAddress(accounts[0].address)).wait()

      await (await Hyperdust_Token.mint(ethers.parseEther('100000'))).wait()

      const _Hyperdust_Wallet_Account = await ethers.getContractFactory('Hyperdust_Wallet_Account')
      const Hyperdust_Wallet_Account = await upgrades.deployProxy(_Hyperdust_Wallet_Account, [accounts[0].address])

      const Hyperdust_Wallet_Account_Data = await ethers.deployContract('Hyperdust_Storage')
      await Hyperdust_Wallet_Account_Data.waitForDeployment()

      await (await Hyperdust_Wallet_Account_Data.setServiceAddress(Hyperdust_Wallet_Account.target)).wait()

      await (await Hyperdust_Wallet_Account.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target, Hyperdust_Wallet_Account_Data.target])).wait()

      await (await Hyperdust_Wallet_Account.addAmount(ethers.parseEther('0.1'))).wait()
    })
  })
})
