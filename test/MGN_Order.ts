import {
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
const { describe, it } = require("mocha");


describe("MGN_Order", () => {

    describe("Add", () => {
        it("Test1", async function () {



            const myContract = await ethers.getContractAt("MGN_Order", "0x92e28f3475b8c0ae3653e989b2dfb5b1b53c6841");

            const txResponse = await myContract.settlementOrder(107);

            console.info(txResponse)



        });

    });





});
