/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Transaction_Cfg");
    await contract.waitForDeployment()

    await (await contract.setContractAddress(["0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14", "0xd676222f5B6ddb6BB78e9C6e022aa7146506BcD0"])).wait();
    await (await contract.add("render", 30000)).wait();
    await (await contract.add("mintNFT", 30000)).wait();

    //const Hyperdust_Render_Transcition = await ethers.getContractAt("Hyperdust_Render_Transcition", "0x5c28a0EF89e5e341c5C9a87aDF72EbEAB5B3a9d5")

    //await (await Hyperdust_Render_Transcition.setTransactionCfg(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
