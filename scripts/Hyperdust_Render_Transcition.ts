/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Transcition");
    await contract.waitForDeployment()


    await (await contract.setContractAddress([
        "0xd5A7E4eFb8Ae98aadE6d0078B3FeCf06c44c55Ae",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4",
        "0x0e9E04A0A98fD60F4179ca8988bF1cA94856e7A0",
        "0x6108a5aC82d15a8034902DcFC20431BD169d2597",
        "0xcA19Ba81bdF2d9d1a4EBEba09598265195821982"
    ])).wait();



    const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0xd5A7E4eFb8Ae98aadE6d0078B3FeCf06c44c55Ae')
    await (await Hyperdust_Roles_Cfg.addAdmin(contract.target)).wait()



    // const Hyperdust_Render_Awards = await ethers.getContractAt('Hyperdust_Render_Awards', '0x0ba1f0329187C6AD8a73285100a9407F753B5A9f')

    // await (await Hyperdust_Render_Awards.setHyperdustRenderTranscitionAddress(contract.target)).wait()

    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
