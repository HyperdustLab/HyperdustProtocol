/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Wallet_Account");
    const upgraded = await upgrades.upgradeProxy("0x03cdcef3829eE8C5e14c604B3F0df6e9739a5Da2", contract);



    await (await upgraded.setContractAddress(
        ["0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
            "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4",
            "0x03cdcef3829eE8C5e14c604B3F0df6e9739a5Da2"])
    ).wait()

}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
