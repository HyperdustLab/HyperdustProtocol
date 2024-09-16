/** @format */

import { ethers, run } from 'hardhat'

import { Database } from '../Database'

async function main() {
  const db = new Database(process.env.db_host, process.env.db_user, process.env.db_name, process.env.db_password)
  await db.connect()
  const rows = await db.query('SELECT * FROM mgn_platform_nft where id = ?', ['1808746034137296897'])

  console.info(rows)

  const HyperAGI_mNFT_Mint = await ethers.getContractAt('HyperAGI_mNFT_Mint', '0x74B21a8f8f8bBf0c0109f7A22e2dEf2dA9cd501f')

  for (const item of rows) {
    const contract_address = item.contract_address
    const contract_type = item.contract_type

    let _contract_address
    let _contract_type

    if (contract_address === '0xa6fbe0e781cc85435e5a491afcb877c6b600caa0') {
      _contract_address = '0x75E575bCa06352C86e619d8a7909f7b67e9F2f08'
      _contract_type = '0x22'
    } else {
      _contract_address = '0xcd50B0A5696A6fA275CAa2C0F4c375A07Ac77C1b'
      _contract_type = '0x11'
    }

    await (await HyperAGI_mNFT_Mint.addMintInfo(item.token_uri, ethers.parseEther('0.01'), _contract_address, item.token_id, _contract_type, 1000, 0)).wait()
  }

  await db.close()
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
