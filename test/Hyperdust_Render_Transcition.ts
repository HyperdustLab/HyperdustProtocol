/** @format */

import { ethers } from "hardhat";
const { describe, it } = require("mocha");

import dayjs from 'dayjs'

describe("MGN_Render_Transcition", () => {
    describe("MGN_Render_Transcition", () => {
        it("settlementOrder", async () => {
            const accounts = await ethers.getSigners();



            const Hyperdust_Roles_Cfg = await ethers.deployContract("Hyperdust_Roles_Cfg");
            await Hyperdust_Roles_Cfg.waitForDeployment()



            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token_Test", [accounts[0].address, accounts[1].address, accounts[2].address]);
            await Hyperdust_Token.waitForDeployment()


            await (await Hyperdust_Token.setPrivateSaleAddress(accounts[0].address)
            ).wait()


            await (await Hyperdust_Token.connect(accounts[1]).approveUpdateAddress("setPrivateSaleAddress")
            ).wait()


            await (await Hyperdust_Token.mint(ethers.parseEther('100000'))).wait()




            const Hyperdust_Node_CheckIn = await ethers.deployContract("Hyperdust_Node_CheckIn");
            await Hyperdust_Node_CheckIn.waitForDeployment()





            const Hyperdust_Node_Type = await ethers.deployContract("Hyperdust_Node_Type");
            await Hyperdust_Node_Type.waitForDeployment()




            const Hyperdust_Node_Type_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Node_Type_Data.waitForDeployment()

            await (await Hyperdust_Node_Type.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait();
            await (await Hyperdust_Node_Type.setHyperdustStorageAddress(Hyperdust_Node_Type_Data.target)).wait();

            await (await Hyperdust_Node_Type_Data.setServiceAddress(Hyperdust_Node_Type.target)).wait()



            const Hyperdust_Node_Mgr = await ethers.deployContract("Hyperdust_Node_Mgr");
            await Hyperdust_Node_Mgr.waitForDeployment()


            const Hyperdust_Node_Mgr_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Node_Mgr_Data.waitForDeployment()

            await (await Hyperdust_Node_Mgr_Data.setServiceAddress(Hyperdust_Node_Mgr.target)).wait()



            await (await Hyperdust_Node_Mgr.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_CheckIn.target, Hyperdust_Node_Type.target, Hyperdust_Node_Mgr_Data.target])).wait();
            await (await Hyperdust_Node_Mgr.setStatisticalIndex(10, 8)).wait()



            const Hyperdust_Transaction_Cfg = await ethers.deployContract("Hyperdust_Transaction_Cfg");
            await Hyperdust_Transaction_Cfg.waitForDeployment()

            await (await Hyperdust_Transaction_Cfg.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_Mgr.target])).wait();


            await (await Hyperdust_Transaction_Cfg.add("render", 30000)).wait();



            const Hyperdust_Wallet_Account = await ethers.deployContract("Hyperdust_Wallet_Account");
            await Hyperdust_Wallet_Account.waitForDeployment()

            await (await Hyperdust_Wallet_Account.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target])).wait();



            const Hyperdust_Render_Transcition = await ethers.deployContract("Hyperdust_Render_Transcition");
            await Hyperdust_Render_Transcition.waitForDeployment()



            const Hyperdust_Render_Transcition_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Render_Transcition_Data.waitForDeployment()


            await (await Hyperdust_Render_Transcition.setContractAddress([
                Hyperdust_Roles_Cfg.target,
                Hyperdust_Token.target,
                Hyperdust_Node_Mgr.target,
                Hyperdust_Transaction_Cfg.target,
                Hyperdust_Wallet_Account.target,
                Hyperdust_Render_Transcition_Data.target
            ])).wait();



            await (await Hyperdust_Render_Transcition_Data.setServiceAddress(Hyperdust_Render_Transcition.target)).wait()


            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Render_Transcition.target)).wait()


            Hyperdust_Token.approve(Hyperdust_Render_Transcition.target, ethers.parseEther('99999999'));



            await (await Hyperdust_Node_Type.addNodeType(1, "test", 1, 1, 1, 1, 1, "test", "test", "1")).wait();



            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.1", [1, 1, 1, 1, 1, 1, 1])).wait();
            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.2", [1, 1, 1, 1, 1, 1, 1])).wait();

            await (await Hyperdust_Render_Transcition.createRenderTranscition(1, 2)).wait();





            const getRuningRenderAccounts = await Hyperdust_Render_Transcition.getRuningRenderAccounts(accounts[0].address);
            console.info(getRuningRenderAccounts)

            const getRuningRenderNodes = await Hyperdust_Render_Transcition.getRuningRenderNodes(1);

            console.info(getRuningRenderNodes)

            const updateEpoch = await (await Hyperdust_Render_Transcition.updateEpoch()).wait()


            const getRuningRenderTranscitions = await Hyperdust_Render_Transcition.getRuningRenderTranscitions();

            console.info(getRuningRenderTranscitions)


            const ts = await Hyperdust_Render_Transcition.getRenderTranscition(1)

            console.info(ts)


            console.info("Hyperdust_Render_Transcition:" + Hyperdust_Render_Transcition.target)

        });
    });
});
