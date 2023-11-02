/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Security_Deposit");
    await contract.waitForDeployment()

    await (await contract.setContractAddress(["0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14", "0x617C4e961Ad922c05EBF3e4521d329Ff5Ef89a9E"])).wait()


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
