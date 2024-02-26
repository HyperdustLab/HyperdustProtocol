/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Wallet_Account");
    const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);
    await instance.waitForDeployment();



    await (await instance.setContractAddress(
        ["0xfFeB583D2AAc8Faf258CA546DF65aa7A46ad3D2c",
            "0xF851B3cF1B482ce699FD6DcB329D713b6D55532c"])
    ).wait()


    console.info("contractFactory address:", instance.target);


}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
