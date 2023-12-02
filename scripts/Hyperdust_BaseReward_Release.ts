/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_BaseReward_Release");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14",
        "0x1CF7f55C216b28BC14Bf663d49D95d5F68446bed"])).wait()


    // const Hyperdust_Render_Awards = await ethers.getContractAt("Hyperdust_Render_Awards", "0xDa68b15D1FD6bb492440BdC194f8389379C8e205")

    // await (await Hyperdust_Render_Awards.setHyperdustBaseRewardRelease(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
