/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Storage = await ethers.getContractFactory('Hyperdust_Storage')
  const Hyperdust_Storage = await upgrades.deployProxy(_Hyperdust_Storage, [process.env.ADMIN_Wallet_Address])
  await Hyperdust_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('Hyperdust_Security_Deposit')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0x9bDaf3912e7b4794fE8aF2E748C35898265D5615', '0x01778569225bA43FFDABF872607e1df2Bc83f102', Hyperdust_Storage.target, '0x4c598712E891E9671EbDAFcA7c26f6b8F2379878', '0x5f776729b1d2b49Ac79e6B6336D23cFDD5505ea2'])).wait()

  console.info('Hyperdust_Storage:', Hyperdust_Storage.target)

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
