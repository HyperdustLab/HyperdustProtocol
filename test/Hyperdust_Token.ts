/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_Token", () => {
    describe("Hyperdust_Token", () => {
        it("Hyperdust_Token", async () => {


            const accounts = await ethers.getSigners();

            const contract = await ethers.deployContract("Hyperdust_Token", [accounts[0].address, accounts[1].address, accounts[2].address]);

            await contract.waitForDeployment()


            await (await contract.setPrivateSaleAddress(accounts[0])).wait()


            await (await contract.connect(accounts[1]).approveUpdateAddress("setPrivateSaleAddress")).wait()

            console.info()







        });
    });
});
