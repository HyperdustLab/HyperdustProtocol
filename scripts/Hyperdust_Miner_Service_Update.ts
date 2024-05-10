/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _Hyperdust_Miner_Service = await ethers.getContractFactory('Hyperdust_Miner_Service')

  await upgrades.upgradeProxy('0x579925eC652e4386d8c0B1D935C2bC3e2c548c97', _Hyperdust_Miner_Service)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
