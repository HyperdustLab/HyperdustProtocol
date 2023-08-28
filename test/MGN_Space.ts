/** @format */

import { time, loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Space", () => {
  describe("Add", () => {
    it("Test1", async () => {
      const deployed = async (name, parameter1, parameter2) => {
        const contractFactory = await ethers.getContractFactory(name);

        let factory = null;

        console.info(parameter1, parameter2);

        if (parameter1 && parameter2) {
          factory = await contractFactory.deploy(parameter1, parameter2);
        } else {
          factory = await contractFactory.deploy();
        }

        const contract = await factory.deployed();

        return contract;
      };

      const accounts = await ethers.getSigners();

      const MOSSAI_ERC_20 = await deployed("MOSSAI_ERC_20", "MGN", "MGN");
      const MGN_Role = await deployed("MGN_Role");
      const MOSSAI_ERC_721 = await deployed("MOSSAI_ERC_721", "721", "721");
      const MGN_Space = await deployed("MGN_Space");
      const MGN_Space_Type = await deployed("MGN_Space_Type");
      const MGN_Space_Location = await deployed("MGN_Space_Location");

      await (await MGN_Space_Type.add(1, "test", "1", "1", 100, 100, 100)).wait();

      await (await MGN_Space_Type.add(1, "test", "1", "1", 100, 100, 100)).wait();
      await (await MGN_Space_Location.add([1], [1])).wait();

      await (await MOSSAI_ERC_20.mint(accounts[0].address, 1000000000)).wait();

      await (await MOSSAI_ERC_20.approve(MGN_Space.address, 1000000000)).wait();

      await (await MOSSAI_ERC_721.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", MGN_Space.address)).wait();

      await (await MGN_Space.setRoleAddress(MGN_Role.address)).wait();
      await (await MGN_Space.setSpaceNftAddress(MOSSAI_ERC_20.address)).wait();
      await (await MGN_Space.setSpaceLocationAddress(MGN_Space_Location.address)).wait();
      await (await MGN_Space.setSpaceTypeAddress(MGN_Space_Type.address)).wait();
      await (await MGN_Space.settlementAddress(accounts[0])).wait();
    });
  });
});
