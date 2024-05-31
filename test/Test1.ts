/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()

      async function test1() {
        const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
        const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
        await HyperAGI_Storage.waitForDeployment()
        const _HyperAGI_BaseReward_Release = await ethers.getContractFactory('HyperAGI_BaseReward_Release')
        const HyperAGI_BaseReward_Release = await upgrades.deployProxy(_HyperAGI_BaseReward_Release, [process.env.ADMIN_Wallet_Address])
        await HyperAGI_BaseReward_Release.waitForDeployment()

        await (await HyperAGI_Storage.setServiceAddress(HyperAGI_BaseReward_Release.target)).wait()

        await (await HyperAGI_BaseReward_Release.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', HyperAGI_Storage.target])).wait()

        return HyperAGI_BaseReward_Release.target
      }

      async function test2() {
        const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
        const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
        await HyperAGI_Storage.waitForDeployment()
        const _HyperAGI_Security_Deposit = await ethers.getContractFactory('HyperAGI_Security_Deposit')
        const HyperAGI_Security_Deposit = await upgrades.deployProxy(_HyperAGI_Security_Deposit, [process.env.ADMIN_Wallet_Address])
        await HyperAGI_Security_Deposit.waitForDeployment()

        await (await HyperAGI_Storage.setServiceAddress(HyperAGI_Security_Deposit.target)).wait()

        await (await HyperAGI_Security_Deposit.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', HyperAGI_Storage.target, '0x829551330A37140764573d0B3236E9Db71b4B196', '0xFc64b7e8A0062693B4dE78D6d5014DcA677B4372'])).wait()

        const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x5745090BFB28C3399223215DfbBb4e729aeF8cFD')
        await (await HyperAGI_Roles_Cfg.addAdmin(HyperAGI_Security_Deposit.target)).wait()

        return HyperAGI_Security_Deposit.target
      }

      const HyperAGI_BaseReward_Release = await test1()
      const HyperAGI_Security_Deposit = await test2()

      const _HyperAGI_Ecpoch_Awards = await ethers.getContractFactory('HyperAGI_Ecpoch_Awards')
      const HyperAGI_Ecpoch_Awards = await upgrades.deployProxy(_HyperAGI_Ecpoch_Awards, [process.env.ADMIN_Wallet_Address])
      await HyperAGI_Ecpoch_Awards.waitForDeployment()

      await (await HyperAGI_Ecpoch_Awards.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', '0x829551330A37140764573d0B3236E9Db71b4B196', HyperAGI_Security_Deposit, HyperAGI_BaseReward_Release, '0xDAa6f0C96bbaaC78FfC37E7a4343E3D801446579'])).wait()

      const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x5745090BFB28C3399223215DfbBb4e729aeF8cFD')

      await (await HyperAGI_Roles_Cfg.addAdmin(HyperAGI_Ecpoch_Awards.target)).wait()

      const _HyperAGI_GPUMining = await ethers.getContractFactory('HyperAGI_GPUMining')

      const HyperAGI_GPUMining = await upgrades.upgradeProxy('0xDAa6f0C96bbaaC78FfC37E7a4343E3D801446579', _HyperAGI_GPUMining)

      await (await HyperAGI_GPUMining.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', HyperAGI_Ecpoch_Awards.target)).wait()

      await (
        await accounts[0].sendTransaction({
          to: HyperAGI_GPUMining.target,
          value: ethers.parseEther('200'),
        })
      ).wait()

      // 发送交易并等待其被挖掘
      const txResponse = await HyperAGI_Ecpoch_Awards.rewards(['0x1000000000000000000000000000000000000000000000000000000000000000'], 1)
      const txReceipt = await txResponse.wait()
      console.log('Transaction confirmed:', txReceipt)

      // 解析日志事件
      const logs = txReceipt.logs
      for (const log of logs) {
        try {
          const parsedLog = HyperAGI_Ecpoch_Awards.interface.parseLog(log)
          console.log('Parsed Log:', parsedLog)
        } catch (e) {
          console.log('Unable to parse log:', log)
        }
      }
    })
  })
})
