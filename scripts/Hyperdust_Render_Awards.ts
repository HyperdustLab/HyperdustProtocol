/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Awards");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76",
        "0x24d30240883ac86c6d0b2475839aeDA38085B498",
        "0x6567a36fE357F1c71C3F8e469Bce411e7Ad599Ae",
        "0x2D054A5CC017c72D91F9633908f29907B9814968",
        "0x90159260ca306Fc6bCc46048BeDEe5121CdD641f",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4"
    ])).wait()


    const Hyperdust_Roles_Cfg = await ethers.getContractAt("Hyperdust_Roles_Cfg", "0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76")

    await (await Hyperdust_Roles_Cfg.addAdmin(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
