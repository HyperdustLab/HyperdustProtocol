/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Transcition");
    await contract.waitForDeployment()


    await (await contract.setContractAddress([
        "0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14",
        "0x617C4e961Ad922c05EBF3e4521d329Ff5Ef89a9E",
        "0xd676222f5B6ddb6BB78e9C6e022aa7146506BcD0",
        "0x2E945549f791C5ED518Fa99a453afbF32B31F977",
        "0x41B72CB16A2e89DddA403519A42aa0C386c1A4e7"
    ])).wait();



    const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14')
    await (await Hyperdust_Roles_Cfg.addAdmin(contract.target)).wait()

    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
