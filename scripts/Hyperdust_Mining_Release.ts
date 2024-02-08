/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {






    const contract = await ethers.getContractFactory("Hyperdust_Mining_Release");
    const instance = await upgrades.deployProxy(contract);
    await instance.waitForDeployment();

    await (
        await instance.setContractAddress([
            "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
            "0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f",
            "0x01778569225bA43FFDABF872607e1df2Bc83f102"
        ])).wait()

    console.info("contractFactory address:", instance.target)







}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
