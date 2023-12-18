/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Node_Mgr");
    await contract.waitForDeployment()


    await (await contract.setContractAddress(["0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76", "0x63E3dDdbA7d0778a8c1d493F6d6b8Bc0E95f2a96", "0x74BD810D6C5978cdd35873ee64244F563b78Bc6e"])).wait();


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
