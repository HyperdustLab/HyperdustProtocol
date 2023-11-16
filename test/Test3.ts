/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {




            const accounts = await ethers.getSigners();


            const Test1 = await ethers.deployContract("Test1");
            await Test1.waitForDeployment()


            const Test2 = await ethers.deployContract("Test2");
            await Test2.waitForDeployment()

            await (await Test2.setTest1(Test1.target)).wait()



            const test = await (await Test2.getTest1());

            console.info(test)





        });
    });
});
