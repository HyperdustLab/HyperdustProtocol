/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {




            const accounts = await ethers.getSigners();


            const Test = await ethers.deployContract("EndiannessExample");
            await Test.waitForDeployment()

            //10101010101  01 01 10 10 10

            let a = '11';


            for (let i = 0; i < 62; i++) {

                a += '0';

            }

            console.info(a);



            const tx = await Test.getIndividualBytes('0x' + a)

            console.info(tx)





        });
    });
});
