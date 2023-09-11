/** @format */

import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Order", () => {
  describe("Add", () => {
    it("Test1", async function () {
      const MGN_Space = await ethers.getContractAt("MGN_Space", "0xAAE79f7739C9AFBb72A197B89463EC7360c5498c");

      const data = await MGN_Space.getSpace(1);

      console.info(data);
    });
  });
});
