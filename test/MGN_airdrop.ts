/** @format */

import { ethers } from "hardhat";

import xlsx from "node-xlsx";

describe("MGN_airdrop", () => {
  describe("Add", () => {
    it("Test Add", async () => {
      const deployed = async (name, parameter1, parameter2) => {
        const contractFactory = await ethers.getContractFactory(name);

        let factory = null;

        if (parameter1 && parameter2) {
          factory = await contractFactory.deploy(parameter1, parameter2);
        } else {
          factory = await contractFactory.deploy();
        }

        const contract = await factory.deployed();

        return contract;
      };

      const accounts = await ethers.getSigners();

      const MGN_20 = await deployed("MGN_20", "MGN", "MGN");
      // const MGN_airdrop = await deployed("MGN_airdrop");

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

      let pageNo = 0;

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

      // sheet.data.forEach((row) => {
      //   console.log(row);
      // });

      // const addressList = [];

      // for (let i = 0; i < 600; i++) {
      //   addressList.push(accounts[1].address);
      // }

      // const tx = await (await MGN_airdrop.airdrop(addressList, ethers.utils.parseEther("1"))).wait();

      // const b = await MGN_20.balanceOf(accounts[1].address);

      // console.info(ethers.utils.formatEther(b));
    });
  });
});
