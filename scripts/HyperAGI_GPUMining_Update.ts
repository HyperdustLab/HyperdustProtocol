/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_GPUMining = await ethers.getContractFactory('HyperAGI_GPUMining')

  await upgrades.upgradeProxy('0xDAa6f0C96bbaaC78FfC37E7a4343E3D801446579', _HyperAGI_GPUMining)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
