/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();



            const contract = await ethers.deployContract("Test1");

            await contract.waitForDeployment()

            const a = await contract.test();

            console.info(ethers.formatEther(a))











        });
    });
});
