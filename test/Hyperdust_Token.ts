/** @format */

import { ethers, network } from "hardhat";

describe("Hyperdust_Token", () => {
    describe("Hyperdust_Token", () => {
        it("Hyperdust_Token", async () => {


            // const accounts = await ethers.getSigners();

            // const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

            // await contract.waitForDeployment()

            // await (await contract.startTGETimestamp()).wait();


            // await network.provider.send("evm_increaseTime", [600 * 0]);
            // await network.provider.send("evm_mine");

            // await (await contract.setGPUMiningAddress(accounts[0].address)).wait();

            // await (await contract.GPUMiningMint(165601217656012)).wait();

            // const data = await contract.getGPUMiningCurrAllowMintTotalNum();

            // console.info(data)


            const Hyperdust_Token_Test = await ethers.getContractAt("Hyperdust_Token_Test", "0xcCf92aFaa29E2fc51AD1e0EB7B7fFF2E6a29fFB2")

            await (await Hyperdust_Token_Test.GPUMiningMint(165601217656011)).wait()



        });
    });
});
