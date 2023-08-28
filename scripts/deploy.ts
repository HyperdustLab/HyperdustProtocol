
import { ethers } from "hardhat";

async function main() {



  const contractFactory = await ethers.getContractFactory("MGN_Space");

  const factory = await contractFactory.deploy();
  await factory.deployed();

  console.log("contractFactory address:", factory.address);


  const provider = new ethers.BrowserProvider(window.ethereum);

  const signer = await provider.getSigner();





}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
