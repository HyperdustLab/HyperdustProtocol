/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {





    const Hyperdust_Storage = await ethers.deployContract("Hyperdust_Storage");
    await Hyperdust_Storage.waitForDeployment()



    const contract = await ethers.getContractFactory("Hyperdust_Node_Service");
    const instance = await upgrades.deployProxy(contract);
    await instance.waitForDeployment();


    console.info("Hyperdust_Storage:", Hyperdust_Storage.target)


    await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()


    await (await instance.setHyperdustStorageAddress(Hyperdust_Storage.target)).wait()



    instance.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4",
        "0xf8991FaaD079eA01AA6Ba7bb7c6e22E044F55844",
        "0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f",
        Hyperdust_Storage.target
    ])

    console.info("contractFactory address:", instance.target)







}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
