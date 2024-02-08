/** @format */

import { ethers, run, upgrades } from "hardhat";

import '@openzeppelin/hardhat-upgrades';

async function main() {
    const contract = await ethers.getContractFactory("Hyperdust_Node_CheckIn");

    const instance = await upgrades.deployProxy(contract, ["0xD21B836E74109022c3f37676485E479EECce55db"]);

    await instance.waitForDeployment();

    console.info("contractFactory address:", instance.target);

}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
