/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
  const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
  await HyperAGI_Storage.waitForDeployment()

  console.info('HyperAGI_Storage:', HyperAGI_Storage.target)

  const contract = await ethers.getContractFactory('HyperAGI_Agent')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])

  await instance.waitForDeployment()

  await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0x7B33C8D43C52d0c575eACaEcFdAd68487bfB28Ea', HyperAGI_Storage.target, '0x709722ed57452a5B25860e4C8D1F7BB5275ac00B', '0x615f77318Ff5C101ff513e673c937C71ffDed5B3'])).wait()

  // await (await instance.setGroundRodLevels([1720753076763, 1720753124865, 1720753540303, 1720753582471, 1720753602937], [1, 2, 3, 4, 5])).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
