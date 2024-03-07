/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();


            const Hyperdust_Epoch_Transcition = await ethers.getContractAt("Hyperdust_Epoch_Transcition", "0x82E7EcEC252EE198247184Ad18005e3dc64b2dca");


            await (await Hyperdust_Epoch_Transcition.createEpochTranscition(1, 1)).wait()



            // const Hyperdust_Faucet = await ethers.getContractAt("Hyperdust_Faucet", "0xe8BFc321b8bBb887B6cd9eE6C713c961a129E7A3")
            //
            //
            // await (await Hyperdust_Faucet.transfer([accounts[0].getAddress()], [ethers.parseEther("1")])).wait()
            //

        });
    });
});
