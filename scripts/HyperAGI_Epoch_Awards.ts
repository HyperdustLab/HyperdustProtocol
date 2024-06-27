/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (
    await instance.setContractAddress([
      '0x5745090BFB28C3399223215DfbBb4e729aeF8cFD',
      '0xb5965619C95373587444DaAd217157624545C58b',
      '0xDf3DDF0762F16cAe14aC1db4fFA78D61fADb72d0',
      '0x5543D65CE4d38d462f8f8dc073FcBa36A4729D2C',
      '0xDAa6f0C96bbaaC78FfC37E7a4343E3D801446579',
      '0xb2342E1Bf4B4e0d340B97F5CdD8Fd9Cf24525D26',
    ])
  ).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x5745090BFB28C3399223215DfbBb4e729aeF8cFD')

  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  const HyperAGI_GPUMining = await ethers.getContractAt('HyperAGI_GPUMining', '0xDAa6f0C96bbaaC78FfC37E7a4343E3D801446579')

  await (await HyperAGI_GPUMining.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
