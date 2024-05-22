"use strict";
/** @format */
Object.defineProperty(exports, "__esModule", { value: true });
const hardhat_1 = require("hardhat");
describe("Hyperdust_Ecpoch_Awards_Simple", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {
            const accounts = await hardhat_1.ethers.getSigners();
            const _Hyperdust_Roles_Cfg = await hardhat_1.ethers.getContractFactory("Hyperdust_Roles_Cfg");
            const Hyperdust_Roles_Cfg = await hardhat_1.upgrades.deployProxy(_Hyperdust_Roles_Cfg, [accounts[0].address]);
            const Hyperdust_Node_Mgr = await hardhat_1.ethers.deployContract("Hyperdust_Node_Mgr_Simple", [accounts[0].address]);
            await Hyperdust_Node_Mgr.waitForDeployment();
            await (await Hyperdust_Node_Mgr.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait();
            const _Hyperdust_Ecpoch_Awards_Simple = await hardhat_1.ethers.getContractFactory("Hyperdust_Ecpoch_Awards_Simple");
            const Hyperdust_Ecpoch_Awards_Simple = await hardhat_1.upgrades.deployProxy(_Hyperdust_Ecpoch_Awards_Simple, [accounts[0].address]);
            await (await Hyperdust_Ecpoch_Awards_Simple.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_Mgr.target])).wait();
            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Ecpoch_Awards_Simple.target)).wait();
            await (await Hyperdust_Ecpoch_Awards_Simple.rewards(['0x1000000000000000000000000000000000000000000000000000000000000000'], 1)).wait();
        });
    });
});
