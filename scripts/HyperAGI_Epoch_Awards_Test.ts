/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const _HyperAGI_Epoch_Awards = await ethers.getContractFactory('HyperAGI_Epoch_Awards_Test')

  const HyperAGI_Epoch_Awards = await upgrades.upgradeProxy('0xDa10eb41fDa8b6398BDB783e1875892C90AE0A02', _HyperAGI_Epoch_Awards)

  await (await HyperAGI_Epoch_Awards.rewards(['0x1100000000000010101100000000000000000000000000000000000000000000'], 1, 0)).wait()


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
