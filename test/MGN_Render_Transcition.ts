/** @format */

import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Render_Transcition", () => {
  describe("MGN_Render_Transcition", () => {
    it("settlementOrder", async () => {
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

      const MGN_Roles_Cfg = await deployed("MGN_Roles_Cfg");
      const MGN_Render_Transcition = await deployed("MGN_Render_Transcition");
      const MGN_Node_Mgr = await deployed("MGN_Node_Mgr");
      const MGN_Node_Type = await deployed("MGN_Node_Type");
      const MGN_20 = await deployed("MGN_20", "MGN", "MGN");
      const MGN_Node_CheckIn = await deployed("MGN_Node_CheckIn");
      const MGN_Settlement_Rules = await deployed("MGN_Settlement_Rules");

      await (await MGN_20.mint(accounts[0].address, 1000000000)).wait();
      await (await MGN_20.approve(MGN_Render_Transcition.address, 1000000000)).wait();

      await (await MGN_Roles_Cfg.addAdmin(MGN_Render_Transcition.address)).wait();

      await (await MGN_Node_Type.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_Node_Type.addNodeType(1, "test", 1, 1, 1, 1, 1, "test", "test", "1")).wait();

      await (await MGN_Node_Mgr.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_Node_Mgr.setNodeTypeAddress(MGN_Node_Type.address)).wait();
      await (await MGN_Node_Mgr.setNodeCheckInAddress(MGN_Node_CheckIn.address)).wait();
      await (await MGN_Node_Mgr.addNode(accounts[0].getAddress(), "127.0.0.1", 1000, [1, 1, 1, 1, 1])).wait();

      await (await MGN_Render_Transcition.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_Render_Transcition.setErc20Address(MGN_20.address)).wait();
      await (await MGN_Render_Transcition.setNodeMgrAddress(MGN_Node_Mgr.address)).wait();
      await (await MGN_Render_Transcition.setSettlementRulesAddress(MGN_Settlement_Rules.address)).wait();
      await (await MGN_Render_Transcition.createOrder(1, 1)).wait();
      await (await MGN_Render_Transcition.settlementOrder(1)).wait();

      const res = await MGN_Render_Transcition.getOrder(1);

      console.info(res);
    });
  });
});
