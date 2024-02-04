/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();



            const Hyperdust_BaseReward_Release = await ethers.getContractAt("Hyperdust_BaseReward_Release", "0x511c0be0B9B1068152a121C982EF059212F96dAd")

            await (await Hyperdust_BaseReward_Release.release([1706891167])).wait()









        });
    });
});
