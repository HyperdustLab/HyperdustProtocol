/** @format */

import { ethers } from "hardhat";

import { promisify } from "util";

const request = require("request");

const ExcelJS = require("exceljs");

const fs = require("fs").promises;

const requestPromise = promisify(request);

describe("Hyperdust_HYDT_Price", () => {
  describe("sendRequest", () => {
    it("sendRequest", async () => {
      const Hyperdust_Space = await ethers.getContractAt("Hyperdust_Space", "0x0779f2687f0eb4EA70acA2A065eAdE9aFb0F24bF");

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
