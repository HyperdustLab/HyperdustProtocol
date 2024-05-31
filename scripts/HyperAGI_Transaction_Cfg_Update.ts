/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Transaction_Cfg = await ethers.getContractFactory('HyperAGI_Transaction_Cfg')

  await upgrades.upgradeProxy('0x859133fA725Cd252FD633E0Bc9ef7BbA270d6BE7', _HyperAGI_Transaction_Cfg)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
