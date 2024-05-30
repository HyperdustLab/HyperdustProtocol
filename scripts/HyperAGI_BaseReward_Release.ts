/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
  const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
  await HyperAGI_Storage.waitForDeployment()
  const contract = await ethers.getContractFactory('HyperAGI_BaseReward_Release')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', HyperAGI_Storage.target])).wait()

  console.info('HyperAGI_Storage:', HyperAGI_Storage.target)

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
