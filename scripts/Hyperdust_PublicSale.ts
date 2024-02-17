/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




    const contract = await ethers.getContractFactory("Hyperdust_PublicSale");
    const instance = await upgrades.deployProxy(contract, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600]);
    await instance.waitForDeployment();



    console.info("contractFactory address:", instance.target);




}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
