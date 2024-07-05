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

  await (await instance.setContractAddress(['0xF13842B9E794A0970DCbCa245B963d3d0d804317', '0xd6EF21906DC28DA65174E4664D11Ee9Be21C698e', '0xA8a113Ba8ac32882E7136a331de7814DAb6904cd', HyperAGI_Storage.target, ethers.ZeroAddress, '0x4cF4b11E1884483EaC6937f2fBC7D41411776F47'])).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
