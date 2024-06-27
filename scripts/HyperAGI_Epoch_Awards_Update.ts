/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Ecpoch_Awards = await ethers.getContractFactory('HyperAGI_Ecpoch_Awards')

  await upgrades.upgradeProxy('0x7d95f40C84eE93D77aD6bF7f1Ba1dE807C46cE43', _HyperAGI_Ecpoch_Awards)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
