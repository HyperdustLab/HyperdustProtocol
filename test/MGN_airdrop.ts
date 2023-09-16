/** @format */

import { ethers } from "hardhat";

describe("MGN_Airdrop", () => {
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
      const MGN_Airdrop = await deployed("MGN_Airdrop", null, null);
      const MGN_Roles_Cfg = await deployed("MGN_Roles_Cfg", null, null);

      await (await MGN_20.mint(accounts[0].address, ethers.utils.parseEther("10"))).wait();
      await (await MGN_20.approve(MGN_Airdrop.address, ethers.utils.parseEther("10"))).wait();
      await (await MGN_Airdrop.setErc20Address(MGN_20.address)).wait();
      await (await MGN_Airdrop.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_Airdrop.setSumAirdrop(ethers.utils.parseEther("10"))).wait();

      await (await MGN_Airdrop.airdrop(accounts[1].address, ethers.utils.parseEther("1"))).wait();
      const remainingAirdropQuantity = await MGN_Airdrop.getRemainingAirdropQuantity();

      console.info(ethers.utils.formatEther(remainingAirdropQuantity.toString()));
    });
  });
});
