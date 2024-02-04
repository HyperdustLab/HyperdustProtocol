/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const Hyperdust_Security_Deposit = await ethers.getContractFactory("Hyperdust_Security_Deposit");

    const upgraded = await upgrades.upgradeProxy("0xa1011ae8964fEc89303EA37D95f3eCAFF5Ac7695", Hyperdust_Security_Deposit);



    await (await upgraded.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x01778569225bA43FFDABF872607e1df2Bc83f102",
        "0x76E78d6f4C650ceb11dcEfC9784a10DEE4731439",
        "0x1e89b67D2075D4E1973B832203f12F5960C371E1"
    ])).wait()


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
