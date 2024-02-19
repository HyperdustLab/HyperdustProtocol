/** @format */

import { ethers, run, upgrades } from "hardhat";

async function main() {



    const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token", ["Hyperdust Token", "HYPT Test", "0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2"]);

    await Hyperdust_Token.waitForDeployment()

    console.info("Hyperdust_Token:", Hyperdust_Token.target)


    const _CORE_TEAM = await ethers.getContractFactory("Hyperdust_VestingWallet");
    const CORE_TEAM = await upgrades.deployProxy(_CORE_TEAM, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600, 3, 0, 12 * 4, ethers.keccak256(ethers.toUtf8Bytes("CORE_TEAM"))]);
    await CORE_TEAM.waitForDeployment();

    console.info("CORE_TEAM:", CORE_TEAM.target)



    const _FOUNDATION = await ethers.getContractFactory("Hyperdust_VestingWallet");
    const FOUNDATION = await upgrades.deployProxy(_FOUNDATION, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600, 1, 0, 12 * 4, ethers.keccak256(ethers.toUtf8Bytes("FOUNDATION"))]);
    await FOUNDATION.waitForDeployment();

    console.info("FOUNDATION:", FOUNDATION.target)



    const _ADVISOR = await ethers.getContractFactory("Hyperdust_VestingWallet");
    const ADVISOR = await upgrades.deployProxy(_ADVISOR, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600, 1, 0, 12, ethers.keccak256(ethers.toUtf8Bytes("ADVISOR"))]);
    await ADVISOR.waitForDeployment();

    console.info("ADVISOR:", ADVISOR.target)


    const _SEED = await ethers.getContractFactory("Hyperdust_VestingWallet");
    const SEED = await upgrades.deployProxy(_SEED, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600, 1, 500, 18, ethers.keccak256(ethers.toUtf8Bytes("SEED"))]);
    await SEED.waitForDeployment();


    console.info("SEED:", SEED.target)


    const _PRIVATE_SALE = await ethers.getContractFactory("Hyperdust_VestingWallet");
    const PRIVATE_SALE = await upgrades.deployProxy(_PRIVATE_SALE, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600, 1, 750, 12, ethers.keccak256(ethers.toUtf8Bytes("PRIVATE_SALE"))]);
    await PRIVATE_SALE.waitForDeployment();


    console.info("PRIVATE_SALE:", PRIVATE_SALE.target)


    const _PUBLIC_SALE = await ethers.getContractFactory("Hyperdust_VestingWallet");
    const PUBLIC_SALE = await upgrades.deployProxy(_PUBLIC_SALE, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600, 1, 2500, 9, ethers.keccak256(ethers.toUtf8Bytes("PUBLIC_SALE"))]);
    await PUBLIC_SALE.waitForDeployment();


    console.info("PUBLIC_SALE:", PUBLIC_SALE.target)



    const _AIRDROP = await ethers.getContractFactory("Hyperdust_VestingWallet");
    const AIRDROP = await upgrades.deployProxy(_AIRDROP, ["0xC619a8e80F485f5cCCb87041BAd2D2b0aCC843e2", 600, 6, 0, 12, ethers.keccak256(ethers.toUtf8Bytes("AIRDROP"))]);
    await AIRDROP.waitForDeployment();


    console.info("AIRDROP:", AIRDROP.target)



}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
