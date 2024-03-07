/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {




    const Hyperdust_Storage = await ethers.deployContract("Hyperdust_Storage", [process.env.ADMIN_Wallet_Address]);
    await Hyperdust_Storage.waitForDeployment()



    const contract = await ethers.getContractFactory("Hyperdust_Epoch_Transcition");
    const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);
    await instance.waitForDeployment();


    console.info("Hyperdust_Storage:", Hyperdust_Storage.target)


    await (await instance.setContractAddress([
        "0xfFeB583D2AAc8Faf258CA546DF65aa7A46ad3D2c",
        "0x9D88106Ba510D3852eC03B22b8F754F2bcd16739",
        "0x213b5E4FF6B805dC5C9AF66B0e1f84A035Fa80D5",
        "0x6599575D2e350786f9D93C2342f7115708b46552",
        "0x5D0e4fc84737F24da06B2b567E716806b27B2e3B",
        Hyperdust_Storage.target
    ])).wait()



    await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

    const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0xfFeB583D2AAc8Faf258CA546DF65aa7A46ad3D2c')
    await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()




    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
