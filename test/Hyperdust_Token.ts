/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_Token", () => {
    describe("Hyperdust_Token", () => {
        it("Hyperdust_Token", async () => {


            const accounts = await ethers.getSigners();

            const contract = await ethers.deployContract("Hyperdust_Token", [accounts[0].address, accounts[1].address, accounts[2].address]);

            await contract.waitForDeployment()

            const _totalSupply = await contract._totalSupply();
            const timestamp = await contract.timestamp();
            const _MultiSignatureWallet_1 = await contract._multiSignatureWallet(0);
            const _MultiSignatureWallet_2 = await contract._multiSignatureWallet(1);
            const _MultiSignatureWallet_3 = await contract._multiSignatureWallet(2);
            const _GPUMiningTotalAward = await contract._GPUMiningTotalAward();
            const _GPUMiningTotalMiningRatio = await contract._GPUMiningTotalMiningRatio();
            const _GPUMiningCurrYearTotalSupply = await contract._GPUMiningCurrYearTotalSupply();
            const _GPUMiningReleaseInterval = await contract._GPUMiningReleaseInterval();
            const _MiningReserveTotalAward = await contract._MiningReserveTotalAward();
            const _epochAward = await contract._epochAward();


            console.info("_totalSupply:" + ethers.formatEther(_totalSupply))
            console.info("timestamp:" + timestamp)
            console.info("_MultiSignatureWallet_1:" + _MultiSignatureWallet_1)
            console.info("_MultiSignatureWallet_2:" + _MultiSignatureWallet_2)
            console.info("_MultiSignatureWallet_3:" + _MultiSignatureWallet_3)
            console.info("_GPUMiningTotalAward:" + ethers.formatEther(_GPUMiningTotalAward))
            console.info("_GPUMiningTotalMiningRatio:" + _GPUMiningTotalMiningRatio)
            console.info("_GPUMiningCurrYearTotalSupply:" + ethers.formatEther(_GPUMiningCurrYearTotalSupply))
            console.info("_GPUMiningReleaseInterval:" + _GPUMiningReleaseInterval)
            console.info("_MiningReserveTotalAward:" + ethers.formatEther(_MiningReserveTotalAward))
            console.info("_epochAward:" + ethers.formatEther(_epochAward))







        });
    });
});
