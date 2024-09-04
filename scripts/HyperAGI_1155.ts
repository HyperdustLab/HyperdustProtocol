/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const abiCoder = new ethers.AbiCoder()

  const contract = await ethers.deployContract('HyperAGI_1155', ['HyperAGI 1155', 'HyperAGI Token', process.env.ADMIN_Wallet_Address])
  await contract.waitForDeployment()

  const MINTER_ROLE = await contract.MINTER_ROLE()

  await (await contract.grantRole(MINTER_ROLE, '0x4C7f6fF2Ba231086B75028042a9f7E7FD812Ea87')).wait()
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
