/** @format */

import { ethers, upgrades } from "hardhat";

describe("Hyperdust_Security_Deposit", () => {
    describe("Hyperdust_Security_Deposit", () => {
        it("Hyperdust_Security_Deposit", async () => {

            const accounts = await ethers.getSigners();

            const _Hyperdust_Roles_Cfg = await ethers.getContractFactory("Hyperdust_Roles_Cfg");
            const Hyperdust_Roles_Cfg = await upgrades.deployProxy(_Hyperdust_Roles_Cfg);



            const Hyperdust_Token = await ethers.deployContract("Hyperdust_Token_Test", ["TEST", "TEST", accounts[0].address]);
            await Hyperdust_Token.waitForDeployment()


            await (await Hyperdust_Token.setPrivateSaleAddress(accounts[0].address)
            ).wait()

            await (await Hyperdust_Token.mint(ethers.parseEther('100000'))).wait()




            const _Hyperdust_Node_CheckIn = await ethers.getContractFactory("Hyperdust_Node_CheckIn");
            const Hyperdust_Node_CheckIn = await upgrades.deployProxy(_Hyperdust_Node_CheckIn);


            const _Hyperdust_Node_Type = await ethers.getContractFactory("Hyperdust_Node_Type");
            const Hyperdust_Node_Type = await upgrades.deployProxy(_Hyperdust_Node_Type);



            const Hyperdust_Node_Type_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Node_Type_Data.waitForDeployment()

            await (await Hyperdust_Node_Type.setRolesCfgAddress(Hyperdust_Roles_Cfg.target)).wait();
            await (await Hyperdust_Node_Type.setHyperdustStorageAddress(Hyperdust_Node_Type_Data.target)).wait();

            await (await Hyperdust_Node_Type_Data.setServiceAddress(Hyperdust_Node_Type.target)).wait()



            const _Hyperdust_Node_Mgr = await ethers.getContractFactory("Hyperdust_Node_Mgr");
            const Hyperdust_Node_Mgr = await upgrades.deployProxy(_Hyperdust_Node_Mgr);


            const Hyperdust_Node_Mgr_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Node_Mgr_Data.waitForDeployment()

            await (await Hyperdust_Node_Mgr_Data.setServiceAddress(Hyperdust_Node_Mgr.target)).wait()





            const _Hyperdust_Security_Deposit = await ethers.getContractFactory("Hyperdust_Security_Deposit");
            const Hyperdust_Security_Deposit = await upgrades.deployProxy(_Hyperdust_Security_Deposit, [accounts[0].address]);


            const Hyperdust_Security_Deposit_Data = await ethers.deployContract("Hyperdust_Storage");
            await Hyperdust_Security_Deposit_Data.waitForDeployment()



            await (await Hyperdust_Security_Deposit_Data.setServiceAddress(Hyperdust_Security_Deposit.target)).wait()


            await (await Hyperdust_Security_Deposit.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Token.target, Hyperdust_Security_Deposit_Data.target, Hyperdust_Node_Mgr.target])).wait();



            await (await Hyperdust_Node_Mgr.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_CheckIn.target, Hyperdust_Node_Type.target, Hyperdust_Node_Mgr_Data.target])).wait();
            await (await Hyperdust_Node_Mgr.setStatisticalIndex(10, 8)).wait()



            const _Hyperdust_Transaction_Cfg = await ethers.getContractFactory("Hyperdust_Transaction_Cfg");
            const Hyperdust_Transaction_Cfg = await upgrades.deployProxy(_Hyperdust_Transaction_Cfg);

            await (await Hyperdust_Transaction_Cfg.setContractAddress([Hyperdust_Roles_Cfg.target, Hyperdust_Node_Mgr.target])).wait();


            await (await Hyperdust_Transaction_Cfg.add("render", 30000)).wait();


            await (await Hyperdust_Roles_Cfg.addAdmin(Hyperdust_Security_Deposit.target)).wait()



            await (await Hyperdust_Node_Type.addNodeType(1, "test", 1, 1, 1, 1, 1, "test", "test", "1")).wait();

            await (await Hyperdust_Node_Mgr.addNode(accounts[0].address, "127.0.0.1", [1, 1, 1, 1, 1, 1, 1])).wait();
            await (await Hyperdust_Node_Mgr.addNode(accounts[1].address, "127.0.0.2", [1, 1, 1, 1, 1, 1, 1])).wait();




            await (await Hyperdust_Security_Deposit.addSecurityDeposit(1, ethers.parseEther("100"))).wait();
            await (await Hyperdust_Security_Deposit.addSecurityDeposit(2, ethers.parseEther("100"))).wait();

            (await Hyperdust_Token.transfer(Hyperdust_Security_Deposit.target, ethers.parseEther("200"))).wait()

            const incomeAddressList = await Hyperdust_Security_Deposit.getIncomeAddressList();

            console.info("incomeAddressList:" + incomeAddressList)

            await (await Hyperdust_Security_Deposit.applyWithdrawal(1)).wait()
            await (await Hyperdust_Security_Deposit.withdrawal(1)).wait()


            const incomeAddressList1 = await Hyperdust_Security_Deposit.getIncomeAddressList();

            console.info("incomeAddressList:" + incomeAddressList1)




        });
    });
});
