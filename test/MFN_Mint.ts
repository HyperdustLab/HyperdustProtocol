/** @format */

import { ethers } from "hardhat";

describe("MFN_Mint", () => {
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

      const MGN_Mint_1 = await deployed("MGN_Mint");
      const MOSSAI_ERC_20_1 = await deployed("MOSSAI_ERC_20", "MGN", "MGN");
      const MGN_Role_1 = await deployed("MGN_Role");
      const MOSSAI_ERC_721_1 = await deployed("MOSSAI_ERC_721", "721", "721");
      const MOSSAI_ERC_1155_1 = await deployed("MOSSAI_1155_NFT", "1155", "1155");

      await (await MOSSAI_ERC_20_1.mint(accounts[0].address, 1000000000)).wait();

      await (await MOSSAI_ERC_20_1.approve(MGN_Mint_1.address, 1000000000)).wait();

      await (await MOSSAI_ERC_721_1.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", MGN_Mint_1.address)).wait();

      await (await MOSSAI_ERC_1155_1.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", MGN_Mint_1.address)).wait();

      await (await MGN_Mint_1.setRoleAddress(MGN_Role_1.address)).wait();

      await (await MGN_Mint_1.setErc20Address(MOSSAI_ERC_20_1.address)).wait();
      await (await MGN_Mint_1.setSettlementAddress(accounts[0].address)).wait();

      await (await MGN_Mint_1.addNFT("1", 10000, MOSSAI_ERC_721_1.address, 0, 1, 2)).wait();
      await (await MGN_Mint_1.addNFT("1", 10000, MOSSAI_ERC_1155_1.address, 1, 1, 1)).wait();

      const tx = await (await MGN_Mint_1.mint(1, 1)).wait();

      console.info(tx.events);
    });
  });
});
