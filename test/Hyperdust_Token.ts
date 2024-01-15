/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_Token", () => {
    describe("Hyperdust_Token", () => {
        it("Hyperdust_Token", async () => {


            const accounts = await ethers.getSigners();

            // const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

            // await contract.waitForDeployment()


            const contract = await ethers.getContractAt('Hyperdust_Token_Test', '0x5FbDB2315678afecb367f032d93F642f64180aa3')


            await (await contract.setCoreTeamAddress(accounts[0].address)).wait()

            let _CoreTeamAllowReleaseTime = await contract._CoreTeamAllowReleaseTime

            console.info(_CoreTeamAllowReleaseTime)

            await (await contract.mint(ethers.parseEther("1.15"))).wait()

            _CoreTeamAllowReleaseTime = await contract._CoreTeamAllowReleaseTime;

            console.info(_CoreTeamAllowReleaseTime)








        });
    });
});
