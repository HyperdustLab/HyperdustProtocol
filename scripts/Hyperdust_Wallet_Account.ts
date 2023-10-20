/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Wallet_Account");
    await contract.waitForDeployment()

    await (await contract.setContractAddress(["0xba9b4229C58A7eD1De9eaa1773fEd064D8c8B88F", "0xc95d7c5B58AF9D9bA0A6a30c428a737B224Dab39"])).wait();


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
