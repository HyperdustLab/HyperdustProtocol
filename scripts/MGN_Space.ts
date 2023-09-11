/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Space");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  console.info("contractFactory address:", contract.address);

  await (
    await contract.setDefParameter(
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/10/13e02181-24b5-4e41-8481-4d7bb4886619.jpg",
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/11/d073bdc7-8440-4479-9d84-8b357a0fe7cf.7z",
      "875c03eba7bd71e564ed657e9f6ed97132c230a1e5073422bb410624d0ac1766"
    )
  ).wait();

  await (
    await contract.setContractAddress([
      "0x57B938452f79959d59e843118C502D995eb1418B",
      "0x7ef19c984D9dEF9C212DfbbD9993d5793BE30bfD",
      "0x83750Fff55F1C0ff2DeD0138458Db16653221a8b",
      "0x92159806D22C4Ad0417EC913A91f00504d22Cf01",
      "0x7a798E8eC045f911684dAa28B38a54b883b9523C",
      "0x4f04AA8AB3230D15941e4Af09AB8479021bEa2FB",
      "0x1238536071E1c677A632429e3655c799b22cDA52",
      "0x419387c8843D29b0E085326710c495350DEA3d1D",
      "0xA402afb1bf561f3b545eb6ADeEbC221c96bDa573",
      "0xb577BD7a0E4BAD69952a5E916C91419eaaE1581f",
      "0x14C17FadB27A2a2CBD5E705Be2Ff1284B5dDe006",
      "0x5EED8bFb6049110814f04D581634b19699B314FC",
    ])
  ).wait();

  const MOSSAI_ERC_721 = await ethers.getContractAt("MGN_721", "0x7ef19c984D9dEF9C212DfbbD9993d5793BE30bfD");

  await (await MOSSAI_ERC_721.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", contract.address)).wait();

  const MGN_Role = await ethers.getContractAt("MGN_Roles_Cfg", "0x57B938452f79959d59e843118C502D995eb1418B");

  await (
    await MGN_Role.addAdmin(contract.address)
  ).wait;

  await (
    await MGN_Role.addSuperAdmin(contract.address)
  ).wait;

  setTimeout(async () => {
    await run("verify:verify", {
      address: contract.address,
      contract: "contracts/space/MGN_Space.sol:MGN_Space",
      constructorArguments: [],
    });
  }, 5000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
