/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Render_Awards");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14",
        "0xd676222f5B6ddb6BB78e9C6e022aa7146506BcD0",
        "0xC50183008C4642d7325B1B049F7988b895dAfAA6",
        "0x37e1D9d13509819b1AeD058dE2d288BE4dF31D62",
        "0x82b8A6AE65ab9449273179f8D2EfE44398A8401f",
        "0xBF99159A5a2Bb18eA43f99D9C0E0c35F897Be74E"
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
