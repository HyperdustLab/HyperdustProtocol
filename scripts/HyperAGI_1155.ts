/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const abiCoder = new ethers.AbiCoder()

  const contract = await ethers.deployContract('HyperAGI_1155', ['HyperAGI 1155', 'HyperAGI Token', process.env.ADMIN_Wallet_Address])
  await contract.waitForDeployment()

  console.info('contractFactory address:', contract.target)

  const initializeData = abiCoder.encode(
    ['string', 'string', 'address'], // 初始化函数的参数类型
    ['HyperAGI 1155', 'HyperAGI Token', process.env.ADMIN_Wallet_Address] // 初始化函数的参数值
  )

  const MINTER_ROLE = await contract.MINTER_ROLE()

  await (await contract.grantRole(MINTER_ROLE, '0x7028141A2BCc684f2204cE7DE4f5C0806b86F987')).wait()

  console.info('initializeData:', initializeData)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
