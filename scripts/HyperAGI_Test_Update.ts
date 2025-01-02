/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Test = await ethers.getContractFactory('HyperAGI_Test')

  const HyperAGI_Test = await upgrades.upgradeProxy('0x26361186F6Cc5c1a0870900F6Fc0CF9ca851A23a', _HyperAGI_Test)

  await (await HyperAGI_Test.migrateETH('0x3bDAB9a6B9246281F74154408f88dea82BDf3C8A', '0xaaC73e223DEc87218d849992b73B52be81910cAc')).wait()

  // 验证实现合约
  const implementationAddress = await upgrades.erc1967.getImplementationAddress('0x26361186F6Cc5c1a0870900F6Fc0CF9ca851A23a')

  await run('verify:verify', {
    address: implementationAddress,
    constructorArguments: [],
  })
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
