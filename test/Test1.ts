/** @format */

import {ethers} from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();


            const Hyperdust_20 = await ethers.getContractAt("Hyperdust_20", "0xfcb8A945DC86D72f906D9C63222Dc470b5A35548");


            await (await Hyperdust_20.approve("0xe8BFc321b8bBb887B6cd9eE6C713c961a129E7A3", ethers.parseEther("2000"))).wait()


            // const Hyperdust_Faucet = await ethers.getContractAt("Hyperdust_Faucet", "0xe8BFc321b8bBb887B6cd9eE6C713c961a129E7A3")
            //
            //
            // await (await Hyperdust_Faucet.transfer([accounts[0].getAddress()], [ethers.parseEther("1")])).wait()
            //

        });
    });
});
