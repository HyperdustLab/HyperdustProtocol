/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_AirDrop");
    await contract.waitForDeployment()

    await (await contract.setHyperdustTokenAddress('0x01778569225bA43FFDABF872607e1df2Bc83f102')).wait()
    await (await contract.setFromAddress('0xfa52c5b797E790Cb35F20694D4E8909477B2EF74')).wait()


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
