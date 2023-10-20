/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Node_Mgr");
    await contract.waitForDeployment()


    await (await contract.setContractAddress(["0xba9b4229C58A7eD1De9eaa1773fEd064D8c8B88F", "0x46eF9f6b1036cBFbb174b4d1BEcc02Cd9C45058a", "0x5564555EB0a08255Cb2C3BA420860076435E2281"])).wait();


    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
