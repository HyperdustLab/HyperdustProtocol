/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_AirDrop");
    await contract.waitForDeployment()

    await (await contract.setHyperdustTokenAddress('0x01778569225bA43FFDABF872607e1df2Bc83f102')).wait()
    await (await contract.setFromAddress('0x94A19469DB85E4b13E8Af2305cFE15ddd3D2f38B')).wait()


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
