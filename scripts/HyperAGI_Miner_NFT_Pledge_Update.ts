/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Miner_NFT_Pledge = await ethers.getContractFactory('HyperAGI_Miner_NFT_Pledge')
  await upgrades.upgradeProxy('0x0BF77A9eE920cf4D0513C89E2e4a22d41526a74e', _HyperAGI_Miner_NFT_Pledge)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
