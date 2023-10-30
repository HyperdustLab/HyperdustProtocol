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



            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token");
            await Hyperdust_Token.waitForDeployment()
            await (await Hyperdust_Token.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait()



            const Hyperdust_Node_CheckIn = await ethers.deployContract("Hyperdust_Node_CheckIn");
            await Hyperdust_Node_CheckIn.waitForDeployment()





            const Hyperdust_Node_Type = await ethers.deployContract("Hyperdust_Node_Type");
            await Hyperdust_Node_Type.waitForDeployment()

            await (await Hyperdust_Node_Type.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait();



            const Hyperdust_Node_Mgr = await ethers.deployContract("Hyperdust_Node_Mgr");
            await Hyperdust_Node_Mgr.waitForDeployment()

            await (await Hyperdust_Node_Mgr.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_CheckIn.target, Hyperdust_Node_Type.target])).wait();




            const Hyperdust_Transaction_Cfg = await ethers.deployContract("Hyperdust_Transaction_Cfg");
            await Hyperdust_Transaction_Cfg.waitForDeployment()

            await (await Hyperdust_Transaction_Cfg.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait();
            await (await Hyperdust_Transaction_Cfg.add("render", ethers.parseUnits('2.1', 'ether'))).wait();



            const Hyperdust_Wallet_Account = await ethers.deployContract("Hyperdust_Wallet_Account");
            await Hyperdust_Wallet_Account.waitForDeployment()

            await (await Hyperdust_Wallet_Account.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target])).wait();


            const Hyperdust_HYDT_Price = await ethers.deployContract("Hyperdust_HYDT_Price", ['0xb83E47C2bC239B3bf370bc41e1459A34b41238D0']);
            await Hyperdust_HYDT_Price.waitForDeployment()

            await (await Hyperdust_HYDT_Price.setSource('return Functions.encodeUint256(1000)')).wait();
            await (await Hyperdust_HYDT_Price.setSubscriptionId(1092)).wait();
            await (await Hyperdust_HYDT_Price.setGasLimit(30000)).wait();
            await (await Hyperdust_HYDT_Price.setJobId('0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000')).wait();
            await (await Hyperdust_HYDT_Price.setRolesCfgAddress('0xba9b4229C58A7eD1De9eaa1773fEd064D8c8B88F')).wait();






            const Hyperdust_Render_Transcition = await ethers.deployContract("Hyperdust_Render_Transcition");
            await Hyperdust_Render_Transcition.waitForDeployment()


            await (await Hyperdust_Render_Transcition.setContractAddress([
                Hyperdust_Roles_Cfg.target,
                Hyperdust_Token.target,
                Hyperdust_Node_Mgr.target,
                Hyperdust_Transaction_Cfg.target,
                Hyperdust_Wallet_Account.target,
                Hyperdust_HYDT_Price.target
            ])).wait();




            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Render_Transcition.target)).wait()

            Hyperdust_Token.mint(accounts[0].address, ethers.parseUnits('1000', 'ether'));
            Hyperdust_Token.approve(Hyperdust_Render_Transcition.target, ethers.parseUnits('1000', 'ether'));
            await (await Hyperdust_Node_Type.addNodeType(1, "test", 1, 1, 1, 1, 1, "test", "test", "1")).wait();
            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.1", [1, 1, 1, 1, 1, 1, 1])).wait();
            await (await Hyperdust_Render_Transcition.createRenderTranscition(1, 3)).wait();


        });
    });
});
