var MOSSAI_ERC_20 = artifacts.require("MOSSAI_ERC_20");
var MGN_Miner_Node_Check = artifacts.require("MGN_Miner_Node_Check");
var MGN_Miner_Node = artifacts.require("MGN_Miner_Node");
var MGN_Test = artifacts.require("MGN_Test");
var MGN_Role = artifacts.require("MGN_Role");
var MGN_Order = artifacts.require("MGN_Order");
var MGN_Resource_Type = artifacts.require("MGN_Resource_Type");
var MGN_Settlement_Rules = artifacts.require("MGN_Settlement_Rules");
var MGN_Space_Location = artifacts.require("MGN_Space_Location");


module.exports = async function (deployer, network, accounts) {

    let result = await deployer.deploy(MGN_Space_Location);

    console.info(result);

    // const MGN_Order_1 = await MGN_Order.at('0x92e28f3475b8c0ae3653e989b2dfb5b1b53c6841');

    // // let result = await MGN_Order_1.createOrder(2, 5);
    // // let result = await MGN_Order_1.createOrder(2, 5);

    // let result = await MGN_Order_1.settlementOrder(27)

    // console.info(result);





};