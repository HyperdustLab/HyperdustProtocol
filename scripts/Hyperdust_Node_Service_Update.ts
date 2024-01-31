/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const Hyperdust_Node_Service = await ethers.getContractFactory("Hyperdust_Node_Service");

    const upgraded = await upgrades.upgradeProxy("0x0c22870b3efcbA2217e4A08bCA85f54969dC6258", Hyperdust_Node_Service);



    upgraded.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x9D88106Ba510D3852eC03B22b8F754F2bcd16739",
        "0x1045A6b9be4149254F2194fb0Ed7DC7bC7B2795B",
        "0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f",
        "0x4685BDa3F0A0A0C2E997A073923F6c023239Ebc7"
    ])






}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
