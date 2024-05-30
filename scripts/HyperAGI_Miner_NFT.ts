/** @format */

import { ethers, run } from 'hardhat'

async function main() {
  const abiCoder = new ethers.AbiCoder()

  const contract = await ethers.deployContract('HyperAGI_721', ['HyperAGI Miner NFT', 'HMN', process.env.ADMIN_Wallet_Address])
  await contract.waitForDeployment()

  console.info('contractFactory address:', contract.target)

  const initializeData = abiCoder.encode(
    ['string', 'string', 'address'], // 初始化函数的参数类型
    ['HyperAGI Miner NFT', 'HMN', process.env.ADMIN_Wallet_Address] // 初始化函数的参数值
  )

  console.info('initializeData:', initializeData)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
