/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();
            const Hyperdust_Token_Test = await ethers.getContractAt('Hyperdust_Token_Test', '0x5FbDB2315678afecb367f032d93F642f64180aa3')

            await (await Hyperdust_Token_Test.setCoreTeamAddress(accounts[0].address)).wait()

            const time1 = await Hyperdust_Token_Test._CoreTeamAllowReleaseTime();

            console.info(time1);

            await (await Hyperdust_Token_Test.mint(ethers.parseEther("1.15"))).wait()

            const time2 = await Hyperdust_Token_Test._CoreTeamAllowReleaseTime();

            console.info(time2);










        });
    });
});
