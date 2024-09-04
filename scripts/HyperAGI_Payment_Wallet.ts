/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Payment_Wallet')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  const HyperAGI_Ecpoch_Transaction = await ethers.getContractAt('HyperAGI_Ecpoch_Transaction', '0x60aBeB8c20258FA987DFBB340c19F25a403540b2')

  await (await HyperAGI_Ecpoch_Transaction.setPaymentWalletAddress(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
