/** @format */

import { Interface, InterfaceAbi } from 'ethers'
import { ethers, upgrades } from 'hardhat'

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {


// 编码 setValidator 方法调用数据
      const setValidatorInterface = new ethers.Interface([
        'function setValidKeyset(bytes)',
      ])

      const data = setValidatorInterface.encodeFunctionData('setValidKeyset', ['0x0000000000000002000000000000000201216002f0bb7a251b8e8f73ad3429eaae3809ee630e5c40cbc78a9144c43a89c2e83847379586132b3e73f44648804ad5c264193f5fb63a6acdbbc955454f99ff41950205896dab6e3586c36f64187ad537ee9f2419afdf0bb3b03920ea75d79e2eb913bc9d08b8e5a914bbdfd2f36d2788eb540ea672f6c41e1ea9de47c73b860a27e04c82db9769ad92799a5b9a697683370b58a0690fd1cb98c4b1aa26f5ccaec3adaad356528cfc54754f87a604dc9b5c3d2aa1de1f3322bbb3fbb1a3265706980fa32a193bdbd06dd5cb8099bf06625052c3c8da285bab1e960f09fbaea20977ca65a8331f20bec94576c821609d4a6700b20e2fae2413a9b9eb3ae25e2db7ca1c99cd5ec6b83e2fec02ff6ec8c32866d71f9ac4a4339579ca854fad92d3bd750121601030943b861afa5b3056b06b1800975ba5b764c23e76c10af2a96d526c6933120cd04b816a263923409624dfdbbeab6809cf2f128ca5605beeea0076e53bf7b1e14a64bfa571001068a086b425ff6cbe132d8d90d0072a41bcbb4124c1a6641d09b8a18a45772534b74191791396c914adfbc204b26294e908a09e01736cbc8bb7e65b1e6c458638532e38415ccb5acd1836e929a2600c16b76e63d8f6bb285c2bfef56af87fba8855c7f1b49b849abe0131dab418360fb12c1ca816f1c88b8304bb548bd6896ccb4a03d975b71494df936a4b17b4a53997c5cecd43684d0dea6df5ff1acdad1b64b5ec63e37964177b07cb161a59c5cee62311967bda4d234d1a53da2ee2f562cba23c0939d7e311e8804cc64fd624c0647bc2be9747bf084d'])

      console.info(data)


    })
  })
})
