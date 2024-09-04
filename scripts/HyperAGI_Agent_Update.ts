/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Agent = await ethers.getContractFactory('HyperAGI_Agent')

  const HyperAGI_Agent = await upgrades.upgradeProxy('0x39F7f031394B6326F633fFEE7E8321Da67906805', _HyperAGI_Agent)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
