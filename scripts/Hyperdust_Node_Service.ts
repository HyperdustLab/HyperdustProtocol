/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_Node_Service");
    await contract.waitForDeployment()


    await (await contract.setContractAddress(['0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76', '0x9D88106Ba510D3852eC03B22b8F754F2bcd16739', '0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837', '0x61Ce9e4A31bFEe62e100Ef128f757EeE9012786f'])).wait()

    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
