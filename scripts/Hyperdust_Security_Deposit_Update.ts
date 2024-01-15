/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const Hyperdust_Node_Mgr = await ethers.getContractFactory("Hyperdust_Node_Mgr");

    const upgraded = await upgrades.upgradeProxy("0x1e89b67D2075D4E1973B832203f12F5960C371E1", Hyperdust_Node_Mgr);



    await (await upgraded.setContractAddress([
        "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
        "0x6B9138b310A243ac7eCB306BDf108Fb2413dF2B6",
        "0x294d309282F5c9Ef061eD83E4A5bC7102FB3AeE6",
        "0xc0a8d6F65BB77031eC63E55902D5c4907148aE83"
    ])).wait()


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
