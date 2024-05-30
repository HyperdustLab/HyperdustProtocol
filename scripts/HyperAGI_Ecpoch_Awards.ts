/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Ecpoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', '0x829551330A37140764573d0B3236E9Db71b4B196', '0x54C2E2f9f2233AD7d6C347739f178928673378F6', '0x502De4C5BDEC67A1ec907Ab5333dDd5094f5DBF9', '0xDAa6f0C96bbaaC78FfC37E7a4343E3D801446579'])).wait()

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
