/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
  const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
  await HyperAGI_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('HyperAGI_Security_Deposit')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', HyperAGI_Storage.target, '0x829551330A37140764573d0B3236E9Db71b4B196', '0xFc64b7e8A0062693B4dE78D6d5014DcA677B4372'])).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x5745090BFB28C3399223215DfbBb4e729aeF8cFD')
  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  console.info('HyperAGI_Storage:', HyperAGI_Storage.target)

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
