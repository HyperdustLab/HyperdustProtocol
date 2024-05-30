/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Storage = await ethers.getContractFactory('HyperAGI_Storage')
  const HyperAGI_Storage = await upgrades.deployProxy(_HyperAGI_Storage, [process.env.ADMIN_Wallet_Address])
  await HyperAGI_Storage.waitForDeployment()

  const contract = await ethers.getContractFactory('HyperAGI_Node_Mgr')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  console.info('HyperAGI_Storage:', HyperAGI_Storage.target)

  await (await HyperAGI_Storage.setServiceAddress(instance.target)).wait()

  await (await instance.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', '0xdeFC8022e6151ac596ab4136D902c988a8560679', HyperAGI_Storage.target, '0x85C8362C20D9dC240400D232A69d340aF717b611'])).wait()

  const HyperAGI_Miner_NFT_Pledge = await ethers.getContractAt('HyperAGI_Miner_NFT_Pledge', '0x85C8362C20D9dC240400D232A69d340aF717b611')

  await (await HyperAGI_Miner_NFT_Pledge.setNodeMgrAddress(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
