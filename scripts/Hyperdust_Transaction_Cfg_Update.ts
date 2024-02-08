/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {


    const contract = await ethers.getContractFactory("Hyperdust_Transaction_Cfg");
    const upgraded = await upgrades.upgradeProxy("0x7C94D4145c2d2ad2712B496DF6C27EEA5E0252C2", contract);


    await (await upgraded.setContractAddress(["0x9bDaf3912e7b4794fE8aF2E748C35898265D5615", "0x1e89b67D2075D4E1973B832203f12F5960C371E1"])).wait();


    await (await upgraded.setMinGasFee("NFT_Market", ethers.parseEther("0.01"))).wait()
    await (await upgraded.setMinGasFee("mintIsland", ethers.parseEther("0.01"))).wait()
    await (await upgraded.setMinGasFee("mintNFT", ethers.parseEther("0.01"))).wait()
    await (await upgraded.setMinGasFee("ecpoch", ethers.parseEther("0.01"))).wait()

    await (await upgraded.add("ecpoch", 38000)).wait();
    // await (await upgraded.add("mintNFT", 38000)).wait();

}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
