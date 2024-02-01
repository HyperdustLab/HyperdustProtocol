/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




    const Hyperdust_BaseReward_Release = await ethers.getContractFactory("Hyperdust_BaseReward_Release");
    const upgraded = await upgrades.upgradeProxy("0x9c41D5d1Da6acd0f0033A9e5Bf7B0303a9c3280a", Hyperdust_BaseReward_Release);



    await (await upgraded.setContractAddress(
        ["0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
            "0x01778569225bA43FFDABF872607e1df2Bc83f102",
            "0xecc9Fc8e3ab9d7d54057cF2c330066c388F182CD"])
    ).wait()


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
