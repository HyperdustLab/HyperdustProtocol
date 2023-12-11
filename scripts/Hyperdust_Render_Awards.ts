/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Awards");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14",
        "0xd676222f5B6ddb6BB78e9C6e022aa7146506BcD0",
        "0xC50183008C4642d7325B1B049F7988b895dAfAA6",
        "0x2a3Eed20964Dfd9195933F5346b3499Fa1b5bAea",
        "0x12A6e858ab994Bc7f874d82952AA0c44FaB14eb9",
        "0x1CF7f55C216b28BC14Bf663d49D95d5F68446bed"
    ])).wait()


    const Hyperdust_Roles_Cfg = await ethers.getContractAt("Hyperdust_Roles_Cfg", "0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14")

    await (await Hyperdust_Roles_Cfg.addAdmin(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
