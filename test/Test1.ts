/** @format */

import { Interface, InterfaceAbi } from 'ethers'
import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {


// 编码 setValidator 方法调用数据
      const setValidatorInterface = new ethers.Interface([
        'function setBaseStake(uint256)',
      ])

      const data = setValidatorInterface.encodeFunctionData('setBaseStake', [ethers.parseEther('0.0000001')])

      console.info(data)


    })
  })
})
