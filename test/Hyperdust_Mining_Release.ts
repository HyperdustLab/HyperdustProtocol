/** @format */

import { ethers, upgrades } from "hardhat";

describe("Hyperdust_Mining_Release", () => {
    describe("Hyperdust_Mining_Release", () => {
        it("Hyperdust_Mining_Release", async () => {

            const accounts = await ethers.getSigners();




            const _Hyperdust_Mining_Release = await ethers.getContractFactory("Hyperdust_Mining_Release");
            const Hyperdust_Mining_Release = await upgrades.deployProxy(_Hyperdust_Mining_Release);
            await Hyperdust_Mining_Release.waitForDeployment();



            const _Hyperdust_Roles_Cfg = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
            const Hyperdust_Roles_Cfg = await upgrades.deployProxy(_Hyperdust_Roles_Cfg);



            const Hyperdust_Token = await ethers.deployContract("Hyperdust_20", ["TEST", "TEST"]);
            await Hyperdust_Token.waitForDeployment()

            await (await Hyperdust_Token.mint(accounts[0], ethers.parseEther("1000"))).wait()

            await (await Hyperdust_Token.approve(Hyperdust_Mining_Release.target, ethers.parseEther("1000"))).wait()

            await (await Hyperdust_Mining_Release.setContractAddress([
                Hyperdust_Roles_Cfg.target,
                accounts[0].address,
                Hyperdust_Token.target
            ])).wait()




            const _accounts = []
            const releaseTimes = []
            const amounts = []


            for (let i = 0; i < 1000; i++) {

                let accountIndex = i % 10;

                _accounts.push(accounts[accountIndex].address)
                releaseTimes.push(i);
                amounts.push(ethers.parseEther("1"))
            }


            const tx = await (await Hyperdust_Mining_Release.release(_accounts, releaseTimes, amounts)).wait()

            console.info(tx)



        });
    });
});
