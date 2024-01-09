/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Render_Awards");
    const instance = await upgrades.deployProxy(contract);
    await instance.waitForDeployment();



    await (await instance.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x1e89b67D2075D4E1973B832203f12F5960C371E1",
        "0xD7ed90629D6a4553F85ad413375E81c3B019f882",
        "0xfBe5Faa73D2Cb86AeE02D50a2cf94b60451e589a",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4"
    ])).wait()


    const Hyperdust_Roles_Cfg = await ethers.getContractAt("Hyperdust_Roles_Cfg", "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615")

    await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
