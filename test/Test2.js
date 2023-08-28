const MGN_Miner_Node_Check = artifacts.require("MGN_Miner_Node_Check");
const MGN_Miner_Node = artifacts.require("MGN_Miner_Node");
const MGN_Role = artifacts.require("MGN_Role");
const MGN_Order = artifacts.require("MGN_Order");
const MOSSAI_ERC_20 = artifacts.require("MOSSAI_ERC_20");
var MGN_Test = artifacts.require("MGN_Test");






contract("正在测试添加渲染节点", async accounts => {


    it("合约测试", async () => {


        const MGN_Test_1 = await MGN_Test.new();



        let result = await MGN_Test_1.test();

        console.info(result.logs[0].args);



    })






})