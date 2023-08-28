/** @format */

import { ethers, run } from "hardhat";

async function main() {
  const contractFactory = await ethers.getContractFactory("MGN_Miner_Node");

  const factory = await contractFactory.deploy();
  const contract = await factory.deployed();
  await contract.deployed();

  await (await contract.setRoleAddress("0x6357bDa1F1dE5e94Bd5f7E379F4737580e775837")).wait();
  await (await contract.setResourceTypeAddress("0xfFeB583D2AAc8Faf258CA546DF65aa7A46ad3D2c")).wait();
  await (await contract.setMinerNodeCheckAddress("0x6599575D2e350786f9D93C2342f7115708b46552")).wait();

  await run("verify:verify", {
    address: contract.address,
    contract: "contracts/MGN_Miner_Node.sol:MGN_Miner_Node",
    constructorArguments: [],
  });

  console.info("contractFactory address:", contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
