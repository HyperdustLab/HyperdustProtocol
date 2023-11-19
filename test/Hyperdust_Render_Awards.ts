/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_Render_Awards", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();


            const Hyperdust_Roles_Cfg = await ethers.deployContract("Hyperdust_Roles_Cfg");
            await Hyperdust_Roles_Cfg.waitForDeployment()

            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token", [accounts[0].address, accounts[1].address, accounts[2].address]);
            await Hyperdust_Token.waitForDeployment()




            const Hyperdust_Node_CheckIn = await ethers.deployContract("Hyperdust_Node_CheckIn");
            await Hyperdust_Node_CheckIn.waitForDeployment()

            const Hyperdust_Node_Type = await ethers.deployContract("Hyperdust_Node_Type");
            await Hyperdust_Node_Type.waitForDeployment()


            const Hyperdust_Node_Mgr = await ethers.deployContract("Hyperdust_Node_Mgr");
            await Hyperdust_Node_Mgr.waitForDeployment()


            const Hyperdust_BaseReward_Release = await ethers.deployContract("Hyperdust_BaseReward_Release");
            await Hyperdust_BaseReward_Release.waitForDeployment()

            const Hyperdust_Render_Awards = await ethers.deployContract("Hyperdust_Render_Awards");
            await Hyperdust_Render_Awards.waitForDeployment()


            await (await Hyperdust_Token.setGPUMiningAddress(Hyperdust_Render_Awards.target)).wait()

            await (await Hyperdust_Token.connect(accounts[1]).approveUpdateAddress("setGPUMiningAddress"))




            const Hyperdust_Render_Transcition = await ethers.deployContract("Hyperdust_Render_Transcition");
            await Hyperdust_Render_Transcition.waitForDeployment()


            const Hyperdust_Security_Deposit = await ethers.deployContract("Hyperdust_Security_Deposit");
            await Hyperdust_Security_Deposit.waitForDeployment()


            const Hyperdust_Transaction_Cfg = await ethers.deployContract("Hyperdust_Transaction_Cfg");
            await Hyperdust_Transaction_Cfg.waitForDeployment()


            const Hyperdust_Wallet_Account = await ethers.deployContract("Hyperdust_Wallet_Account");
            await Hyperdust_Wallet_Account.waitForDeployment()



            await (await Hyperdust_Node_Type.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait()




            await (await Hyperdust_Node_Mgr.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_CheckIn.target, Hyperdust_Node_Type.target])).wait();

            await (await Hyperdust_Node_Mgr.setStatisticalIndex(10, 8)).wait()



            await (await Hyperdust_BaseReward_Release.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target])).wait()


            await (await Hyperdust_Security_Deposit.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target])).wait()


            await (await Hyperdust_Render_Transcition.setContractAddress([
                Hyperdust_Roles_Cfg.target,
                Hyperdust_Token.target,
                Hyperdust_Node_Mgr.target,
                Hyperdust_Transaction_Cfg.target,
                Hyperdust_Wallet_Account.target
            ])).wait();




            await (await Hyperdust_Transaction_Cfg.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_Mgr.target])).wait()

            await (await Hyperdust_Transaction_Cfg.add("render", 30000)).wait();


            await (await Hyperdust_Wallet_Account.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target])
            ).wait()



            await (await Hyperdust_Render_Awards.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_Mgr.target, Hyperdust_Security_Deposit.target, Hyperdust_BaseReward_Release.target, Hyperdust_Render_Transcition.target, Hyperdust_Token.target])
            ).wait()



            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Render_Awards.target)).wait()

            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Render_Transcition.target)).wait()



            await (await Hyperdust_Node_Type.addNodeType(1, "test", 1, 1, 1, 1, 1, "test", "test", "1")).wait();
            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.1", [1, 1, 1, 1, 1, 1, 1])).wait();
            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.2", [1, 1, 1, 1, 1, 1, 1])).wait();



            const array = []

            for (let i = 0; i < 1; i++) {
                const tx = await (await Hyperdust_Render_Awards.rewards(["0x1111000000000000000000000000000000000000000000000000000000000000"], 1)).wait()

                for (const log of tx?.logs) {

                    if (log.address === Hyperdust_Render_Awards.target) {
                        const a = Hyperdust_Render_Awards.interface.decodeEventLog("eveRewards", log.data, log.topics)
                        console.info(ethers.formatEther(a[1]))
                    }
                }

            }

            console.info(array)
        });
    });
});
