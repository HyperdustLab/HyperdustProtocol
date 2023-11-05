/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Awards");
    await contract.waitForDeployment()

    await (await contract.setContractAddress(["0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14", "0xd676222f5B6ddb6BB78e9C6e022aa7146506BcD0", "0xd75864a7970361235469009e5A3511206E23c780", "0x9b00C722461E845D71a1d370B7B7223ffFc30Fb6", "0x5c28a0EF89e5e341c5C9a87aDF72EbEAB5B3a9d5"])).wait()


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
