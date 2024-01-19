/** @format */

import { ethers, network } from "hardhat";

describe("Hyperdust_Token", () => {
    describe("Hyperdust_Token", () => {
        it("Hyperdust_Token", async () => {


            const accounts = await ethers.getSigners();

            const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

            await contract.waitForDeployment()

            await (await contract.startTGETimestamp()).wait();


            await network.provider.send("evm_increaseTime", [600 * 2]);
            await network.provider.send("evm_mine");


            const data = await contract.getFoundationCurrAllowMintTotalNum()

            console.info(data)














        });
    });
});
