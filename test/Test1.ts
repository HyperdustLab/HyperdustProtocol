/** @format */

import { ethers } from 'hardhat'

import { promisify } from 'util'

const request = require('request')

const ExcelJS = require('exceljs')

const fs = require('fs').promises

const requestPromise = promisify(request)

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners()
      const Hyperdust_Storage = await ethers.getContractAt('Hyperdust_Storage', '0x086930d99E5f58323EBc36c60a16a5947579D939')

      await (
        await Hyperdust_Space.edit(
          "0x725e378ad5f187e793c9deda7f03d2cd29a27c6d438e7b1a61cf3762a5550f00",
          "Advanced Puzzle Constructor",
          "https://s3.hyperdust.io/upload/2023/12/15/64fb59d2-f34c-4cf9-aeca-e08ef3750b3c.gif",
          "https://s3.hyperdust.io/upload/2023/12/15/64fb59d2-f34c-4cf9-aeca-e08ef3750b3c.gif",
          ""
        )
      ).wait();
    });
  });
});
      await (await Hyperdust_Storage.setServiceAddress(accounts[0].address)).wait()

      await (await Hyperdust_Storage.setAddress('incomeAddress_1', '0x5C140EC7e0dd00Bd13Cb614BF6E31B8bA8395118')).wait()

      await (await Hyperdust_Storage.setServiceAddress('0xeCBD8E9349B1d96b86b834f5F404cc3B9a03DA6c')).wait()

      const Hyperdust_Node_Mgr = await ethers.getContractAt('Hyperdust_Node_Mgr', '0xeCBD8E9349B1d96b86b834f5F404cc3B9a03DA6c')

      const res = await Hyperdust_Node_Mgr.getNodeV2(1)

      const _serviceAddress = await Hyperdust_Storage._serviceAddress()

      console.info(_serviceAddress)
    })
  })
})
