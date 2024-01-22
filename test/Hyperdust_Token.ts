/** @format */

import { ethers, network } from "hardhat";

describe("Hyperdust_Token", () => {
    describe("Hyperdust_Token", () => {
        it("Hyperdust_Token", async () => {


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


            console.info(ethers.formatEther(data[0].toString()), ethers.formatEther(data[1].toString()))







        });
    });
});
