/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('Hyperdust_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (
    await instance.setContractAddress([
      '0x9bDaf3912e7b4794fE8aF2E748C35898265D5615',
      '0x9b7339B4FE58A2541d4e87FC6e6e35Dc9cBc77D5',
      '0xFCA4CCBaa666f8b57B85E8D547e4E017E89baF5c',
      '0x49BD454B8D8a277b71E0a18D36acC2F585481889',
      '0xD22fB1511B6B77Fa40c6BD64Cb7A4220366873a9',
      '0x4e09099bBf643b22fDfc9405189B05D90FCCDa3B',
    ])
  ).wait()

  const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x9bDaf3912e7b4794fE8aF2E748C35898265D5615')

  await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

  const Hyperdust_GPUMining = await ethers.getContractAt('Hyperdust_GPUMining', '0xD22fB1511B6B77Fa40c6BD64Cb7A4220366873a9')

  await (await Hyperdust_GPUMining.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
