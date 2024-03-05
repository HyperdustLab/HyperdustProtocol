/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const Hyperdust_Ecpoch_Transcition = await ethers.getContractFactory("Hyperdust_Epoch_Transcition");

    await upgrades.upgradeProxy("0x844Ad896923ECd5c94d5A92eBEDb1D1CD09A8E77", Hyperdust_Ecpoch_Transcition);


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
