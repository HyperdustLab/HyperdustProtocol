/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("FunctionsConsumerExample", ['0xb83E47C2bC239B3bf370bc41e1459A34b41238D0']);
    await contract.waitForDeployment()


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
