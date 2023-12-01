/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Transcition");
    await contract.waitForDeployment()


    await (await contract.setContractAddress([
        "0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14",
        "0x1CF7f55C216b28BC14Bf663d49D95d5F68446bed",
        "0xd676222f5B6ddb6BB78e9C6e022aa7146506BcD0",
        "0xeb43b97d1AE99F28c07d0EA79C467E3ECF2a6A77",
        "0x41B72CB16A2e89DddA403519A42aa0C386c1A4e7"
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
