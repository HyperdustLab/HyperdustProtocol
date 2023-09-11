/** @format */

import { ethers } from "hardhat";
const { describe, it } = require("mocha");

describe("MGN_Space", () => {
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

      const MOSSAI_ERC_20 = await deployed("MGN_20", "MGN", "MGN");
      const MGN_Roles_Cfg = await deployed("MGN_Roles_Cfg");
      const MOSSAI_ERC_721 = await deployed("MGN_721", "721", "721");
      const MGN_Space = await deployed("MGN_Space");
      const MGN_Space_TVL = await deployed("MGN_Space_TVL");
      const MGN_World_Map = await deployed("MGN_World_Map");
      const UniswapV3PositionsNFTV1 = await deployed("UniswapV3PositionsNFTV1");
      const MGN_Transaction_Cfg = await deployed("MGN_Transaction_Cfg");
      const MGN_Wallet_Account = await deployed("MGN_Wallet_Account");
      const SpaceAssetsCfg = await deployed("SpaceAssetsCfg");
      const MGN_Uniswap_liquidity_Cfg = await deployed("MGN_Uniswap_liquidity_Cfg");
      const MGN_Space_Airdrop = await deployed("MGN_Space_Airdrop");
      const Space721Factory = await deployed("Space721Factory");
      const Space1155Factory = await deployed("Space1155Factory");

      await (
        await MGN_Space.setDefParameter(
          "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/10/13e02181-24b5-4e41-8481-4d7bb4886619.jpg",
          "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/8/11/d073bdc7-8440-4479-9d84-8b357a0fe7cf.7z",
          "875c03eba7bd71e564ed657e9f6ed97132c230a1e5073422bb410624d0ac1766"
        )
      ).wait();

      await (await MGN_Wallet_Account.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();

      await (await MGN_Space_Airdrop.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();

      await (await MGN_Roles_Cfg.addAdmin(MGN_Space.address)).wait();
      await (await MGN_Roles_Cfg.addSuperAdmin(MGN_Space.address)).wait();

      await (await MGN_Uniswap_liquidity_Cfg.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_Uniswap_liquidity_Cfg.add("0x7a798E8eC045f911684dAa28B38a54b883b9523C", [100], [100])).wait();

      await (await SpaceAssetsCfg.setContractAddress([MGN_Transaction_Cfg.address, MOSSAI_ERC_20.address, MGN_Wallet_Account.address, MGN_Roles_Cfg.address])).wait();

      await (await UniswapV3PositionsNFTV1.setErc20Address(MOSSAI_ERC_20.address)).wait();
      await (await UniswapV3PositionsNFTV1.safeMint(accounts[0].address, "11")).wait();
      await (await UniswapV3PositionsNFTV1.approve(MGN_Space.address, 1)).wait();

      await (await MGN_Space_TVL.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_Space_TVL.add(1, "test", "1", "1", 100, 100)).wait();

      await (await MGN_World_Map.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_World_Map.add([1], [1])).wait();

      await (await MOSSAI_ERC_20.mint(accounts[0].address, 20000000000000)).wait();
      await (await MOSSAI_ERC_20.approve(MGN_Space.address, 1000000000)).wait();

      await (await MOSSAI_ERC_721.grantRole("0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6", MGN_Space.address)).wait();

      await (await MGN_Transaction_Cfg.setRolesCfgAddress(MGN_Roles_Cfg.address)).wait();
      await (await MGN_Transaction_Cfg.add("mintNFT", 100)).wait();

      await (
        await MGN_Space.setContractAddress([
          MGN_Roles_Cfg.address,
          MOSSAI_ERC_721.address,
          MGN_World_Map.address,
          MGN_Space_TVL.address,
          MOSSAI_ERC_20.address,
          MGN_Uniswap_liquidity_Cfg.address,
          UniswapV3PositionsNFTV1.address,
          MGN_Transaction_Cfg.address,
          MGN_Space_Airdrop.address,
          SpaceAssetsCfg.address,
          Space721Factory.address,
          Space1155Factory.address,
        ])
      ).wait();

      await (await MGN_Space.putSpaceNFTTokenURI(1, ["1", "2"])).wait();

      const res = await (await MGN_Space.pledge(1, 1)).wait();

      const logs = res.logs;

      for (const log of logs) {
        if (log.topics[0] === "0x2d5148fd79b1130b86101baff44dd2dedce8fe525206a039f32e312d48229034") {
          const _data = ethers.utils.defaultAbiCoder.decode(["uint256"], log.data);

          const spaceId = parseInt(_data[0]);

          const space = await MGN_Space.getSpace(spaceId);

          console.info(space);

          console.info(MGN_Space.address);

          const Space_721 = await ethers.getContractAt("Space_721", space[2][0]);

          await (await MOSSAI_ERC_20.approve(Space_721.address, 100)).wait();

          await (await Space_721.safeMint(accounts[0].address, "test")).wait();

          const Space_1155 = await ethers.getContractAt("Space_1155", space[2][1]);

          await (await MOSSAI_ERC_20.approve(Space_1155.address, 200)).wait();

          await (await Space_1155.mint(accounts[0].address, 1, 100, "tokenURI", "0x")).wait();

          break;
        }
      }
    });
  });
});
