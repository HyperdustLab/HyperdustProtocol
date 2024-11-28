/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const abiCoder = new ethers.AbiCoder()

  const contract = await ethers.deployContract('HyperAGI_1155', ['HyperAGI_KEY_Token', 'KEY Token', process.env.ADMIN_Wallet_Address])
  await contract.waitForDeployment()

  const MINTER_ROLE = await contract.MINTER_ROLE()

  await (await contract.grantRole(MINTER_ROLE, '0x3A20dF9Daa3fcfD131C7348E1366965b304D1a43')).wait()

  await run('verify:verify', {
    address: contract.target,
    constructorArguments: ['HyperAGI_KEY_Token', 'KEY Token', process.env.ADMIN_Wallet_Address],
  })

  console.info('contractFactory address:', contract.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
