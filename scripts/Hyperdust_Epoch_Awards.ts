/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('Hyperdust_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (
    await instance.setContractAddress([
      '0x9D88106Ba510D3852eC03B22b8F754F2bcd16739',
      '0xCe25B74F7C6C26c3A02B61e2eca6f9EBC10CcC17',
      '0x6F9cF45d4dB0Aa5Ffa28CD04bD51A1D99Af779B6',
      '0xb7EEA03dcc393f69fD277C0fFB0EE233f2488F47',
      '0x8A5b736C83FE79ed8f81c45347E42e1C1C595ee4',
      '0xaea9e80F367363c4255A055cA11080DaA5BB840B',
    ])
  ).wait()

  const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x9D88106Ba510D3852eC03B22b8F754F2bcd16739')

  await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

  const Hyperdust_GPUMining = await ethers.getContractAt('Hyperdust_GPUMining', '0x8A5b736C83FE79ed8f81c45347E42e1C1C595ee4')

  await (await Hyperdust_GPUMining.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
