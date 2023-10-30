/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_HYDT_Price", ['0xb83E47C2bC239B3bf370bc41e1459A34b41238D0']);
    await contract.waitForDeployment()

    await (await contract.setSource('return Functions.encodeUint256(1000)')).wait();
    await (await contract.setSubscriptionId(1092)).wait();
    await (await contract.setGasLimit(300000)).wait();
    await (await contract.setJobId('0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000')).wait();
    await (await contract.setRolesCfgAddress('0xba9b4229C58A7eD1De9eaa1773fEd064D8c8B88F')).wait();


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
