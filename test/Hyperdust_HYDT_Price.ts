/** @format */

import { ethers } from "hardhat";

describe("Hyperdust_HYDT_Price", () => {
  describe("Hyperdust_HYDT_Price", () => {
    it("Hyperdust_HYDT_Price", async () => {


      const accounts = await ethers.getSigners();

      console.info(accounts)

      const contract = await ethers.deployContract("Hyperdust_Token", [[accounts[0].address, accounts[1].address, accounts[2].address]]);

      await contract.waitForDeployment()


      console.info(contract.timestamp)







    });
  });
});
