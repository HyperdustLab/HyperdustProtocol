/** @format */

import { ethers } from "hardhat";

const xlsx = require('node-xlsx')

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {



            const accounts = await ethers.getSigners();


            const Hyperdust_20 = await ethers.deployContract("Hyperdust_20", ["test", "test"]);

            await Hyperdust_20.waitForDeployment()


            const Hyperdust_AirDrop = await ethers.deployContract("Hyperdust_AirDrop");

            await Hyperdust_AirDrop.waitForDeployment()

            await (await Hyperdust_AirDrop.setFromAddress(accounts[0].address)).wait()

            await (await Hyperdust_AirDrop.setHyperdustTokenAddress(Hyperdust_20.target)).wait()


            await Hyperdust_20.mint(accounts[0].address, ethers.parseEther("500"))

            await (await Hyperdust_20.approve(Hyperdust_AirDrop.target, ethers.parseEther("500"))).wait()

            const sheets = xlsx.parse("C:\\Users\\fangy\\Downloads\\1.xlsx");


            const sheet = sheets[0];

            const data = sheet.data;

            let size = 500; // 你想要的每个分段的大小

            for (let i = 1; i <= data.length; i += size) {
                let slice = data.slice(i, i + size);

                const accountArray = []
                const amounts = []

                for (let j = 0; j < slice.length; j++) {

                    accountArray.push(ethers.getAddress(slice[j][0]))
                    amounts.push(ethers.parseEther(slice[j][1].toString()))
                }




                await (await Hyperdust_AirDrop.airDrop(accountArray, amounts)).wait()


            }

            const balance = await Hyperdust_20.balanceOf(accounts[0])

            console.info(ethers.formatEther(balance))
        });
    });
});
