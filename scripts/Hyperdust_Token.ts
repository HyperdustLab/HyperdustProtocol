/** @format */

import { ethers, run } from "hardhat";

async function main() {


    const contract = await ethers.deployContract("Hyperdust_Token", ["Hyperdust Token", "HYPT", process.env.ADMIN_Wallet_Address]);



    await contract.waitForDeployment()




    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
