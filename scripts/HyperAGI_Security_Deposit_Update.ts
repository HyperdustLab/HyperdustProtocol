/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Security_Deposit = await ethers.getContractFactory('HyperAGI_Security_Deposit')

  await upgrades.upgradeProxy('0x19f8B191a1112629D729307FC29e4436C7E2EFF5', _HyperAGI_Security_Deposit)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
