/** @format */

import { ethers, upgrades, network } from "hardhat";

describe("Hyperdust_VestingWallet", () => {
    describe("Hyperdust_VestingWallet", () => {
        it("Hyperdust_VestingWallet", async () => {

            const accounts = await ethers.getSigners();

            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token", ["TEST", "TEST", accounts[0].address]);
            await Hyperdust_Token.waitForDeployment()



            const _Hyperdust_VestingWallet = await ethers.getContractFactory("Hyperdust_VestingWallet");
            const Hyperdust_VestingWallet = await upgrades.deployProxy(_Hyperdust_VestingWallet, [accounts[0].address, 600, 1, 750, 12]);


            const PRIVATE_SALE = await Hyperdust_Token.PRIVATE_SALE();


            await (await Hyperdust_Token.setMinterAddeess(PRIVATE_SALE, Hyperdust_VestingWallet.target)).wait();

            await (await Hyperdust_Token.startTGETimestamp()).wait();


            await (await Hyperdust_VestingWallet.appendAccountTotalAllocation([accounts[0].address], [ethers.parseEther("6000000.00")])).wait()



            await (await Hyperdust_VestingWallet.setHyperdustTokenAddress(Hyperdust_Token.target)).wait()

            const totalAllocation = await Hyperdust_VestingWallet.totalAllocation();

            console.info("totalAllocation:", ethers.formatEther(totalAllocation));



            const released = await Hyperdust_VestingWallet.released();

            console.info("released:", ethers.formatEther(released));


            let releasable = await Hyperdust_VestingWallet.releasable();

            console.info("releasable:", ethers.formatEther(releasable));




            await network.provider.send("evm_increaseTime", [600 * 2]);
            await network.provider.send("evm_mine");

            releasable = await Hyperdust_VestingWallet.releasable();

            console.info("releasable:", ethers.formatEther(releasable));













        });
    });
});
