const MGN_Miner_Node_Check = artifacts.require("MGN_Miner_Node_Check");
const MGN_Miner_Node = artifacts.require("MGN_Miner_Node");
const MGN_Role = artifacts.require("MGN_Role");
const MGN_Order = artifacts.require("MGN_Order");
const MOSSAI_ERC_20 = artifacts.require("MOSSAI_ERC_20");
const MGN_Resource_Type = artifacts.require("MGN_Resource_Type");
const MGN_Space_Type = artifacts.require("MGN_Space_Type");
const MGN_Pledge_Record = artifacts.require("MGN_Pledge_Record");

contract("正在测试添加质押记录", async accounts => {


    it("合约测试", async () => {


        const MGN_Role_1 = await MGN_Role.new();

        const MGN_Space_Type_1 = await MGN_Space_Type.new();
        await MGN_Space_Type_1.setRoleAddress(MGN_Role_1.address);

        await MGN_Space_Type_1.add(1, "测试分类", "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/11/b348bb62-b494-4a34-8451-2330d960b081.jpg", "测试", 1000);


        const MGN_Pledge_Record_1 = await MGN_Pledge_Record.new();

        await MGN_Pledge_Record_1.setRoleAddress(MGN_Role_1.address);

        await MGN_Pledge_Record_1.setSpaceTypeAddress(MGN_Space_Type_1.address);

        let results = await MGN_Pledge_Record_1.add(accounts[0], 100, accounts[0], accounts[0], "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/11/b348bb62-b494-4a34-8451-2330d960b081.jpg")

        console.info(results);










    })
})