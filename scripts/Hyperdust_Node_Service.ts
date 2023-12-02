/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Node_Service");
    await contract.waitForDeployment()


    await (await contract.setContractAddress(['0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14', '0xBa11806745b9f689b877492684300eB41e6d71af', '0xB93Bd6cde4CE29ED5F76B5B0c2e092569E966503', '0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f'])).wait()

    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
