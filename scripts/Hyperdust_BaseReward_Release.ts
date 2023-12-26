/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_BaseReward_Release");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0x3cc42e32ea76016CED99b98DEc0FD8D541Dc3B76",
        "0x01778569225bA43FFDABF872607e1df2Bc83f102"])).wait()


    const Hyperdust_Render_Awards = await ethers.getContractAt("Hyperdust_Render_Awards", "0xb7EEA03dcc393f69fD277C0fFB0EE233f2488F47")

    await (await Hyperdust_Render_Awards.setHyperdustBaseRewardRelease(contract.target)).wait()



    console.info("contractFactory address:", contract.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
