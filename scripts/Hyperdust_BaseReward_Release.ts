/** @format */

import { ethers, run } from "hardhat";

async function main() {
    const contract = await ethers.deployContract("Hyperdust_BaseReward_Release");
    await contract.waitForDeployment()

    await (await contract.setContractAddress([
        "0xd5A7E4eFb8Ae98aadE6d0078B3FeCf06c44c55Ae",
        "0x1a41f86248E33e5327B26092b898bDfe04C6d8b4"])).wait()


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
