/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const MGN_Space = await ethers.getContractAt("MGN_Space", "0xA3Ef2A67f40601ca2FE781FFFEb3Cd193a50aaEb");

  // await (
  //   await MGN_Space.setDefParameter(
  //     "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/10/13e02181-24b5-4e41-8481-4d7bb4886619.jpg",
  //     "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/11/d073bdc7-8440-4479-9d84-8b357a0fe7cf.7z",
  //     "875c03eba7bd71e564ed657e9f6ed97132c230a1e5073422bb410624d0ac1766"
  //   )
  // ).wait();

  // await (
  //   await MGN_Space.setContractAddress([
  //     "0x57B938452f79959d59e843118C502D995eb1418B",
  //     "0x7ef19c984D9dEF9C212DfbbD9993d5793BE30bfD",
  //     "0x83750Fff55F1C0ff2DeD0138458Db16653221a8b",
  //     "0x9DcC0Da86B85291333C96C4d098E050b519e3870",
  //     "0x7a798E8eC045f911684dAa28B38a54b883b9523C",
  //     "0x4f04AA8AB3230D15941e4Af09AB8479021bEa2FB",
  //     "0x1238536071E1c677A632429e3655c799b22cDA52",
  //     "0x419387c8843D29b0E085326710c495350DEA3d1D",
  //     "0xA402afb1bf561f3b545eb6ADeEbC221c96bDa573",
  //     "0xb577BD7a0E4BAD69952a5E916C91419eaaE1581f",
  //     "0x14C17FadB27A2a2CBD5E705Be2Ff1284B5dDe006",
  //     "0x5EED8bFb6049110814f04D581634b19699B314FC",
  //   ])
  // ).wait();

  // const MOSSAI_ERC_721 = await ethers.getContractAt("MGN_721", "0x7ef19c984D9dEF9C212DfbbD9993d5793BE30bfD");

  // await (await MOSSAI_ERC_721.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", MGN_Space.address)).wait();

  // const MGN_Role = await ethers.getContractAt("MGN_Roles_Cfg", "0x57B938452f79959d59e843118C502D995eb1418B");

  // await (
  //   await MGN_Role.addAdmin(MGN_Space.address)
  // ).wait;

  // await (
  //   await MGN_Role.addSuperAdmin(MGN_Space.address)
  // ).wait;

  await (
    await MGN_Space.putSpaceNFTTokenURI(1, [
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/9/8/e3415b99-4b3a-4364-864b-fbb8ecc89dd3.json",
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/9/8/8a51eec7-b508-43d9-8035-89afe2012e4d.json",
    ])
  ).wait();

  // await run("verify:verify", {
  //   address: Space_721.address,
  //   contract: "contracts/spaceAssets/Space_1155.sol:Space_1155",
  //   constructorArguments: ["0xb577BD7a0E4BAD69952a5E916C91419eaaE1581f"],
  // });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
