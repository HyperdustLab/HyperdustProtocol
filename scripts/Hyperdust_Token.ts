/** @format */

import { ethers, run } from "hardhat";

async function main() {


    const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", "0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f"]);

    await contract.waitForDeployment()




    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
