/** @format */

import { ethers, network } from "hardhat";

const { expect } = require("chai");

import dayjs from 'dayjs'

import ExcelJS from 'exceljs'

import chai from 'chai';
import chaiAsPromised from 'chai-as-promised';

chai.use(chaiAsPromised);


describe("Hyperdust_Token", () => {







    const _monthTime = 30 * 24 * 60 * 60;
    const _yearTime = 365 * 24 * 60 * 60;



    // it("Contract initial deployment status test", async () => {


    //     const accounts = await ethers.getSigners();

    //     const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

    //     await contract.waitForDeployment()
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));
    //     expect(await contract._monthTime()).to.equal(BigInt(_monthTime));
    //     expect(await contract._yearTime()).to.equal(BigInt(_yearTime));
    //     expect(await contract.TGE_timestamp()).to.equal(BigInt(0));
    //     expect(await contract._mintNum()).to.equal(BigInt(0));
    //     expect(await contract._GPUMiningAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(0));
    //     expect(await contract._CoreTeamAddeess()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._CoreTeamTotalAward()).to.equal(BigInt(ethers.parseEther("23000000")));
    //     expect(await contract._CoreTeamCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._CoreTeamAllowReleaseTime()).to.equal(BigInt(0));
    //     expect(await contract._FoundationAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._FoundationTotalAward()).to.equal(BigInt(ethers.parseEther("20500000")));
    //     expect(await contract._FoundationCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._FoundationReleaseAllowReleaseTime()).to.equal(BigInt(0));
    //     expect(await contract._AdvisorAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._AdvisorAllowReleaseTime()).to.equal(BigInt(0));
    //     expect(await contract._AdvisorTotalAward()).to.equal(BigInt(ethers.parseEther("2000000")));
    //     expect(await contract._AdvisorCurrAward()).to.equal(BigInt(0));

    //     expect(await contract._SeedAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._SeedAllowReleaseTime()).to.equal(BigInt(0));
    //     expect(await contract._SeedTotalAward()).to.equal(BigInt(ethers.parseEther("2500000")));
    //     expect(await contract._SeedCurrAward()).to.equal(BigInt(0));

    //     expect(await contract._PrivateSaleAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._PrivateSaleCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._PrivateSaleTotalAward()).to.equal(BigInt(ethers.parseEther("6000000")));
    //     expect(await contract._PrivateSaleReleaseTime()).to.equal(BigInt(0));




    //     expect(await contract._PublicSaleAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._PublicSaleCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._PublicSaleTotalAward()).to.equal(BigInt(ethers.parseEther("6000000")));
    //     expect(await contract._PublicSaleReleaseTime()).to.equal(BigInt(0));




    //     expect(await contract._AirdropAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._AirdropCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._AirdropTotalAward()).to.equal(BigInt(ethers.parseEther("4000000")));
    //     expect(await contract._AirdropReleaseTime()).to.equal(BigInt(0));

    //     const privatePropertys = await contract.getPrivateProperty();


    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13600000"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(BigInt(0))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(0))//_lastGPUMiningRateTime
    //     expect(privatePropertys[7]).to.equal(BigInt(_monthTime))//_CoreTeamReleaseInterval
    //     expect(privatePropertys[8]).to.equal(ethers.parseEther("479166.666666666666666666"))//_CoreTeamMonthReleaseAward
    //     expect(privatePropertys[9]).to.equal(ethers.parseEther("479166.666666666666666666"))//_CoreTeamReleaseTotalAward
    //     expect(privatePropertys[10]).to.equal(BigInt(_monthTime))//_FoundationReleaseInterval
    //     expect(privatePropertys[11]).to.equal(ethers.parseEther("427083.333333333333333333"))//_FoundationReleaseTotalAward
    //     expect(privatePropertys[12]).to.equal(ethers.parseEther("427083.333333333333333333"))//_FoundationMonthReleaseAward
    //     expect(privatePropertys[13]).to.equal(BigInt(0))//_AdvisorCurrAward
    //     expect(privatePropertys[14]).to.equal(BigInt(_monthTime))//_AdvisorReleaseInterval
    //     expect(privatePropertys[15]).to.equal(ethers.parseEther("166666.666666666666666666"))//_AdvisorMonthReleaseAward
    //     expect(privatePropertys[16]).to.equal(ethers.parseEther("166666.666666666666666666"))//_AdvisorReleaseTotalAward
    //     expect(privatePropertys[17]).to.equal(BigInt(_monthTime))//_SeedReleaseInterval
    //     expect(privatePropertys[18]).to.equal(ethers.parseEther("125000"))//_SeedReleaseTotalAward
    //     expect(privatePropertys[19]).to.equal(BigInt(_monthTime))//_PrivateSaleReleaseInterval
    //     expect(privatePropertys[20]).to.equal(ethers.parseEther("450000"))//_PrivateSaleReleaseTotalAward
    //     expect(privatePropertys[21]).to.equal(ethers.parseEther("462500"))//_PrivateSaleMonthReleaseAward
    //     expect(privatePropertys[22]).to.equal(BigInt(_monthTime))//_PublicSaleReleaseInterval
    //     expect(privatePropertys[23]).to.equal(ethers.parseEther("1500000"))//_PublicSaleReleaseTotalAward
    //     expect(privatePropertys[24]).to.equal(ethers.parseEther("500000"))//_PublicSaleMonthReleaseAward
    //     expect(privatePropertys[25]).to.equal(BigInt(_monthTime))//_AirdropReleaseInterval
    //     expect(privatePropertys[26]).to.equal(ethers.parseEther("333333.333333333333333333"))//_AirdropReleaseMonthAward
    //     expect(privatePropertys[27]).to.equal(ethers.parseEther("333333.333333333333333333"))//_AirdropReleaseTotalAward
    //     expect(privatePropertys[28]).to.equal(ethers.parseEther("165.60121765601217656"))//_epochAward




    // });





    // it("TGE test after startup", async () => {


    //     const accounts = await ethers.getSigners();

    //     const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);
    //     await contract.waitForDeployment()

    //     // 获取最新的区块
    //     const latestBlock = await ethers.provider.getBlock('latest');

    //     // 从区块中获取时间戳
    //     const timestamp = latestBlock ? latestBlock.timestamp : 0;

    //     console.info(new Date(timestamp * 1000))

    //     await (await contract.startTGETimestamp()).wait()

    //     const TGE_timestamp = await contract.TGE_timestamp()

    //     const TGE_timestamp_int = parseInt(TGE_timestamp.toString());

    //     console.info(new Date(TGE_timestamp_int * 1000))

    //     expect(TGE_timestamp_int).to.be.at.least(Number(timestamp));



    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));
    //     expect(await contract._monthTime()).to.equal(BigInt(_monthTime));
    //     expect(await contract._yearTime()).to.equal(BigInt(_yearTime));
    //     expect(await contract._mintNum()).to.equal(BigInt(0));
    //     expect(await contract._GPUMiningAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));
    //     expect(await contract._CoreTeamAddeess()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._CoreTeamTotalAward()).to.equal(BigInt(ethers.parseEther("23000000")));
    //     expect(await contract._CoreTeamCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._CoreTeamAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + 3 * _monthTime));
    //     expect(await contract._FoundationAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._FoundationTotalAward()).to.equal(BigInt(ethers.parseEther("20500000")));
    //     expect(await contract._FoundationCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._FoundationReleaseAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + _monthTime));
    //     expect(await contract._AdvisorAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._AdvisorAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + _monthTime));
    //     expect(await contract._AdvisorTotalAward()).to.equal(BigInt(ethers.parseEther("2000000")));
    //     expect(await contract._AdvisorCurrAward()).to.equal(BigInt(0));

    //     expect(await contract._SeedAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._SeedAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));
    //     expect(await contract._SeedTotalAward()).to.equal(BigInt(ethers.parseEther("2500000")));
    //     expect(await contract._SeedCurrAward()).to.equal(BigInt(0));

    //     expect(await contract._PrivateSaleAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._PrivateSaleCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._PrivateSaleTotalAward()).to.equal(BigInt(ethers.parseEther("6000000")));
    //     expect(await contract._PrivateSaleReleaseTime()).to.equal(BigInt(TGE_timestamp_int));




    //     expect(await contract._PublicSaleAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._PublicSaleCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._PublicSaleTotalAward()).to.equal(BigInt(ethers.parseEther("6000000")));
    //     expect(await contract._PublicSaleReleaseTime()).to.equal(BigInt(TGE_timestamp_int));




    //     expect(await contract._AirdropAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._AirdropCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._AirdropTotalAward()).to.equal(BigInt(ethers.parseEther("4000000")));
    //     expect(await contract._AirdropReleaseTime()).to.equal(BigInt(TGE_timestamp_int + 6 * _monthTime));

    //     const privatePropertys = await contract.getPrivateProperty();


    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13600000"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(BigInt(0))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime
    //     expect(privatePropertys[7]).to.equal(BigInt(_monthTime))//_CoreTeamReleaseInterval
    //     expect(privatePropertys[8]).to.equal(ethers.parseEther("479166.666666666666666666"))//_CoreTeamMonthReleaseAward
    //     expect(privatePropertys[9]).to.equal(ethers.parseEther("479166.666666666666666666"))//_CoreTeamReleaseTotalAward
    //     expect(privatePropertys[10]).to.equal(BigInt(_monthTime))//_FoundationReleaseInterval
    //     expect(privatePropertys[11]).to.equal(ethers.parseEther("427083.333333333333333333"))//_FoundationReleaseTotalAward
    //     expect(privatePropertys[12]).to.equal(ethers.parseEther("427083.333333333333333333"))//_FoundationMonthReleaseAward
    //     expect(privatePropertys[13]).to.equal(BigInt(0))//_AdvisorCurrAward
    //     expect(privatePropertys[14]).to.equal(BigInt(_monthTime))//_AdvisorReleaseInterval
    //     expect(privatePropertys[15]).to.equal(ethers.parseEther("166666.666666666666666666"))//_AdvisorMonthReleaseAward
    //     expect(privatePropertys[16]).to.equal(ethers.parseEther("166666.666666666666666666"))//_AdvisorReleaseTotalAward
    //     expect(privatePropertys[17]).to.equal(BigInt(_monthTime))//_SeedReleaseInterval
    //     expect(privatePropertys[18]).to.equal(ethers.parseEther("125000"))//_SeedReleaseTotalAward
    //     expect(privatePropertys[19]).to.equal(BigInt(_monthTime))//_PrivateSaleReleaseInterval
    //     expect(privatePropertys[20]).to.equal(ethers.parseEther("450000"))//_PrivateSaleReleaseTotalAward
    //     expect(privatePropertys[21]).to.equal(ethers.parseEther("462500"))//_PrivateSaleMonthReleaseAward
    //     expect(privatePropertys[22]).to.equal(BigInt(_monthTime))//_PublicSaleReleaseInterval
    //     expect(privatePropertys[23]).to.equal(ethers.parseEther("1500000"))//_PublicSaleReleaseTotalAward
    //     expect(privatePropertys[24]).to.equal(ethers.parseEther("500000"))//_PublicSaleMonthReleaseAward
    //     expect(privatePropertys[25]).to.equal(BigInt(_monthTime))//_AirdropReleaseInterval
    //     expect(privatePropertys[26]).to.equal(ethers.parseEther("333333.333333333333333333"))//_AirdropReleaseMonthAward
    //     expect(privatePropertys[27]).to.equal(ethers.parseEther("333333.333333333333333333"))//_AirdropReleaseTotalAward
    //     expect(privatePropertys[28]).to.equal(ethers.parseEther("165.60121765601217656"))//_epochAward


    // });



    // it("TGE test after startup", async () => {


    //     const accounts = await ethers.getSigners();

    //     const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);
    //     await contract.waitForDeployment()

    //     // 获取最新的区块
    //     const latestBlock = await ethers.provider.getBlock('latest');

    //     // 从区块中获取时间戳
    //     const timestamp = latestBlock ? latestBlock.timestamp : 0;

    //     console.info(new Date(timestamp * 1000))

    //     await (await contract.startTGETimestamp()).wait()

    //     const TGE_timestamp = await contract.TGE_timestamp()

    //     const TGE_timestamp_int = parseInt(TGE_timestamp.toString());

    //     console.info(new Date(TGE_timestamp_int * 1000))

    //     expect(TGE_timestamp_int).to.be.at.least(Number(timestamp));



    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));
    //     expect(await contract._monthTime()).to.equal(BigInt(_monthTime));
    //     expect(await contract._yearTime()).to.equal(BigInt(_yearTime));
    //     expect(await contract._mintNum()).to.equal(BigInt(0));
    //     expect(await contract._GPUMiningAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));
    //     expect(await contract._CoreTeamAddeess()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._CoreTeamTotalAward()).to.equal(BigInt(ethers.parseEther("23000000")));
    //     expect(await contract._CoreTeamCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._CoreTeamAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + 3 * _monthTime));
    //     expect(await contract._FoundationAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._FoundationTotalAward()).to.equal(BigInt(ethers.parseEther("20500000")));
    //     expect(await contract._FoundationCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._FoundationReleaseAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + _monthTime));
    //     expect(await contract._AdvisorAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._AdvisorAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + _monthTime));
    //     expect(await contract._AdvisorTotalAward()).to.equal(BigInt(ethers.parseEther("2000000")));
    //     expect(await contract._AdvisorCurrAward()).to.equal(BigInt(0));

    //     expect(await contract._SeedAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._SeedAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));
    //     expect(await contract._SeedTotalAward()).to.equal(BigInt(ethers.parseEther("2500000")));
    //     expect(await contract._SeedCurrAward()).to.equal(BigInt(0));

    //     expect(await contract._PrivateSaleAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._PrivateSaleCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._PrivateSaleTotalAward()).to.equal(BigInt(ethers.parseEther("6000000")));
    //     expect(await contract._PrivateSaleReleaseTime()).to.equal(BigInt(TGE_timestamp_int));




    //     expect(await contract._PublicSaleAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._PublicSaleCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._PublicSaleTotalAward()).to.equal(BigInt(ethers.parseEther("6000000")));
    //     expect(await contract._PublicSaleReleaseTime()).to.equal(BigInt(TGE_timestamp_int));




    //     expect(await contract._AirdropAddress()).to.equal(ethers.ZeroAddress);
    //     expect(await contract._AirdropCurrAward()).to.equal(BigInt(0));
    //     expect(await contract._AirdropTotalAward()).to.equal(BigInt(ethers.parseEther("4000000")));
    //     expect(await contract._AirdropReleaseTime()).to.equal(BigInt(TGE_timestamp_int + 6 * _monthTime));

    //     const privatePropertys = await contract.getPrivateProperty();


    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13600000"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(BigInt(0))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime
    //     expect(privatePropertys[7]).to.equal(BigInt(_monthTime))//_CoreTeamReleaseInterval
    //     expect(privatePropertys[8]).to.equal(ethers.parseEther("479166.666666666666666666"))//_CoreTeamMonthReleaseAward
    //     expect(privatePropertys[9]).to.equal(ethers.parseEther("479166.666666666666666666"))//_CoreTeamReleaseTotalAward
    //     expect(privatePropertys[10]).to.equal(BigInt(_monthTime))//_FoundationReleaseInterval
    //     expect(privatePropertys[11]).to.equal(ethers.parseEther("427083.333333333333333333"))//_FoundationReleaseTotalAward
    //     expect(privatePropertys[12]).to.equal(ethers.parseEther("427083.333333333333333333"))//_FoundationMonthReleaseAward
    //     expect(privatePropertys[13]).to.equal(BigInt(0))//_AdvisorCurrAward
    //     expect(privatePropertys[14]).to.equal(BigInt(_monthTime))//_AdvisorReleaseInterval
    //     expect(privatePropertys[15]).to.equal(ethers.parseEther("166666.666666666666666666"))//_AdvisorMonthReleaseAward
    //     expect(privatePropertys[16]).to.equal(ethers.parseEther("166666.666666666666666666"))//_AdvisorReleaseTotalAward
    //     expect(privatePropertys[17]).to.equal(BigInt(_monthTime))//_SeedReleaseInterval
    //     expect(privatePropertys[18]).to.equal(ethers.parseEther("125000"))//_SeedReleaseTotalAward
    //     expect(privatePropertys[19]).to.equal(BigInt(_monthTime))//_PrivateSaleReleaseInterval
    //     expect(privatePropertys[20]).to.equal(ethers.parseEther("450000"))//_PrivateSaleReleaseTotalAward
    //     expect(privatePropertys[21]).to.equal(ethers.parseEther("462500"))//_PrivateSaleMonthReleaseAward
    //     expect(privatePropertys[22]).to.equal(BigInt(_monthTime))//_PublicSaleReleaseInterval
    //     expect(privatePropertys[23]).to.equal(ethers.parseEther("1500000"))//_PublicSaleReleaseTotalAward
    //     expect(privatePropertys[24]).to.equal(ethers.parseEther("500000"))//_PublicSaleMonthReleaseAward
    //     expect(privatePropertys[25]).to.equal(BigInt(_monthTime))//_AirdropReleaseInterval
    //     expect(privatePropertys[26]).to.equal(ethers.parseEther("333333.333333333333333333"))//_AirdropReleaseMonthAward
    //     expect(privatePropertys[27]).to.equal(ethers.parseEther("333333.333333333333333333"))//_AirdropReleaseTotalAward
    //     expect(privatePropertys[28]).to.equal(ethers.parseEther("165.60121765601217656"))//_epochAward


    // });






    // it("GPUMining Mint Test", async () => {


    //     const accounts = await ethers.getSigners();

    //     const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);
    //     await contract.waitForDeployment()


    //     // 获取最新的区块
    //     let latestBlock = await ethers.provider.getBlock('latest');

    //     // 从区块中获取时间戳
    //     let timestamp = latestBlock ? latestBlock.timestamp : 0;

    //     console.info(new Date(timestamp * 1000))

    //     await (await contract.startTGETimestamp()).wait()

    //     const TGE_timestamp = await contract.TGE_timestamp()

    //     const TGE_timestamp_int = parseInt(TGE_timestamp.toString());

    //     await (await contract.setGPUMiningAddress(accounts[0].address)).wait()

    //     let GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();

    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("13600000"))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("13600000"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("165.60121765601217656"))

    //     await expect(
    //         contract.GPUMiningMint(ethers.parseEther("166.60121765601217656")).then((tx) => tx.wait())
    //     ).to.be.rejected;




    //     //First Mint

    //     await (await contract.GPUMiningMint(ethers.parseEther("1"))).wait()


    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();
    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("13599999"))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("13600000"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("165.60121765601217656"))



    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(ethers.parseEther("1"));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));


    //     let privatePropertys = await contract.getPrivateProperty();
    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13600000"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(ethers.parseEther("1"))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("1"));
    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));






    //     //Six months later

    //     await network.provider.send("evm_increaseTime", [_monthTime * 6]);
    //     await network.provider.send("evm_mine");



    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();
    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("13599999"))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("13600000"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("165.60121765601217656"))



    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(ethers.parseEther("1"));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));


    //     privatePropertys = await contract.getPrivateProperty();
    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13600000"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(ethers.parseEther("1"))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("1"));
    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));




    //     //Mint again six months later


    //     await (await contract.GPUMiningMint(ethers.parseEther("1"))).wait()


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("2"));

    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));



    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();
    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("13599998"))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("13600000"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("165.60121765601217656"))



    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(ethers.parseEther("2"));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));


    //     privatePropertys = await contract.getPrivateProperty();
    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13600000"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(ethers.parseEther("2"))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("2"));
    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));


    //     //1 year later

    //     await network.provider.send("evm_increaseTime", [_monthTime * 6 + 5 * 24 * 60 * 60]);
    //     await network.provider.send("evm_mine");


    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();



    //     //13599999.8 = (136000000-2)/10%

    //     // console.info(ethers.formatEther(GPUMiningCurrAllowMintTotalNum[2]))


    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther(("13599999.8")))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("13599999.8"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("165.601215220700152207"))



    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(ethers.parseEther("2"));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int));


    //     privatePropertys = await contract.getPrivateProperty();
    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13600000"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(ethers.parseEther("2"))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("2"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));



    //     //Mint 1 year later


    //     await (await contract.GPUMiningMint(ethers.parseEther("1"))).wait()


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("3"));

    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));



    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();
    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("13599998.8"))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("13599999.8"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("165.601215220700152207"))



    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(ethers.parseEther("3"));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + _yearTime));


    //     privatePropertys = await contract.getPrivateProperty();
    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13599999.8"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(ethers.parseEther("1"))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("3"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));


    //     //4 year later

    //     await network.provider.send("evm_increaseTime", [_yearTime * 3]);
    //     await network.provider.send("evm_mine");


    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();


    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther(("6799999.85")))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("6799999.85"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("82.800607001522070015"))



    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(ethers.parseEther("3"));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt(TGE_timestamp_int + _yearTime));


    //     privatePropertys = await contract.getPrivateProperty();
    //     expect(privatePropertys[0]).to.equal(BigInt(100000))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("13599999.8"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(ethers.parseEther("1"))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int))//_lastGPUMiningRateTime


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("3"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));


    //     //Mint 4 year later

    //     //6799999850000000000000000
    //     //6799999850000000000000000


    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();


    //     await (await contract.GPUMiningMint(ethers.parseEther("1"))).wait()

    //     GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();


    //     console.info(

    //         ethers.formatEther(GPUMiningCurrAllowMintTotalNum[0]),
    //         ethers.formatEther(GPUMiningCurrAllowMintTotalNum[1]),
    //         ethers.formatEther(GPUMiningCurrAllowMintTotalNum[2])
    //     )




    //     expect(GPUMiningCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther(("6799999.8")))
    //     expect(GPUMiningCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("6799999.8"))
    //     expect(GPUMiningCurrAllowMintTotalNum[2]).to.equal(ethers.parseEther("82.800606392694063926"))

    //     expect(await contract._GPUMiningTotalAward()).to.equal(ethers.parseEther("136000000"));
    //     expect(await contract._GPUMiningCurrAward()).to.equal(ethers.parseEther("4"));
    //     expect(await contract._GPUMiningAllowReleaseTime()).to.equal(BigInt((TGE_timestamp_int + 2 * _yearTime)));


    //     privatePropertys = await contract.getPrivateProperty();
    //     expect(privatePropertys[0]).to.equal(BigInt(100000 / 2))//_GPUMiningCurrMiningRatio
    //     expect(privatePropertys[1]).to.equal(BigInt(100000 * 10))//_GPUMiningTotalMiningRatio
    //     expect(privatePropertys[2]).to.equal(ethers.parseEther("6799999.85"))//_GPUMiningCurrYearTotalSupply
    //     expect(privatePropertys[3]).to.equal(ethers.parseEther("1"))//_GPUMiningCurrYearTotalAward
    //     expect(privatePropertys[4]).to.equal(BigInt(_yearTime))//_GPUMiningReleaseInterval
    //     expect(privatePropertys[5]).to.equal(BigInt(4 * _yearTime))//_GPUMiningRateInterval
    //     expect(privatePropertys[6]).to.equal(BigInt(TGE_timestamp_int + 4 * _yearTime))//_lastGPUMiningRateTime


    //     expect(await contract._mintNum()).to.equal(ethers.parseEther("4"));
    //     expect(await contract.totalSupply()).to.equal(ethers.parseEther("200000000"));


    // });






    it("GPUMining Mint Recursive halving test", async () => {




        const accounts = await ethers.getSigners();

        const contract = await ethers.deployContract("Hyperdust_Token", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);
        await contract.waitForDeployment()

        await (await contract.startTGETimestamp()).wait()

        const TGE_timestamp = await contract.TGE_timestamp()
        console.info("TGE_timestamp:", TGE_timestamp)
        await (await contract.setGPUMiningAddress(accounts[0].address)).wait()


        const _GPUMiningTotalAward = await contract._GPUMiningTotalAward();


        // 创建一个新的工作簿
        let workbook = new ExcelJS.Workbook();

        // 添加一个新的工作表
        let worksheet = workbook.addWorksheet('My Sheet');


        worksheet.addRow(['Mint时间', 'Mint金额', 'Epoch金额', '释放比例', "允许释放时间", "年度", "上次比例减半释放时间", "年度可释放金额", "年度总计可释放金额", "总计金额", "已释放金额"]);




        for (let i = 1; i <= 21; i++) {


            const privateProperty = await contract.getPrivateProperty();




            const list = [];

            let latestBlock = await ethers.provider.getBlock('latest');
            // 从区块中获取时间戳
            let timestamp = latestBlock ? latestBlock.timestamp : 0;

            const createDate = dayjs.unix(parseInt(timestamp.toString())).format("YYYY-MM-DD HH:mm:ss");


            const GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();


            const _epochAward = GPUMiningCurrAllowMintTotalNum[2];


            const _GPUMiningCurrAward = await contract._GPUMiningCurrAward();

            const mintNum = ethers.formatEther(GPUMiningCurrAllowMintTotalNum[0])

            await (await contract.GPUMiningMint(ethers.parseEther((parseFloat(mintNum) * 0.8).toString()))).wait();

            const GPUMiningCurrMiningRatio = await contract.getGPUMiningCurrMiningRatio();
            const _GPUMiningAllowReleaseTime = await contract._GPUMiningAllowReleaseTime();


            list.push(createDate);
            list.push(parseFloat(mintNum) * 0.8);
            list.push(ethers.formatEther(_epochAward));
            list.push((parseInt(GPUMiningCurrMiningRatio) / 100000000));
            list.push(dayjs.unix(parseInt(_GPUMiningAllowReleaseTime.toString())).format("YYYY-MM-DD HH:mm:ss"));
            list.push(i);
            list.push(dayjs.unix(parseInt(privateProperty[6].toString())).format("YYYY-MM-DD HH:mm:ss"));
            list.push(ethers.formatEther(GPUMiningCurrAllowMintTotalNum[0]));
            list.push(ethers.formatEther(GPUMiningCurrAllowMintTotalNum[1]));
            list.push(ethers.formatEther(_GPUMiningTotalAward));
            list.push(ethers.formatEther(_GPUMiningCurrAward));

            worksheet.addRow(list);

            await network.provider.send("evm_increaseTime", [_yearTime]);
            await network.provider.send("evm_mine");

            console.info(i);

            console.info(list)




        }
        // 写入Excel文件
        await workbook.xlsx.writeFile(`D:\\file\\Hyperdust.xlsx`);








    })






















    // it("GPUMining Mint Recursive halving test", async () => {



    //     const accounts = await ethers.getSigners();

    //     const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);
    //     await contract.waitForDeployment()




    //     await (await contract.startTGETimestamp()).wait()

    //     const TGE_timestamp = await contract.TGE_timestamp()
    //     console.info("TGE_timestamp:", TGE_timestamp)


    //     const TGE_timestamp_int = parseInt(TGE_timestamp.toString());

    //     await (await contract.setGPUMiningAddress(accounts[0].address)).wait()



    //     await network.provider.send("evm_increaseTime", [_yearTime * 16]);
    //     await network.provider.send("evm_mine");


    //     // 获取最新的区块
    //     let latestBlock = await ethers.provider.getBlock('latest');

    //     // 从区块中获取时间戳
    //     let timestamp = latestBlock ? latestBlock.timestamp : 0;

    //     console.info("timestamp:", timestamp)


    //     for (let i = 0; i < 4; i++) {

    //         await (await contract.GPUMiningMint(ethers.parseEther("1"))).wait()


    //         const privatePropertys = await contract.getPrivateProperty();



    //         console.info(privatePropertys[0])
    //         console.info(ethers.formatEther(privatePropertys[2]))
    //         console.info(ethers.formatEther(privatePropertys[3]))


    //         const GPUMiningTotalAward = await contract._GPUMiningTotalAward();

    //         console.info("GPUMiningTotalAward:", ethers.formatEther(GPUMiningTotalAward))


    //         const _GPUMiningAllowReleaseTime = await contract._GPUMiningAllowReleaseTime()

    //         console.info("_GPUMiningAllowReleaseTime:", _GPUMiningAllowReleaseTime)

    //         const GPUMiningCurrAllowMintTotalNum = await contract.getGPUMiningCurrAllowMintTotalNum();

    //         console.info(

    //             ethers.formatEther(GPUMiningCurrAllowMintTotalNum[0]),
    //             ethers.formatEther(GPUMiningCurrAllowMintTotalNum[1]),
    //             ethers.formatEther(GPUMiningCurrAllowMintTotalNum[2])
    //         )

    //     }
    // })



    // it("Foundation Mint Test", async () => {


    //     const accounts = await ethers.getSigners();

    //     const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);
    //     await contract.waitForDeployment()

    //     await (await contract.startTGETimestamp()).wait();

    //     await (await contract.setFoundationAddress(accounts[0].address)).wait()


    //     let FoundationCurrAllowMintTotalNum = await contract.getFoundationCurrAllowMintTotalNum();

    //     expect(FoundationCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("0"))
    //     expect(FoundationCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("0"))


    //     await network.provider.send("evm_increaseTime", [_monthTime * 1]);
    //     await network.provider.send("evm_mine");




    //     FoundationCurrAllowMintTotalNum = await contract.getFoundationCurrAllowMintTotalNum();


    //     expect(FoundationCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("427083.333333333333333333"))
    //     expect(FoundationCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("427083.333333333333333333"))

    //     await (await contract.mint()).wait();


    //     FoundationCurrAllowMintTotalNum = await contract.getFoundationCurrAllowMintTotalNum();


    //     expect(FoundationCurrAllowMintTotalNum[0]).to.equal(ethers.parseEther("0"))
    //     expect(FoundationCurrAllowMintTotalNum[1]).to.equal(ethers.parseEther("427083.333333333333333333"))


    //     await network.provider.send("evm_increaseTime", [_monthTime * 2]);
    //     await network.provider.send("evm_mine");





    // })





    // it("Contract initial deployment status test", async () => {


    //     const accounts = await ethers.getSigners();

    //     const contract = await ethers.deployContract("Hyperdust_Token_Test", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

    //     await contract.waitForDeployment()

    //     await (await contract.startTGETimestamp()).wait();
    //     await (await contract.setAirdropAddress(accounts[0].address)).wait();

    //     const a = await contract.getPrivateProperty()

    //     await network.provider.send("evm_increaseTime", [600 * 100]);
    //     await network.provider.send("evm_mine");


    //     let airdropCurrAllowMintTotalNum = await contract.getAirdropCurrAllowMintTotalNum();

    //     console.info(
    //         ethers.formatEther(airdropCurrAllowMintTotalNum[0].toString()),
    //         ethers.formatEther(airdropCurrAllowMintTotalNum[1].toString())
    //     )


    //     let AirdropReleaseTime = await contract._AirdropReleaseTime();
    //     console.info(AirdropReleaseTime)

    //     await (await contract.mint()).wait()

    //     AirdropReleaseTime = await contract._AirdropReleaseTime();

    //     console.info(AirdropReleaseTime)


    //     airdropCurrAllowMintTotalNum = await contract.getAirdropCurrAllowMintTotalNum();

    //     console.info(
    //         ethers.formatEther(airdropCurrAllowMintTotalNum[0].toString()),
    //         ethers.formatEther(airdropCurrAllowMintTotalNum[1].toString())
    //     )



    // });



    it("Contract initial deployment status test", async () => {



        // const accounts = await ethers.getSigners();

        // const contract = await ethers.deployContract("Hyperdust_Token", ["Hyperdust Private Token Test", "HYPT test", accounts[0].address]);

        // await contract.waitForDeployment()

        // await (await contract.startTGETimestamp()).wait();
        // await (await contract.setAdvisorAddress(accounts[0].address)).wait();



        // for (let i = 0; i < 3; i++) {



        //     await network.provider.send("evm_increaseTime", [_monthTime]);
        //     await network.provider.send("evm_mine")

        //     await (await contract.mint()).wait();

        //     const a = await contract.getAdvisorCurrAllowMintTotalNum();

        //     if (parseInt(a[0].toString()) > 0) {
        //         await (await contract.mint(a[0])).wait()
        //     }


        //     console.info(ethers.formatEther(a[0]), ethers.formatEther(a[1]))
        // }







        // const Hyperdust_Token_Test = await ethers.getContractAt("Hyperdust_Token_Test", "0xA86323d2aF197c95933119603b5533d110d86403");

        // const a = await Hyperdust_Token_Test.getPrivateProperty();

        // console.info(a[25], a[26], a[27])



    })


});
