/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('HyperAGI_Transaction_Cfg')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (await instance.setContractAddress(['0x5745090BFB28C3399223215DfbBb4e729aeF8cFD', '0x829551330A37140764573d0B3236E9Db71b4B196'])).wait()
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
