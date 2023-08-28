/** @format */

import { time, loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Space_Template", () => {
  describe("Add", () => {
    it("Test1", async function () {
      // const myContract = await ethers.getContractAt("MGN_Space_Template", "0xb189dae27e8bc202ee268184309901294b6885a6");

      // const MGN_Role = await ethers.getContractFactory("MGN_Role");

      // const MGN_Role_1 = await MGN_Role.deploy();
      // await MGN_Role_1.deployed();

      //  const contractFactory = await ethers.getContractFactory("MGN_Space_Template");

      const myContract = await ethers.getContractAt("MGN_Space_Template", "0xb189dae27e8bc202ee268184309901294b6885a6");

      const txResponse = await myContract.add(
        "模板1",
        "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/7/fc788579-6fda-4d7f-b9d7-a48673f376c0.jpg",
        "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/7/e85b922e-7bb4-4d0f-a164-5d28c902dd58.jpg",
        4,
        { gasLimit: 1000000 }
      );

      console.info(txResponse);

      // const factory = await contractFactory.deploy();
      // await factory.deployed();

      // await factory.setRoleAddress(MGN_Role_1.address);

      // const txResponse = await factory.add('模板1', 'https:/ / vniverse.s3.ap - east - 1.amazonaws.com / upload / 2023 / 7 / 7 / fc788579 - 6fda - 4d7f - b9d7 - a48673f376c0.jpg', 'https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/7/e85b922e-7bb4-4d0f-a164-5d28c902dd58.jpg', 1)

      // console.info(txResponse)

      //const contract = new ethers.Contract("0xb189dae27e8bc202ee268184309901294b6885a6", MGN_Space_Template.abi, ethers.provider);
      // console.info("2")

      // const result = await contract.add('模板1', 'https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/7/fc788579-6fda-4d7f-b9d7-a48673f376c0.jpg', 'https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/7/e85b922e-7bb4-4d0f-a164-5d28c902dd58.jpg', 4)

      // console.info(result);
    });
  });
});
