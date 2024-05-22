/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Miner_NFT_Pledge = await ethers.getContractFactory('Hyperdust_Miner_NFT_Pledge')

  await upgrades.upgradeProxy('0x5f776729b1d2b49Ac79e6B6336D23cFDD5505ea2', _Hyperdust_Miner_NFT_Pledge)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
