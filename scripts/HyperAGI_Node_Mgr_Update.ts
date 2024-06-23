/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Node_Mgr = await ethers.getContractFactory('HyperAGI_Node_Mgr')

  const HyperAGI_Node_Mgr = await upgrades.upgradeProxy('0x829551330A37140764573d0B3236E9Db71b4B196', _HyperAGI_Node_Mgr)

  await (await HyperAGI_Node_Mgr.setMinerNFTPledgeAddress('0x0BF77A9eE920cf4D0513C89E2e4a22d41526a74e')).wait()
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
