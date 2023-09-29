/** @format */

import { ethers, run } from "hardhat";

async function main() {

  const MGN_Space = await ethers.deployContract("MGN_Space");


  console.info("contractFactory address:", MGN_Space.target);

  await (
    await MGN_Space.setDefParameter(
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/10/13e02181-24b5-4e41-8481-4d7bb4886619.jpg",
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/11/d073bdc7-8440-4479-9d84-8b357a0fe7cf.7z",
      "875c03eba7bd71e564ed657e9f6ed97132c230a1e5073422bb410624d0ac1766"
    )
  ).wait();

  await (
    await MGN_Space.setContractAddress([
      "0x8e0f8f0137F289456322F912a145cC30485CEcBc",
      "0xa326b17ac88461FcFD64Ed397D6c0461162A1509",
      "0xE01cD4868425A35B76Ae2b71BA9EAA3a9976a5b3",
      "0x7BA3Ab23dc135AB3810676e4B83A7Ab73a20817f",
      "0x4241f24ce6ddebd073fe0c76bd5bc5da9c831728",
      "0x16baD1A2f89eE8fF6B6B9d5Fabc8f0ABB864B72f",
      "0x1238536071E1c677A632429e3655c799b22cDA52",
      "0x014e7d6A38A860B2B80379d0BF71a52A902c2E6c",
      "0x0cC7580A80BacD0E971315C27D0395904213fAc0",
      "0x436DA0Cd1DF15ACE39E69156170f3939183A69F6",
      "0x14C17FadB27A2a2CBD5E705Be2Ff1284B5dDe006",
      "0x5EED8bFb6049110814f04D581634b19699B314FC",
    ])
  ).wait();

  const MGN_721 = await ethers.getContractAt("MGN_721", "0xa326b17ac88461FcFD64Ed397D6c0461162A1509");

  await (await MGN_721.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", MGN_Space.target)).wait();

  const MGN_Role = await ethers.getContractAt("MGN_Roles_Cfg", "0x8e0f8f0137F289456322F912a145cC30485CEcBc");

  await (
    await MGN_Role.addAdmin(MGN_Space.target)
  ).wait;

  await (
    await MGN_Role.addSuperAdmin(MGN_Space.target)
  ).wait;

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
