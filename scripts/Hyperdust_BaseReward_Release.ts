/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_BaseReward_Release");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0x6C34AbF4632BC38e90f5016d784D3ED320Cfad14",
        "0x1CF7f55C216b28BC14Bf663d49D95d5F68446bed"])).wait()


    const Hyperdust_Render_Awards = await ethers.getContractAt("Hyperdust_Render_Awards", "0x4297BC40938a2ceeF67A19848A8eB0b7E2e63c8f")

    await (await Hyperdust_Render_Awards.setHyperdustBaseRewardRelease(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
