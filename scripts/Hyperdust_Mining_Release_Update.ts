/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




    const Hyperdust_Mining_Release = await ethers.getContractFactory("Hyperdust_Mining_Release");

    const upgraded = await upgrades.upgradeProxy("0xb684C94D6D9aF42c370Ee124C8093f50faffEAdA", Hyperdust_Mining_Release);


    await upgraded.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4"
    ])





}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
