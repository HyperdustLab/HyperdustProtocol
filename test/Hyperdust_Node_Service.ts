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


            



            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token_Test",

                [accounts[0].address, accounts[1].address, accounts[2].address]);

            
            
            await Hyperdust_Token.waitForDeployment()



            const Hyperdust_Node_Product = await ethers.deployContract("Hyperdust_Node_Product");
            await Hyperdust_Node_Product.waitForDeployment()

            await (await Hyperdust_Node_Product.setHyperdustRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait()


            const Hyperdust_Node_Service = await ethers.deployContract("Hyperdust_Node_Service");
            await Hyperdust_Node_Service.waitForDeployment()

            await (await Hyperdust_Node_Service.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target, Hyperdust_Node_Product.target, accounts[1].address])
            ).wait()


            await (await Hyperdust_Token.setPrivateSaleAddress(accounts[0].address)
            ).wait()


            await (await Hyperdust_Token.connect(accounts[1]).approveUpdateAddress("setPrivateSaleAddress")
            ).wait()


            await (await Hyperdust_Token.mint(ethers.parseEther('100000'))).wait()


            await (await Hyperdust_Node_Product.add('test', 30, ethers.parseEther('0.01'))).wait()


            await (await Hyperdust_Token.approve(Hyperdust_Node_Service.target, ethers.parseEther('0.02'))).wait()


            await (await Hyperdust_Node_Service.buy(1, 2)).wait()

            const ts = await Hyperdust_Node_Service.get(1)

            console.info(ts)


            await (await Hyperdust_Node_Service.assignmentNode(1, [1], [1])).wait()

            const ts1 = await Hyperdust_Node_Service.get(1)

            console.info(ts1)



        });
    });
});
