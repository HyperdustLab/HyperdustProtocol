/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




    const Hyperdust_Storage = await ethers.deployContract("Hyperdust_Storage");
    await Hyperdust_Storage.waitForDeployment()



    const contract = await ethers.getContractFactory("Hyperdust_Render_Transcition");
    const instance = await upgrades.deployProxy(contract);
    await instance.waitForDeployment();


    console.info("Hyperdust_Storage:", Hyperdust_Storage.target)


    await (await instance.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4",
        "0x1e89b67D2075D4E1973B832203f12F5960C371E1",
        "0x7C94D4145c2d2ad2712B496DF6C27EEA5E0252C2",
        "0x3812D0341D721F66698228B0b10De0396117499e",
        Hyperdust_Storage.target
    ])).wait()




    const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x9bDaf3912e7b4794fE8aF2E748C35898265D5615')
    await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()




    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
