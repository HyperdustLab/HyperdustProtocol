/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('Agent_Mint')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])

  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0xbe48fa757EE99a0Be153436f2D14fe1CF7cCe05c', '0xb2342E1Bf4B4e0d340B97F5CdD8Fd9Cf24525D26', '0x859133fA725Cd252FD633E0Bc9ef7BbA270d6BE7', '0x4cF4b11E1884483EaC6937f2fBC7D41411776F47', '0x5745090BFB28C3399223215DfbBb4e729aeF8cFD'])).wait()

  const HyperAGI_Agent = await ethers.getContractAt('HyperAGI_Agent', '0xbe48fa757EE99a0Be153436f2D14fe1CF7cCe05c')

  await (await HyperAGI_Agent.setAgentMintAddress(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
