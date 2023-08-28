const MGN_Miner_Node_Check = artifacts.require("MGN_Miner_Node_Check");
const MGN_Miner_Node = artifacts.require("MGN_Miner_Node");
const MGN_Role = artifacts.require("MGN_Role");
const MGN_Order = artifacts.require("MGN_Order");
const MOSSAI_ERC_20 = artifacts.require("MOSSAI_ERC_20");
const MOSSAI_ERC_721 = artifacts.require("MOSSAI_ERC_721");
const MGN_Resource_Type = artifacts.require("MGN_Resource_Type");
const MGN_Space_Type = artifacts.require("MGN_Space_Type");
const MGN_Space = artifacts.require("MGN_Space");
const MGN_Pledge_Record = artifacts.require("MGN_Pledge_Record");
const MGN_Space_Location = artifacts.require("MGN_Space_Location");

contract("正在测试铸造空间", async accounts => {


    it("铸造空间", async () => {

        const MGN_Role_1 = await MGN_Role.new();
        const MOSSAI_ERC_20_1 = await MOSSAI_ERC_20.new("MGN", "MGN");
        const MOSSAI_ERC_721_1 = await MOSSAI_ERC_721.new("T", "T");
        const MGN_Space_Location_1 = await MGN_Space_Location.new();

        await MGN_Space_Location_1.setRoleAddress(MGN_Role_1.address);
        await MGN_Space_Location_1.add([1,1], [1,2])

        await MOSSAI_ERC_20_1.mint(accounts[0], 1000000000000000);
        await MOSSAI_ERC_20_1.mint(accounts[1], 1000000000000000);

        const MGN_Space_Type_1 = await MGN_Space_Type.new();
        await MGN_Space_Type_1.setRoleAddress(MGN_Role_1.address);
        await MGN_Space_Type_1.add(1, "测试分类", "https://vniverse.s3.ap-east-1.amazonaws.com/upload/2023/7/11/b348bb62-b494-4a34-8451-2330d960b081.jpg", "测试", 100000, 200000, 1000);

        const MGN_Space_1 = await MGN_Space.new();

        await MGN_Role_1.addAdmin(MGN_Space_1.address);
        MOSSAI_ERC_721_1.grantRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', MGN_Space_1.address);


        await MGN_Space_1.setRoleAddress(MGN_Role_1.address);
        await MGN_Space_1.setSpaceNftAddress(MOSSAI_ERC_721_1.address)
        await MGN_Space_1.setSpaceLocationAddress(MGN_Space_Location_1.address);
        await MGN_Space_1.setSpaceTypeAddress(MGN_Space_Type_1.address);
        await MGN_Space_1.settlementAddress(accounts[1]);
        await MGN_Space_1.setErc20Address(MOSSAI_ERC_20_1.address);
        await MOSSAI_ERC_20_1.approve(MGN_Space_1.address, 200000);
        await MOSSAI_ERC_20_1.approve(MGN_Space_1.address, 100000, { from: accounts[1] });

        await MGN_Space_1.putSpaceNFTTokenURI(1, ['1']);

        


        await MGN_Space_1.mint(1, 1, 1)
        await MGN_Space_1.mint(2, 2, 1)
        const result = await MGN_Space_1.updateErc1155Address(1, MOSSAI_ERC_20_1.address);


        
        console.info(result)






    })
})