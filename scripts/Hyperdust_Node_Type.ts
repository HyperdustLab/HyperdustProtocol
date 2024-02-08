/** @format */
import { ethers, run, upgrades } from "hardhat";

async function main() {


    const Hyperdust_Storage = await ethers.deployContract("Hyperdust_Storage", [process.env.ADMIN_Wallet_Address]);
    await Hyperdust_Storage.waitForDeployment()



    const contract = await ethers.getContractFactory("Hyperdust_Node_Type");
    const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address]);
    await instance.waitForDeployment();

    // await (await Hyperdust_Storage.setServiceAddress(instance.target)).wait()

    // await (await instance.setRolesCfgAddress("0x9bDaf3912e7b4794fE8aF2E748C35898265D5615")).wait()
    // await (await instance.setHyperdustStorageAddress(Hyperdust_Storage.target)).wait()


    console.info("Hyperdust_Storage:", Hyperdust_Storage.target)

    console.info("contractFactory address:", instance.target);






}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
