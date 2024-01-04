/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Render_Awards");
    const instance = await upgrades.deployProxy(contract);
    await instance.waitForDeployment();

    const implementationAddress = await upgrades.erc1967.getImplementationAddress(instance.target)

    console.info("implementationAddress:", implementationAddress);



    await (await instance.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x5f9Fbd15284B56D50F8844F22a8838e65EB2Fc76",
        "0xcF9446240c525a249a4c00B74Daf5d05fC28a952",
        "0x505550deAab7E31fFd1Fd8364Ba2baEFc4F3b656",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4"
    ])).wait()


    const Hyperdust_Roles_Cfg = await ethers.getContractAt("Hyperdust_Roles_Cfg", "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615")

    await (await Hyperdust_Roles_Cfg.addAdmin(implementationAddress)).wait()


    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
