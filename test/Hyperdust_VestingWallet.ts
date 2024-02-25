/** @format */

import { ethers, upgrades, network } from "hardhat";

describe("Hyperdust_VestingWallet", () => {
    describe("Hyperdust_VestingWallet", () => {
        it("Hyperdust_VestingWallet", async () => {

            const accounts = await ethers.getSigners();

            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token", ["TEST", "TEST", accounts[0].address]);
            await Hyperdust_Token.waitForDeployment()



            const _Hyperdust_VestingWallet = await ethers.getContractFactory("Hyperdust_VestingWallet");
            const Hyperdust_VestingWallet = await upgrades.deployProxy(_Hyperdust_VestingWallet, [accounts[0].address, 600, 0, 500, 19,
            ethers.keccak256(ethers.toUtf8Bytes("SEED"))
            ]);


            const SEED = await Hyperdust_Token.SEED();

            await (await Hyperdust_Token.setMinterAddeess(SEED, Hyperdust_VestingWallet.target)).wait();




            await (await Hyperdust_Token.startTGETimestamp()).wait();


            const TGE_timestamp = await Hyperdust_Token.TGE_timestamp()

            console.info("TGE_timestamp:", TGE_timestamp.toString())


            await (await Hyperdust_VestingWallet.setHyperdustTokenAddress(Hyperdust_Token.target)).wait()


            await (await Hyperdust_VestingWallet.appendAccountTotalAllocation([accounts[0].address], [ethers.parseEther("2500000.00")])).wait()

            const totalAllocation = await Hyperdust_VestingWallet.totalAllocation(accounts[0].address);

            console.info("totalAllocation:", ethers.formatEther(totalAllocation));



            const released = await Hyperdust_VestingWallet.released(accounts[0].address);

            console.info("released:", ethers.formatEther(released));


            let releasable = await Hyperdust_VestingWallet.releasable(accounts[0].address);

            console.info("releasable:", ethers.formatEther(releasable));




            await network.provider.send("evm_increaseTime", [600 * 1]);
            await network.provider.send("evm_mine");

            releasable = await Hyperdust_VestingWallet.releasable(accounts[0].address);

            console.info("releasable:", ethers.formatEther(releasable));


            const releasableTime = await Hyperdust_VestingWallet.releasableTime(accounts[0].address);


            console.info("releasableTime:", new Date(parseInt(releasableTime) * 1000).toLocaleString());












        });
    });
});
