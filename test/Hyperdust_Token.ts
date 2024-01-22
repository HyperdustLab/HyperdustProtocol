/** @format */

import { ethers, network } from "hardhat";

describe("Hyperdust_Token", () => {
    describe("Hyperdust_Token", () => {
        it("Hyperdust_Token", async () => {


<<<<<<< HEAD
            const accounts = await ethers.getSigners();

            const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

            await contract.waitForDeployment()

            await (await contract.startTGETimestamp()).wait();
            await (await contract.setAdvisorAddress(accounts[0].address)).wait();

            const a = await contract.getPrivateProperty()

            console.info(ethers.formatEther(a[10].toString()))
            console.info(ethers.formatEther(a[7].toString()))


            await network.provider.send("evm_increaseTime", [600 * 60]);
            await network.provider.send("evm_mine");


            const data = await contract.getCoreTeamCurrAllowMintTotalNum()
=======
            // const accounts = await ethers.getSigners();

            // const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

            // await contract.waitForDeployment()
>>>>>>> bb8f970190af49cf6cd46beec6d901bb116b3978

            // await (await contract.startTGETimestamp()).wait();

            console.info(ethers.formatEther(data[0].toString()), ethers.formatEther(data[1].toString()))

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
