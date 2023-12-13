/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Security_Deposit");
    await contract.waitForDeployment()

    await (await contract.setContractAddress(["0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76", "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4"])).wait()


    // const Hyperdust_Render_Awards = await ethers.getContractAt("Hyperdust_Render_Awards", "0x4297BC40938a2ceeF67A19848A8eB0b7E2e63c8f")

    // await (await Hyperdust_Render_Awards.setHyperdustSecurityDeposit(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
