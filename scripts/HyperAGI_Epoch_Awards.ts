/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (
    await instance.setContractAddress([
      '0x250a7629d076581d3713f016727204341865920C',
      '0xB3da86845e2B02fEB0744B32aC1E60E48CC9f7b3',
      '0x961A59f044944d887B538f03F43CBb52ebd46504',
      '0x7cAC636AE16eC74679E6c56fE6436c0D1fd27bdE',
      '0x60B33AD3A9912cf7281D1Ef345C9E3c690858c7e',
      '0x141333a8797db93C217Fb12D9dDd01A255d0fF77',
    ])
  ).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x250a7629d076581d3713f016727204341865920C')

  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  const HyperAGI_GPUMining = await ethers.getContractAt('HyperAGI_GPUMining', '0x60B33AD3A9912cf7281D1Ef345C9E3c690858c7e')

  await (await HyperAGI_GPUMining.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
