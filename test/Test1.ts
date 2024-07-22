/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const _HyperAGI_Storage = await ethers.getContractAt('HyperAGI_Storage', '0x2bB349f625eF74F5E704Cbf77F763c330a5e4cc9')

      await (await _HyperAGI_Storage.setServiceAddress('0xde265B8AD8F05856fFdca33ECFB504f1778594F5')).wait()
    })
  })
})
