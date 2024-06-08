/** @format */

import { ethers, run } from 'hardhat'

import { Database } from '../Database'

async function main() {
  const db = new Database(process.env.db_host, process.env.db_user, process.env.db_name, process.env.db_password)
  await db.connect()
  const rows = await db.query('SELECT * FROM mgn_platform_nft', [])

  const HyperAGI_mNFT_Mint = await ethers.getContractAt('HyperAGI_mNFT_Mint', '0x7028141A2BCc684f2204cE7DE4f5C0806b86F987')

  for (const item of rows) {
    console.info(item)
    await (await HyperAGI_mNFT_Mint.addMintInfo(item.token_uri, ethers.parseEther('0.01'), '0x7A3709f067FFc984cd0D16934a9d88f0D255D326', item.token_id, '0x22', 1000, 0)).wait()
  }

  await db.close()
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
