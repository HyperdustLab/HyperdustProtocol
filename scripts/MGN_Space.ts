/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const accounts = await ethers.getSigners();

  const contractFactory = await ethers.getContractFactory("MGN_Space");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.setErc20Address("0x7a798E8eC045f911684dAa28B38a54b883b9523C")).wait();
  await (
    await contract.setDefParameter(
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/10/13e02181-24b5-4e41-8481-4d7bb4886619.jpg",
      "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/11/d073bdc7-8440-4479-9d84-8b357a0fe7cf.7z",
      "875c03eba7bd71e564ed657e9f6ed97132c230a1e5073422bb410624d0ac1766"
    )
  ).wait();

  await (await contract.setRoleAddress("0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837")).wait();

  await (await contract.setSpaceLocationAddress("0x24d30240883ac86c6d0b2475839aeDA38085B498")).wait();

  await (await contract.setSpaceNftAddress("0xeA1BAd6CDa7f314B687DFD247f2F80EF92a3BcbF")).wait();

  (await contract.setSpaceTypeAddress("0xfFeB583D2AAc8Faf258CA546DF65aa7A46ad3D2c")).wait();

  await (await contract.settlementAddress(accounts[0].getAddress())).wait();

  const MOSSAI_ERC_721 = await ethers.getContractAt("MOSSAI_ERC_721", "0xeA1BAd6CDa7f314B687DFD247f2F80EF92a3BcbF");

  await (await MOSSAI_ERC_721.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", contract.address)).wait();

  const MGN_Role = await ethers.getContractAt("MGN_Role", "0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837");

  await (
    await MGN_Role.addAdmin(contract.address)
  ).wait;

  console.info("contractFactory address:", contract.address);

  await run("verify:verify", {
    address: contract.address,
    contract: "contracts/MGN_Space.sol:MGN_Space",
    constructorArguments: [],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
