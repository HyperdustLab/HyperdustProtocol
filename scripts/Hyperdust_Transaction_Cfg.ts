/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('Hyperdust_Transaction_Cfg')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0x213b5E4FF6B805dC5C9AF66B0e1f84A035Fa80D5', '0x7a798E8eC045f911684dAa28B38a54b883b9523C'])).wait()
  await (await instance.add('epoch', 38000)).wait()
  await (await instance.setMinGasFee('epoch', 100000000000)).wait()

  // const Hyperdust_Render_Transcition = await ethers.getContractAt("Hyperdust_Render_Transcition", "0x5546C5Da8fC0b52A319EB684A768A00ceE7D0862")

  // await (await Hyperdust_Render_Transcition.setTransactionCfg(contract.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
