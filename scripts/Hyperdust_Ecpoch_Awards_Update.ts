/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




    const Hyperdust_Ecpoch_Awards = await ethers.getContractFactory("Hyperdust_Ecpoch_Awards");

    const upgraded = await upgrades.upgradeProxy("0x7FaED49F26bC0332806Cd7Ab20154824eCF3F72f", Hyperdust_Ecpoch_Awards);


    await (await upgraded.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x1e89b67D2075D4E1973B832203f12F5960C371E1",
        "0xa1011ae8964fEc89303EA37D95f3eCAFF5Ac7695",
        "0x9c41D5d1Da6acd0f0033A9e5Bf7B0303a9c3280a",
        "0x830d8588F06E9E58B68d0fb8E6122180Fd9711Fe"
    ])).wait()
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
