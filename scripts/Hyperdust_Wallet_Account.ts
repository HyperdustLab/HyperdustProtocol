/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Wallet_Account");
    const instance = await upgrades.deployProxy(contract, ["0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f"]);
    await instance.waitForDeployment();



    await (await instance.setContractAddress(
        ["0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
            "0xF851B3cF1B482ce699FD6DcB329D713b6D55532c"])
    ).wait()


    console.info("contractFactory address:", instance.target);


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
