/** @format */

import { ethers, run } from "hardhat";

import xlsx from "node-xlsx";

async function main() {
  const MGN_airdrop = await ethers.getContractAt("MGN_airdrop", "0x6ffab16322733cF8e0F695C2729e953e91d0cA2D");

  // await (await MGN_20.mint(accounts[0].address, ethers.utils.parseEther("100000000"))).wait();

  // await (await MGN_airdrop.setErc20Address(MGN_20.address)).wait();

  // await (await MGN_20.transfer(MGN_airdrop.address, ethers.utils.parseEther("4500"))).wait();

  const sheets = xlsx.parse("C:Users\\fym.DESKTOP-CPRJ4MQ\\Desktop\\1.xlsx");

  const sheet = sheets[0];

  const addressList = [];

  for (let i = 0; i < sheet.data.length; i++) {
    const row = sheet.data[i];

    if (i > 0) {
      if (row[0]) {
        addressList.push(row[0].trim());
        if (row[0].indexOf(" ") > 0) {
          console.info(row[0]);
        }
      }
    }
  }

  let pageNo = 4;

  let pageSize = 600;

  let i = 0;

  while (true) {
    console.info(i);
    if (pageNo * pageSize < addressList.length) {
      const array = addressList.slice(pageNo * pageSize, (pageNo + 1) * pageSize);
      i += array.length;
      pageNo++;

      await (await MGN_airdrop.airdrop(array, ethers.utils.parseEther("1"))).wait();
    } else {
      break;
    }
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
