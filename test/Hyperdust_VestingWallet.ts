/** @format */

import { ethers, upgrades, network } from "hardhat";

describe("Hyperdust_VestingWallet", () => {
    describe("Hyperdust_VestingWallet", () => {
        it("Hyperdust_VestingWallet", async () => {

            const accounts = await ethers.getSigners();

            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token", ["TEST", "TEST", accounts[0].address]);
            await Hyperdust_Token.waitForDeployment()



            const _Hyperdust_VestingWallet = await ethers.getContractFactory("Hyperdust_VestingWallet");
            const Hyperdust_VestingWallet = await upgrades.deployProxy(_Hyperdust_VestingWallet, [accounts[0].address, 600, 3, 0, 48,
            ethers.keccak256(ethers.toUtf8Bytes("CORE_TEAM"))
            ]);


            const PRIVATE_SALE = await Hyperdust_Token.PRIVATE_SALE();






            await (await Hyperdust_Token.setMinterAddeess(PRIVATE_SALE, Hyperdust_VestingWallet.target)).wait();




            await (await Hyperdust_Token.startTGETimestamp()).wait();


            const TGE_timestamp = await Hyperdust_Token.TGE_timestamp()

            console.info("TGE_timestamp:", TGE_timestamp.toString())


            await (await Hyperdust_VestingWallet.setHyperdustTokenAddress(Hyperdust_Token.target)).wait()


            await (await Hyperdust_VestingWallet.appendAccountTotalAllocation([accounts[0].address], [ethers.parseEther("23000000.00")])).wait()

            const totalAllocation = await Hyperdust_VestingWallet.totalAllocation(accounts[0].address);

            console.info("totalAllocation:", ethers.formatEther(totalAllocation));



            const released = await Hyperdust_VestingWallet.released(accounts[0].address);

            console.info("released:", ethers.formatEther(released));




            await network.provider.send("evm_increaseTime", [600 * 3]);
            await network.provider.send("evm_mine");

            let releasable = await Hyperdust_VestingWallet.releasable(accounts[0].address);

            console.info("releasable:", ethers.formatEther(releasable));













        });
    });
});
