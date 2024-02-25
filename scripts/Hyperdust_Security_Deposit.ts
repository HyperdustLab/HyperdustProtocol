/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {



    const Hyperdust_Storage = await ethers.deployContract("Hyperdust_Storage", [process.env.ADMIN_Wallet_Address]);
    await Hyperdust_Storage.waitForDeployment()


    const contract = await ethers.getContractFactory("Hyperdust_Security_Deposit");
    const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);
    await instance.waitForDeployment();

    await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

    await (await instance.setContractAddress(
        ["0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
            "0xfcb8A945DC86D72f906D9C63222Dc470b5A35548",
            Hyperdust_Storage.target,
            "0xeCBD8E9349B1d96b86b834f5F404cc3B9a03DA6c"
        ])
    ).wait()

    console.info("Hyperdust_Storage:", Hyperdust_Storage.target)

    console.info("contractFactory address:", instance.target);



}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
