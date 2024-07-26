/** @format */

import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const contract = await ethers.deployContract('Test1')
      await contract.waitForDeployment()

      const a = await contract.countActiveAgent(['0x1011101010101110110000000000000000000000000000000000000000000000'])

      console.info(a)
    })
  })
})
