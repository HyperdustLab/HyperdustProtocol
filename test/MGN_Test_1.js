const MGN_Miner_Node_Check = artifacts.require("MGN_Miner_Node_Check");
const MGN_Miner_Node = artifacts.require("MGN_Miner_Node");
const MGN_Role = artifacts.require("MGN_Role");
const MGN_Order = artifacts.require("MGN_Order");
const MOSSAI_ERC_20 = artifacts.require("MOSSAI_ERC_20");
const MGN_Resource_Type = artifacts.require("MGN_Resource_Type");

contract("正在测试添加渲染节点", async accounts => {


    it("合约测试", async () => {


        // const MGN_Miner_Node_1 = await MGN_Miner_Node.at("0x6495b2fa6ccf995d0ac792edb298640fc2927923");

        // let result = await MGN_Miner_Node_1.addMinerNode('0x921133e75bf83f3844ea226c2777c88E160AcD2F', '161.189.85.58', 10000, [4, 16083, 149, 2560, 15360])

        // console.info(result);

        console.info("111111111111111111111")

        const MGN_Order_1 = await MGN_Order.at('0x92e28f3475b8c0ae3653e989b2dfb5b1b53c6841');

        // let result = await MGN_Order_1.createOrder(2, 5);
        // let result = await MGN_Order_1.createOrder(2, 5);

        let result = await MGN_Order_1.settlementOrder(27)

        console.info(result);








    })
})