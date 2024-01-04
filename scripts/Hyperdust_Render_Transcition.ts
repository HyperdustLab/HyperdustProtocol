/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




    const Hyperdust_Storage = await ethers.deployContract("Hyperdust_Storage");
    await Hyperdust_Storage.waitForDeployment()



    const contract = await ethers.getContractFactory("Hyperdust_Render_Transcition");
    const instance = await upgrades.deployProxy(contract);
    await instance.waitForDeployment();

    const implementationAddress = await upgrades.erc1967.getImplementationAddress(instance.target)

    console.info("implementationAddress:", implementationAddress);
    console.info("Hyperdust_Storage:", Hyperdust_Storage.target)


    await (await Hyperdust_Storage.setServiceAddress(implementationAddress)).wait()



    await (await instance.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4",
        "0x5f9Fbd15284B56D50F8844F22a8838e65EB2Fc76",
        "0xfbdB6d8B4e47c0d546eE0f721BF2EBfE55136E53",
        "0xcA19Ba81bdF2d9d1a4EBEba09598265195821982",
        Hyperdust_Storage.target
    ])).wait()




    const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x9bDaf3912e7b4794fE8aF2E748C35898265D5615')
    await (await Hyperdust_Roles_Cfg.addAdmin(implementationAddress)).wait()



    // const Hyperdust_Render_Awards = await ethers.getContractAt('Hyperdust_Render_Awards', '0x0ba1f0329187C6AD8a73285100a9407F753B5A9f')

    // await (await Hyperdust_Render_Awards.setHyperdustRenderTranscitionAddress(contract.target)).wait()

    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
