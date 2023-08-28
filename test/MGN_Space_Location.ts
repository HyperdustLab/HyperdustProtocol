/** @format */

import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Space_Location", () => {
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

      const MGN_Role = await deployed("MGN_Role");

      const MGN_Space_Location = await deployed("MGN_Space_Location");

      await (await MGN_Space_Location.setRoleAddress(MGN_Role.address)).wait();

      await (await MGN_Space_Location.add([1, 1], [1, 2])).wait();
      await (await MGN_Space_Location.del([1])).wait();

      const tx = await (await MGN_Space_Location.getSpaceLocation(1)).wait();

      console.info(tx);
    });
  });
});
