/** @format */

import { ethers, upgrades } from "hardhat";
const { describe, it } = require("mocha");

import dayjs from 'dayjs'

describe("MGN_Render_Transcition", () => {
    describe("MGN_Render_Transcition", () => {
        it("settlementOrder", async () => {
            const accounts = await ethers.getSigners();



            const _Hyperdust_Roles_Cfg = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
            const Hyperdust_Roles_Cfg = await upgrades.deployProxy(_Hyperdust_Roles_Cfg, [accounts[0].address]);



            const Hyperdust_Token = await ethers.deployContract("Hyperdust_20", ["Test", "Test"]);
            await Hyperdust_Token.waitForDeployment()


            await (await Hyperdust_Token.mint(accounts[0].address, ethers.parseEther('100000'))).wait()




            const _Hyperdust_Node_CheckIn = await ethers.getContractFactory("Hyperdust_Node_CheckIn");
            const Hyperdust_Node_CheckIn = await upgrades.deployProxy(_Hyperdust_Node_CheckIn);





            const _Hyperdust_Node_Type = await ethers.getContractFactory("Hyperdust_Node_Type");
            const Hyperdust_Node_Type = await upgrades.deployProxy(_Hyperdust_Node_Type);



            const Hyperdust_Node_Type_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Node_Type_Data.waitForDeployment()

            await (await Hyperdust_Node_Type.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait();
            await (await Hyperdust_Node_Type.setHyperdustStorageAddress(Hyperdust_Node_Type_Data.target)).wait();

            await (await Hyperdust_Node_Type_Data.setServiceAddress(Hyperdust_Node_Type.target)).wait()



            const _Hyperdust_Node_Mgr = await ethers.getContractFactory("Hyperdust_Node_Mgr");
            const Hyperdust_Node_Mgr = await upgrades.deployProxy(_Hyperdust_Node_Mgr);


            const Hyperdust_Node_Mgr_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Node_Mgr_Data.waitForDeployment()

            await (await Hyperdust_Node_Mgr_Data.setServiceAddress(Hyperdust_Node_Mgr.target)).wait()



            await (await Hyperdust_Node_Mgr.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_CheckIn.target, Hyperdust_Node_Type.target, Hyperdust_Node_Mgr_Data.target])).wait();
            await (await Hyperdust_Node_Mgr.setStatisticalIndex(10, 8)).wait()



            const _Hyperdust_Transaction_Cfg = await ethers.getContractFactory("Hyperdust_Transaction_Cfg");
            const Hyperdust_Transaction_Cfg = await upgrades.deployProxy(_Hyperdust_Transaction_Cfg);

            await (await Hyperdust_Transaction_Cfg.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_Mgr.target])).wait();


            await (await Hyperdust_Transaction_Cfg.add("epoch", 30000)).wait();


            await (await Hyperdust_Transaction_Cfg.setMinGasFee("epoch", ethers.parseEther("0.0001"))).wait()




            const _Hyperdust_Wallet_Account = await ethers.getContractFactory("Hyperdust_Wallet_Account");
            const Hyperdust_Wallet_Account = await upgrades.deployProxy(_Hyperdust_Wallet_Account, [accounts[0].address])

            await (await Hyperdust_Wallet_Account.setContractAddress([Hyperdust_Roles_Cfg.target, accounts[0].address])).wait();



            const _Hyperdust_Ecpoch_Transcition = await ethers.getContractFactory("Hyperdust_Ecpoch_Transcition");
            const Hyperdust_Ecpoch_Transcition = await upgrades.deployProxy(_Hyperdust_Ecpoch_Transcition);



            const Hyperdust_Render_Transcition_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Render_Transcition_Data.waitForDeployment()


            await (await Hyperdust_Ecpoch_Transcition.setContractAddress([
                Hyperdust_Roles_Cfg.target,
                Hyperdust_Token.target,
                Hyperdust_Node_Mgr.target,
                Hyperdust_Transaction_Cfg.target,
                Hyperdust_Wallet_Account.target,
                Hyperdust_Render_Transcition_Data.target
            ])).wait();



            await (await Hyperdust_Render_Transcition_Data.setServiceAddress(Hyperdust_Ecpoch_Transcition.target)).wait()


            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Ecpoch_Transcition.target)).wait()


            await (await Hyperdust_Token.approve(Hyperdust_Ecpoch_Transcition.target, ethers.parseEther('99999999'))).wait();



            await (await Hyperdust_Node_Type.addNodeType(1, "test", 1, 1, 1, 1, 1, "test", "test", "1")).wait();



            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.1", [1, 1, 1, 1, 1, 1, 1])).wait();
            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.2", [1, 1, 1, 1, 1, 1, 1])).wait();

            await (await Hyperdust_Ecpoch_Transcition.createRenderTranscition(1, 1)).wait();


            const a = await Hyperdust_Ecpoch_Transcition.getRenderTranscition(1)

            console.info(a)

            // const getRuningRenderAccounts = await Hyperdust_Render_Transcition.getRuningRenderAccounts(accounts[0].address);
            // console.info(getRuningRenderAccounts)

            // const getRuningRenderNodes = await Hyperdust_Render_Transcition.getRuningRenderNodes(1);

            // console.info(getRuningRenderNodes)

            // const updateEpoch = await (await Hyperdust_Render_Transcition.updateEpoch()).wait()


            // const getRuningRenderTranscitions = await Hyperdust_Render_Transcition.getRuningRenderTranscitions();

            // console.info(getRuningRenderTranscitions)


            // const ts = await Hyperdust_Render_Transcition.getRenderTranscition(1)

            // console.info(ts)


            // console.info("Hyperdust_Render_Transcition:" + Hyperdust_Render_Transcition.target)

        });
    });
});
