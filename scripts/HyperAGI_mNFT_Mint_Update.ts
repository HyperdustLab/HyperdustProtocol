/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_mNFT_Mint = await ethers.getContractFactory('HyperAGI_mNFT_Mint')

  await upgrades.upgradeProxy('0x3aB9F8653de37265dAB8776467d590543729f017', _HyperAGI_mNFT_Mint)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
