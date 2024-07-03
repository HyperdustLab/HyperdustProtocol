/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const accounts = await ethers.getSigners()

  const onlyOwner = accounts[0].address

  const contract = await ethers.deployContract('Tagtal_Token', ['Tagtal Token', 'Tagtal', onlyOwner])
  await contract.waitForDeployment()

  await (await contract.startTGETimestamp()).wait()

  const GPU_MINING = await contract.GPU_MINING()

  await (await contract.setMinterAddress(GPU_MINING, onlyOwner)).wait()

  await (await contract.mint(ethers.parseEther('1000'))).wait()
  console.info('contractFactory address:', contract.target)

  const balanceOf = await contract.balanceOf(onlyOwner)

  await (await contract.transfer('0x2aA743E8E4f60dECe1e8c55202048Ef7F36Bbd71', ethers.parseEther('1000'))).wait()

  console.info('balanceOf:', ethers.formatEther(balanceOf.toString()))
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
