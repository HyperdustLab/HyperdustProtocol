/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const abiCoder = new ethers.AbiCoder()

  const contract = await ethers.deployContract('HyperAGI_1155', ['HyperAGI 1155', 'HyperAGI Token', process.env.ADMIN_Wallet_Address])
  await contract.waitForDeployment()

  const MINTER_ROLE = await contract.MINTER_ROLE()

  await (await contract.grantRole(MINTER_ROLE, '0x01453C1Df8C4f9558B8a23aA27a818A606F609B5')).wait()

  console.info('contractFactory address:', contract.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
