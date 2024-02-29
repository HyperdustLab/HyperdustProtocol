/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Ecpoch_Awards_Simple");
    const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);
    await instance.waitForDeployment();



    await (await instance.setContractAddress([
        "0xfFeB583D2AAc8Faf258CA546DF65aa7A46ad3D2c",
        "0x213b5E4FF6B805dC5C9AF66B0e1f84A035Fa80D5"
    ])).wait()


    const Hyperdust_Roles_Cfg = await ethers.getContractAt("Hyperdust_Roles_Cfg", "0xfFeB583D2AAc8Faf258CA546DF65aa7A46ad3D2c")

    await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
