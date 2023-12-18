/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Transcition");
    await contract.waitForDeployment()


    await (await contract.setContractAddress([
        "0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4",
        "0x24d30240883ac86c6d0b2475839aeDA38085B498",
        "0xAb0a5962659e59325ea6A3b0246444FC5e6024e0",
        "0x2EBDe3e744d0a870a17A2d51fd9079f14BF2137B"
    ])).wait();



    const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14')
    await (await Hyperdust_Roles_Cfg.addAdmin(contract.target)).wait()



    const Hyperdust_Render_Awards = await ethers.getContractAt('Hyperdust_Render_Awards', '0x0ba1f0329187C6AD8a73285100a9407F753B5A9f')

    await (await Hyperdust_Render_Awards.setHyperdustRenderTranscitionAddress(contract.target)).wait()

    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
