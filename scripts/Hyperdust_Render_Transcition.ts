/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Transcition");
    await contract.waitForDeployment()


    await (await contract.setContractAddress([
        "0xba9b4229C58A7eD1De9eaa1773fEd064D8c8B88F",
        "0xc95d7c5B58AF9D9bA0A6a30c428a737B224Dab39",
        "0x5e59cEe5D05778a54858bD3Aa7d1107b48B016F6",
        "0x9EEb20ab68B01ceeB7D3EB11E30dD972A27C93b9",
        "0x41B72CB16A2e89DddA403519A42aa0C386c1A4e7",
        "0x62aFeD11312a805Be78aDDf49B7C4e81310d2799"
    ])).wait();



    const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0xba9b4229C58A7eD1De9eaa1773fEd064D8c8B88F')
    await (await Hyperdust_Roles_Cfg.addAdmin(contract.target)).wait()

    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
