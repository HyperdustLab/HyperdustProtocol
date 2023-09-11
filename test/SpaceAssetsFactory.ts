/** @format */

import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("SpaceAssetsFactory", () => {
  describe("Add", () => {
    it("Test1", async () => {
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

      const SpaceAssetsFactory = await deployed("SpaceAssetsFactory");

      const tx = await (await SpaceAssetsFactory.deploy721(accounts[0].address, accounts[0].address)).wait();

      const logs = tx.logs;

      console.info(logs);
    });
  });
});
