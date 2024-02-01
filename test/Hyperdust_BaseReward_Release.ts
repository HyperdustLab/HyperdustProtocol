/** @format */

import { ethers, upgrades } from "hardhat";

const dayjs = require('dayjs')

describe("Hyperdust_BaseReward_Release", () => {
    describe("Hyperdust_BaseReward_Release", () => {
        it("Hyperdust_BaseReward_Release", async () => {


            const accounts = await ethers.getSigners();




            const _Hyperdust_Roles_Cfg = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
            const Hyperdust_Roles_Cfg = await upgrades.deployProxy(_Hyperdust_Roles_Cfg);

            const Hyperdust_20 = await ethers.deployContract("Hyperdust_20", ["Test", "Test"]);
            await Hyperdust_20.waitForDeployment()




            const _Hyperdust_BaseReward_Release = await ethers.getContractFactory("Hyperdust_BaseReward_Release");
            const Hyperdust_BaseReward_Release = await upgrades.deployProxy(_Hyperdust_BaseReward_Release, [accounts[0].address]);




            const Hyperdust_BaseReward_Release_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_BaseReward_Release_Data.waitForDeployment()


            await (await Hyperdust_BaseReward_Release_Data.setServiceAddress(Hyperdust_BaseReward_Release.target)).wait()



            await (
                await Hyperdust_BaseReward_Release.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_20.target, Hyperdust_BaseReward_Release_Data.target])
            ).wait()


            await (await Hyperdust_20.mint(Hyperdust_BaseReward_Release.target, ethers.parseEther("10000"))).wait()



            let tx = await (await Hyperdust_BaseReward_Release.addBaseRewardReleaseRecord(ethers.parseEther("100"), accounts[0].address)).wait()

            const a = Hyperdust_BaseReward_Release.interface.decodeEventLog("eveSave", tx.logs[0].data, tx.logs[0].topics)


            let time = a[2][0];



            const b = await Hyperdust_BaseReward_Release.findAmount(accounts[0].address, time)

            console.info(b)


            tx = await (await Hyperdust_BaseReward_Release.release([time])).wait()




            const c = Hyperdust_BaseReward_Release.interface.decodeEventLog("eveSave", tx.logs[tx.logs.length - 1].data, tx.logs[tx.logs.length - 1].topics)

            console.info(c)































        });
    });
});
