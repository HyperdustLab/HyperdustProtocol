/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_BaseReward_Release", () => {
    describe("Hyperdust_BaseReward_Release", () => {
        it("Hyperdust_BaseReward_Release", async () => {


            const accounts = await ethers.getSigners();

            const Hyperdust_Roles_Cfg = await ethers.deployContract("Hyperdust_Roles_Cfg");
            await Hyperdust_Roles_Cfg.waitForDeployment()

            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token", [accounts[0].address, accounts[1].address, accounts[2].address]);
            await Hyperdust_Token.waitForDeployment()


            const Hyperdust_BaseReward_Release = await ethers.deployContract("Hyperdust_BaseReward_Release");
            await Hyperdust_BaseReward_Release.waitForDeployment()


            await (await Hyperdust_BaseReward_Release.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target])).wait()



            await (await Hyperdust_Token.setPrivateSaleAddress(accounts[0].address)
            ).wait()


            await (await Hyperdust_Token.connect(accounts[1]).approveUpdateAddress("setPrivateSaleAddress")
            ).wait()


            await (await Hyperdust_Token.mint(ethers.parseEther('100000'))).wait()


            for (let i = 0; i < 400; i++) {
                await (await Hyperdust_BaseReward_Release.addBaseRewardReleaseRecord(ethers.parseEther('1'), accounts[0].address, 1)).wait()

            }

            const tx = await (await Hyperdust_BaseReward_Release.release()).wait()

            for (const log of tx.events) {


                if (log.address === Hyperdust_BaseReward_Release.target) {
                    const a = Hyperdust_BaseReward_Release.interface.decodeEventLog("eveRelease", log.data, log.topics)
                    console.info(a)
                }


            }




























        });
    });
});
