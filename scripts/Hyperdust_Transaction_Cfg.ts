/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Transaction_Cfg");
    const instance = await upgrades.deployProxy(contract);
    await instance.waitForDeployment();

    const implementationAddress = await upgrades.erc1967.getImplementationAddress(instance.target)

    console.info("implementationAddress:", implementationAddress);


    await (await instance.setContractAddress(["0x9bDaf3912e7b4794fE8aF2E748C35898265D5615", "0x5f9Fbd15284B56D50F8844F22a8838e65EB2Fc76"])).wait();
    await (await instance.add("render", 30000)).wait();
    await (await instance.add("mintNFT", 30000)).wait();

    //const Hyperdust_Render_Transcition = await ethers.getContractAt("Hyperdust_Render_Transcition", "0x5c28a0EF89e5e341c5C9a87aDF72EbEAB5B3a9d5")

    //await (await Hyperdust_Render_Transcition.setTransactionCfg(contract.target)).wait()



    console.info("contractFactory address:", instance.target);
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
