/** @format */

import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Render_Transcition", () => {
  describe("MGN_Render_Transcition", () => {
    it("settlementOrder", async () => {
      const accounts = await ethers.getSigners();

      const MGN_Roles_Cfg = await ethers.deployContract("MGN_Roles_Cfg");

      const MGN_Render_Transcition = await ethers.deployContract("MGN_Render_Transcition");
      const MGN_Node_Mgr = await ethers.deployContract("MGN_Node_Mgr");
      const MGN_Node_Type = await ethers.deployContract("MGN_Node_Type");
      const MGN_Token = await ethers.deployContract("MGN_Token");
      const MGN_Node_CheckIn = await ethers.deployContract("MGN_Node_CheckIn");
      const MGN_Transaction_Cfg = await ethers.deployContract("MGN_Transaction_Cfg");
      const MGN_Settlement_Account = await ethers.deployContract("MGN_Settlement_Account");
      const MGN_Security_Deposit = await ethers.deployContract("MGN_Security_Deposit");
      const MGN_BaseReward_Release = await ethers.deployContract("MGN_BaseReward_Release");
      const MGN_Wallet_Account = await ethers.deployContract("MGN_Wallet_Account");



      await (await MGN_Token.setRolesCfgAddress(MGN_Roles_Cfg.target)).wait();


      await (await MGN_Security_Deposit.setContractAddress([MGN_Roles_Cfg.target, MGN_Token.target])).wait();

      await (await MGN_Wallet_Account.setContractAddress([MGN_Roles_Cfg.target, MGN_Token.target])).wait()

      await (await MGN_BaseReward_Release.setContractAddress([MGN_Roles_Cfg.target, MGN_Token.target])).wait();



      await (await MGN_Settlement_Account.setRolesCfgAddress(MGN_Roles_Cfg.target)).wait();
      await (await MGN_Settlement_Account.addSettlementAccount([accounts[0].address])).wait();

      await (await MGN_Transaction_Cfg.setRolesCfgAddress(MGN_Roles_Cfg)).wait();
      await (await MGN_Transaction_Cfg.add("renderTranscition_gas", 1000000000)).wait();

      await (await MGN_Token.mint(accounts[0].address, ethers.parseUnits("100", "ether"))).wait();
      await (await MGN_Token.approve(MGN_Render_Transcition.target, ethers.parseUnits("100", "ether"))).wait();

      await (await MGN_Roles_Cfg.addAdmin(MGN_Render_Transcition.target)).wait();

      await (await MGN_Node_Type.setRolesCfgAddress(MGN_Roles_Cfg.target)).wait();
      await (await MGN_Node_Type.addNodeType(1, "test", 1, 1, 1, 1, 1, "test", "test", "1")).wait();

      await (await MGN_Node_Mgr.setRolesCfgAddress(MGN_Roles_Cfg.target)).wait();
      await (await MGN_Node_Mgr.setNodeTypeAddress(MGN_Node_Type.target)).wait();
      await (await MGN_Node_Mgr.setNodeCheckInAddress(MGN_Node_CheckIn.target)).wait();
      await (await MGN_Node_Mgr.addNode(accounts[0].address, "127.0.0.1", 1000, [1, 1, 1, 1, 1])).wait();
      await (await MGN_Node_Mgr.addNode(accounts[0].address, "127.0.0.2", 1000, [1, 1, 1, 1, 1])).wait();

      await (await MGN_Node_Mgr.updateStatus(2, "2")).wait();


      await (await MGN_Render_Transcition.setContractAddress
        ([MGN_Roles_Cfg.target, MGN_Token.target,
        MGN_Node_Mgr.target, MGN_Transaction_Cfg.target,
        MGN_Security_Deposit.target, MGN_Settlement_Account.target,
        MGN_Wallet_Account.target, MGN_BaseReward_Release.target])).wait();


      await (await MGN_Render_Transcition.createRenderTranscition(1, 100, { value: 1000000000 })).wait();

      const renderTranscition = await MGN_Render_Transcition.getRenderTranscition(1);


      await (await MGN_Render_Transcition.settlement(1)).wait();


      const Render_Transcition = await MGN_Render_Transcition.calculateCommission(10)

      console.info(Render_Transcition);


      // const baseRewardReleaseRecords = await MGN_BaseReward_Release.getBaseRewardReleaseRecords(accounts[0].address)

      // console.info(baseRewardReleaseRecords[1]);



    });
  });
});
