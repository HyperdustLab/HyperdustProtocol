/** @format */

import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Order", () => {
  describe("Add", () => {
    it("Test1", async function () {
      const MGN_Render_Transcition = await ethers.getContractAt("MGN_Render_Transcition", "0x4da6cA983Dd36c239177e419979FB502AE9e1c28");

      const tx = await (await MGN_Render_Transcition.settlementOrder(1)).wait();

      console.info(tx);
    });
  });
});
