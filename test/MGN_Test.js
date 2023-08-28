const MGN_Miner_Node_Check = artifacts.require("MGN_Miner_Node_Check");
const MGN_Miner_Node = artifacts.require("MGN_Miner_Node");
const MGN_Role = artifacts.require("MGN_Role");
const MGN_Order = artifacts.require("MGN_Order");
const MOSSAI_ERC_20 = artifacts.require("MOSSAI_ERC_20");
const MGN_Resource_Type = artifacts.require("MGN_Resource_Type");
const MGN_Settlement_Rules = artifacts.require("MGN_Settlement_Rules");

contract("正在测试添加渲染节点", async accounts => {


    it("合约测试", async () => {

        const MOSSAI_ERC_20_1 = await MOSSAI_ERC_20.new('MGN', 'MGN')

        await MOSSAI_ERC_20_1.mint(accounts[0], 100000000000000);


        const MGN_Role_1 = await MGN_Role.new();


        const MGN_Miner_Node_Check_1 = await MGN_Miner_Node_Check.new();

        const MGN_Miner_Node_1 = await MGN_Miner_Node.new();

        const MGN_Resource_Type_1 = await MGN_Resource_Type.new();


        await MGN_Resource_Type_1.setRoleAddress(MGN_Role_1.address);

        await MGN_Resource_Type_1.addResourceType(1, '资源分类1', 4, 16384, 300, 3584, 6, '1', '1', '1');
        // await MGN_Resource_Type_1.addResourceType(2, '资源分类2', 6, 32768, 300, 5888, 12, '1', '1', '1');

        //  await MGN_Resource_Type_1.deleteResourceType(1);


        await MGN_Miner_Node_1.setMinerNodeCheckAddress(MGN_Miner_Node_Check_1.address)
        await MGN_Miner_Node_1.setRoleAddress(MGN_Role_1.address)
        await MGN_Miner_Node_1.setResourceTypeAddress(MGN_Resource_Type_1.address);



        let result = await MGN_Miner_Node_1.addMinerNode(accounts[0], "222.212.248.109", 10000000000000, [4, 32768, 300, 5888, 12])


        console.info(result.logs[0].args.id.words[0])

        const nodeId = result.logs[0].args.id.words[0]


        //  result = await MGN_Miner_Node_1.updateStatus(nodeId, "1");

        // console.info(result);

        // const MGN_Order_1 = await MGN_Order.new();

        // MGN_Settlement_Rules_1 = await MGN_Settlement_Rules.new();

        // await MGN_Settlement_Rules_1.setRoleAddress(MGN_Role_1.address);

        // await MGN_Settlement_Rules_1.add(accounts[1], 12);
        // await MGN_Settlement_Rules_1.add(accounts[2], 13);



        // await MGN_Order_1.setRoleAddress(MGN_Role_1.address);
        // await MGN_Order_1.setErc20Address(MOSSAI_ERC_20_1.address);
        // await MGN_Order_1.setMinerNodeAddress(MGN_Miner_Node_1.address)
        // await MGN_Order_1.setSettlementRulesAddress(MGN_Settlement_Rules_1.address);

        // await MOSSAI_ERC_20_1.approve(MGN_Order_1.address, 10000000000000)

        // await MGN_Role_1.addAdmin(MGN_Order_1.address);


        // result = await MGN_Order_1.createOrder(nodeId, 1);

        // const orderId = result.logs[0].args.id.words[0];

        // result = await MGN_Order_1.settlementOrder(orderId)

        // console.info(result.logs[0])









    })














})