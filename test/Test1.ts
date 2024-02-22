/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {


            const accounts = await ethers.getSigners();

            const Hyperdust_GPUMining = await ethers.getContractAt("Hyperdust_GPUMining", "0x08B6E87284b8B31b591C8Bd5488f433996D4dfc2")

            await (await Hyperdust_GPUMining.mint("0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f", ethers.parseEther("0.01"))).wait()













        });
    });
});
