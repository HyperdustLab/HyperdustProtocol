/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('Hyperdust_Transaction_Cfg')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0x9D88106Ba510D3852eC03B22b8F754F2bcd16739', '0xCe25B74F7C6C26c3A02B61e2eca6f9EBC10CcC17'])).wait()
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
