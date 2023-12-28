/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Awards");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0xd5A7E4eFb8Ae98aadE6d0078B3FeCf06c44c55Ae",
        "0x0e9E04A0A98fD60F4179ca8988bF1cA94856e7A0",
        "0xcF9446240c525a249a4c00B74Daf5d05fC28a952",
        "0x505550deAab7E31fFd1Fd8364Ba2baEFc4F3b656",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4"
    ])).wait()


    const Hyperdust_Roles_Cfg = await ethers.getContractAt("Hyperdust_Roles_Cfg", "0xd5A7E4eFb8Ae98aadE6d0078B3FeCf06c44c55Ae")

    await (await Hyperdust_Roles_Cfg.addAdmin(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
