/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const Hyperdust_Node_Mgr = await ethers.getContractFactory("Hyperdust_Node_Mgr");

    const upgraded = await upgrades.upgradeProxy("0x5f9Fbd15284B56D50F8844F22a8838e65EB2Fc76", Hyperdust_Node_Mgr);



    await (await upgraded.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x935194C28c933452A16C19f7972BF5B6F3Ac6193",
        "0x7BFF68a4BBE87dDf03Cd0a4833a84F8bC64244B5",
        "0x7b8AdBe81A47ef33122e9B8d4aAFa040DDa47c9C"
    ])).wait()


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
