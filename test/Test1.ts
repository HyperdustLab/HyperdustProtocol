/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();

            const Test1 = await ethers.deployContract("Test1");

            await Test1.waitForDeployment()

            const a = await Test1.test()

            console.info(ethers.formatEther(a))









        });
    });
});
