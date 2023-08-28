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



            const myContract = await ethers.getContractAt("MGN_Miner_Node", "0xc62a201e64f3a6d201ad83b68c204dc83b63f2ec");

            const txResponse = await myContract.addMinerNode('0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f', '127.0.0.1', 1000, [4, 20000, 3000, 5000, 10000])

            console.info(txResponse)



        });

    });





});
