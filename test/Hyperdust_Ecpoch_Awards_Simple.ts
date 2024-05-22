/** @format */

import { ethers, upgrades } from "hardhat";

describe("Hyperdust_Ecpoch_Awards_Simple", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {

            const accounts = await ethers.getSigners();

            const _Hyperdust_Roles_Cfg = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
            const Hyperdust_Roles_Cfg = await upgrades.deployProxy(_Hyperdust_Roles_Cfg, [accounts[0].address])





            const Hyperdust_Node_Mgr = await ethers.deployContract("Hyperdust_Node_Mgr_Simple", [accounts[0].address]);
            await Hyperdust_Node_Mgr.waitForDeployment()

            await (await Hyperdust_Node_Mgr.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait();



            const _Hyperdust_Ecpoch_Awards_Simple = await ethers.getContractFactory("Hyperdust_Ecpoch_Awards_Simple");
            const Hyperdust_Ecpoch_Awards_Simple = await upgrades.deployProxy(_Hyperdust_Ecpoch_Awards_Simple, [accounts[0].address])


            await (await Hyperdust_Ecpoch_Awards_Simple.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_Mgr.target])).wait()

            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Ecpoch_Awards_Simple.target)).wait()


            await (await Hyperdust_Ecpoch_Awards_Simple.rewards(['0x1000000000000000000000000000000000000000000000000000000000000000'], 1)
            ).wait()



        });
    });
});
