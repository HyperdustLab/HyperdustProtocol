/** @format */

import { ethers, upgrades } from "hardhat";

describe("Hyperdust_Transaction_Cfg", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();


            const _Hyperdust_Roles_Cfg = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
            const Hyperdust_Roles_Cfg = await upgrades.deployProxy(_Hyperdust_Roles_Cfg);

            








        });
    });
});
