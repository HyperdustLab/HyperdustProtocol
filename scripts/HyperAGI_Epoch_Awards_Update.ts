/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Epoch_Awards = await ethers.getContractFactory('HyperAGI_Epoch_Awards')

  const HyperAGI_Epoch_Awards = await upgrades.upgradeProxy('0x47063364D91B0349221a17B4fFaBFF2Da4D16174', _HyperAGI_Epoch_Awards)

  await (await HyperAGI_Epoch_Awards.rewards(['0x0000000010100000000000000000000000000000000000000000000000000000'], 1, 0)).wait()
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
