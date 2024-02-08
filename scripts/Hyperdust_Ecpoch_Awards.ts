/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Ecpoch_Awards");
    const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);
    await instance.waitForDeployment();



    // await (await instance.setContractAddress([
    //     "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615",
    //     "0x1e89b67D2075D4E1973B832203f12F5960C371E1",
    //     "0xa1011ae8964fEc89303EA37D95f3eCAFF5Ac7695",
    //     "0x9c41D5d1Da6acd0f0033A9e5Bf7B0303a9c3280a",
    //     "0x01778569225bA43FFDABF872607e1df2Bc83f102"
    // ])).wait()


    // const Hyperdust_Roles_Cfg = await ethers.getContractAt("Hyperdust_Roles_Cfg", "0x9bDaf3912e7b4794fE8aF2E748C35898265D5615")

    // await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
