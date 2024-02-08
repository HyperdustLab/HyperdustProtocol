/** @format */

import { ethers, run, upgrades } from "hardhat";

import '@openzeppelin/hardhat-upgrades';

async function main() {

    const Hyperdust_Faucet = await ethers.getContractFactory("Hyperdust_Faucet");

    const upgraded = await upgrades.upgradeProxy("0xEDE777123774fD95Dd9181C4c6c9428126d9A276", Hyperdust_Faucet);


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
