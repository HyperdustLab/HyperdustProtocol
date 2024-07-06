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

  await (await instance.setContractAddress(['0xF13842B9E794A0970DCbCa245B963d3d0d804317', HyperAGI_Storage.target, '0xA8a113Ba8ac32882E7136a331de7814DAb6904cd', '0xA6Fbe0E781cc85435E5A491Afcb877c6b600cAa0'])).wait()

  await (await instance.setGroundRodLevels([1719480824880, 1719480929360, 1719481016964, 1719481093122, 1719481201509], [1, 2, 3, 4, 5])).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
