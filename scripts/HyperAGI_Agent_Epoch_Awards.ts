/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Agent_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0xF13842B9E794A0970DCbCa245B963d3d0d804317', '0x01D8B9D4C932E3A3b29FAe1135cBBcB31EeA8CEE', '0x9D665ee3229Ad9ebBD1022E13Ae460E3c8dD1f24', '0x25D1E7b668012D69430eBC5c9268e811c1128D22', '0x7a798E8eC045f911684dAa28B38a54b883b9523C'])).wait()

  const HyperAGI_Roles_Cfg = await ethers.getContractAt('HyperAGI_Roles_Cfg', '0xF13842B9E794A0970DCbCa245B963d3d0d804317')

  await (await HyperAGI_Roles_Cfg.addAdmin(instance.target)).wait()

  const HyperAGI_AgentWallet = await ethers.getContractAt('HyperAGI_AgentWallet', '0x25D1E7b668012D69430eBC5c9268e811c1128D22')

  await (await HyperAGI_AgentWallet.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
