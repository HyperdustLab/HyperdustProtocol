/** @format */

import { ethers, run } from "hardhat";

async function main() {


    const contract = await ethers.deployContract("Hyperdust_Token", ["0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f", "0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", "0xAB2E610853de9D3A82048a38384BBF480EF244c1"]);

    await contract.waitForDeployment()

    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
