/** @format */

import { ethers, run } from "hardhat";

async function main() {


    const contract = await ethers.deployContract("Hyperdust_Token_Test", ["0x19aa5b4bB6Ca72515845D6Faf1A69c1e06ff20C0", "0x6F9a1d8233A747a581594ee82071B2e3D77eA781", "0x94A19469DB85E4b13E8Af2305cFE15ddd3D2f38B"]);

    await contract.waitForDeployment()




    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
