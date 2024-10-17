/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Agent_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0x7B33C8D43C52d0c575eACaEcFdAd68487bfB28Ea', '0xb90F1d2b0eF4aC49548cad06d44Bc1145793332C', '0x6759Aa64749b8fE3E294E7A73Ce6ee14eBF4270d', '0xF611A5E2934d3d32adECdb7e612c7aa52a83DC12', '0x141333a8797db93C217Fb12D9dDd01A255d0fF77'])).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0x250a7629d076581d3713f016727204341865920C')

  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  const HyperAGI_AgentWallet = await ethers.getContractAt('HyperAGI_AgentWallet', '0xF611A5E2934d3d32adECdb7e612c7aa52a83DC12')

  await (await HyperAGI_AgentWallet.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
