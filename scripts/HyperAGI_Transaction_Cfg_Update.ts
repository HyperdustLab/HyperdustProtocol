/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Transaction_Cfg')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0xF13842B9E794A0970DCbCa245B963d3d0d804317', '0xad20ce3a9dce85708074BD7a0E6F4b355151e040'])).wait()
  await (await instance.add('epoch', 38000)).wait()
  await (await instance.setMinGasFee('epoch', 100000000000)).wait()

  const _HyperAGI_Transaction_Cfg = await ethers.getContractFactory('HyperAGI_Transaction_Cfg')

  await upgrades.upgradeProxy(instance.target, _HyperAGI_Transaction_Cfg)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
