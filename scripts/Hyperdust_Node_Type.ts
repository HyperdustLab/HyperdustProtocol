/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Node_Type");
    await contract.waitForDeployment()

    await (await contract.setRolesCfgAddress('0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76')).wait();



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
