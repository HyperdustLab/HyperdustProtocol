pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {StrUtil} from "../utils/StrUtil.sol";

import "../HyperAGI_Storage.sol";
import "../HyperAGI_Wallet_Account.sol";
import "../HyperAGI_Transaction_Cfg.sol";
import "./../node/HyperAGI_Node_Mgr.sol";

import "./../HyperAGI_Roles_Cfg.sol";

import "./HyperAGI_Payment_Wallet.sol";

contract HyperAGI_Ecpoch_Transaction is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _nodeMgrAddress;
    address public _transactionCfgAddress;
    address public _walletAccountAddress;
    address public _storageAddress;
    address public _paymentWalletAddress;

    event eveEpochTransactionSave(uint256 id);

    event eveUpdateEpoch(uint256[] success, uint256[] fail);

    event eveDifficulty(uint256 difficulty);

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setNodeMgrAddress(address nodeMgrAddress) public onlyOwner {
        _nodeMgrAddress = nodeMgrAddress;
    }

    function setTransactionCfgAddress(address transactionCfgAddress) public onlyOwner {
        _transactionCfgAddress = transactionCfgAddress;
    }

    function setWalletAccountAddress(address walletAccountAddress) public onlyOwner {
        _walletAccountAddress = walletAccountAddress;
    }

    function setStorageAddress(address storageAddress) public onlyOwner {
        _storageAddress = storageAddress;
    }

    function setPaymentWalletAddress(address paymentWalletAddress) public onlyOwner {
        _paymentWalletAddress = paymentWalletAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _nodeMgrAddress = contractaddressArray[1];
        _transactionCfgAddress = contractaddressArray[2];
        _walletAccountAddress = contractaddressArray[3];
        _storageAddress = contractaddressArray[4];
        _paymentWalletAddress = contractaddressArray[5];
    }

    function createEpochTransaction(uint256 nodeId, uint256 epoch) public returns (uint256) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        HyperAGI_Wallet_Account walletAccountAddress = HyperAGI_Wallet_Account(_walletAccountAddress);
        HyperAGI_Node_Mgr nodeMgrAddress = HyperAGI_Node_Mgr(_nodeMgrAddress);
        HyperAGI_Transaction_Cfg transactionCfgAddress = HyperAGI_Transaction_Cfg(_transactionCfgAddress);
        HyperAGI_Payment_Wallet paymentWalletAddress = HyperAGI_Payment_Wallet(payable(_paymentWalletAddress));

        address _GasFeeCollectionWallet = walletAccountAddress._GasFeeCollectionWallet();

        require(_GasFeeCollectionWallet != address(0), "not set GasFeeCollectionWallet");

        uint256 commission = transactionCfgAddress.getGasFee("epoch");

        (, uint256 totalNum, uint256 activeNum) = nodeMgrAddress.getStatisticalIndex();

        if (activeNum == 0) {
            emit eveDifficulty(0);
        } else {
            emit eveDifficulty((totalNum * 10 ** 6) / activeNum);
        }

        uint256 amount = paymentWalletAddress.getAllowance(msg.sender, address(this));

        require(amount >= commission, "Insufficient authorized amount");

        paymentWalletAddress.deduct(msg.sender, commission);

        transferETH(payable(_GasFeeCollectionWallet), commission);

        walletAccountAddress.addAmount(commission);

        uint256 createTime = block.timestamp;

        bytes1 status = 0x11;

        if (epoch > 1) {
            status = 0x00;
        }

        uint256 id = storageAddress.getNextId();

        storageAddress.setAddress(storageAddress.genKey("account", id), msg.sender);

        storageAddress.setUint(storageAddress.genKey("nodeId", id), nodeId);

        storageAddress.setUint(storageAddress.genKey("epoch", id), epoch);
        storageAddress.setUint(storageAddress.genKey("useEpoch", id), 1);
        storageAddress.setUint(storageAddress.genKey("commission", id), commission);

        storageAddress.setUint(storageAddress.genKey("amount", id), commission);

        storageAddress.setUint(storageAddress.genKey("createTime", id), createTime);

        storageAddress.setUint(storageAddress.genKey("endTime", id), createTime + (epoch * 60 * 64) / 10);

        storageAddress.setUint(storageAddress.genKey("nextEndTime", id), createTime + (60 * 64) / 10);

        storageAddress.setUint(storageAddress.genKey("nodeId", id), nodeId);

        storageAddress.setBytes1(storageAddress.genKey("status", id), status);
        uint256[] memory epochAmounts = new uint256[](epoch);
        uint256[] memory epochTimes = new uint256[](epoch);

        epochAmounts[0] = commission;
        epochTimes[0] = createTime;

        storageAddress.setUintArray(storageAddress.genKey("epochAmounts", id), epochAmounts);

        storageAddress.setUintArray(storageAddress.genKey("epochTimes", id), epochTimes);

        if (epoch > 1) {
            storageAddress.setUintArray("runningEpochTransactions", id);
            storageAddress.setBool(storageAddress.genKey("running", id), true);
        }

        emit eveEpochTransactionSave(id);

        return id;
    }

    function updateEpoch() public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        HyperAGI_Wallet_Account walletAccountAddress = HyperAGI_Wallet_Account(_walletAccountAddress);
        HyperAGI_Node_Mgr nodeMgrAddress = HyperAGI_Node_Mgr(_nodeMgrAddress);
        HyperAGI_Transaction_Cfg transactionCfgAddress = HyperAGI_Transaction_Cfg(_transactionCfgAddress);

        HyperAGI_Payment_Wallet paymentWalletAddress = HyperAGI_Payment_Wallet(payable(_paymentWalletAddress));

        uint256[] memory _runningEpochTransactions = storageAddress.getUintArray("runningEpochTransactions");

        uint256 last = _runningEpochTransactions.length;

        address GasFeeCollectionWalletAddress = walletAccountAddress._GasFeeCollectionWallet();

        if (last == 0) {
            return;
        }

        uint256 commission = transactionCfgAddress.getGasFee("epoch");

        (, uint256 totalNum, uint256 activeNum) = nodeMgrAddress.getStatisticalIndex();

        if (activeNum == 0) {
            emit eveDifficulty(0);
        } else {
            emit eveDifficulty((totalNum * 10 ** 6) / activeNum);
        }

        uint256 totalAmount = 0;

        uint256[] memory success = new uint256[](_runningEpochTransactions.length);

        uint256[] memory runningEpochTransactions = storageAddress.getUintArray("runningEpochTransactions");

        uint256[] memory fail = new uint256[](runningEpochTransactions.length);

        uint32 successIndex = 0;
        uint32 failIndex = 0;

        for (uint i = 0; i < runningEpochTransactions.length; i++) {
            uint256 id = runningEpochTransactions[i];

            address account = storageAddress.getAddress(storageAddress.genKey("account", id));

            uint256 amount = paymentWalletAddress.getAllowance(account, address(this));

            uint256 balance = paymentWalletAddress.getBalance(account);

            if (amount >= commission && balance >= commission) {
                paymentWalletAddress.deduct(account, commission);

                uint256 epoch = storageAddress.getUint(storageAddress.genKey("epoch", id));

                uint256 useEpoch = storageAddress.getUint(storageAddress.genKey("useEpoch", id));

                useEpoch++;

                storageAddress.setUint(storageAddress.genKey("useEpoch", id), useEpoch);

                if (useEpoch >= epoch) {
                    storageAddress.setBytes1(storageAddress.genKey("status", id), 0x11);
                }

                uint256 nextEndTime = storageAddress.getUint(storageAddress.genKey("nextEndTime", id));

                storageAddress.setUint(storageAddress.genKey("nextEndTime", id), nextEndTime);

                storageAddress.setUint(storageAddress.genKey("nextEndTime", id), nextEndTime + (60 * 64) / 10);

                storageAddress.setUintArray(storageAddress.genKey("epochTimes", id), useEpoch - 1, block.timestamp);

                storageAddress.setUintArray(storageAddress.genKey("epochAmounts", id), useEpoch - 1, commission);

                uint256 _amount = storageAddress.getUint(storageAddress.genKey("amount", id));

                storageAddress.setUint(storageAddress.genKey("amount", id), _amount + commission);

                totalAmount += commission;

                success[successIndex] = id;
                successIndex++;

                if (useEpoch >= epoch) {
                    cleanRunningTransactions(id, _runningEpochTransactions, last);

                    last--;
                }
            } else {
                cleanRunningTransactions(id, _runningEpochTransactions, last);

                last--;

                fail[failIndex] = id;
                failIndex++;

                storageAddress.setBytes1(storageAddress.genKey("status", id), 0x11);
            }
        }

        if (totalAmount > 0) {
            walletAccountAddress.addAmount(totalAmount);
            transferETH(payable(GasFeeCollectionWalletAddress), totalAmount);
        }

        uint256[] memory _success = new uint256[](successIndex);

        uint256[] memory _fail = new uint256[](failIndex);

        for (uint i = 0; i < successIndex; i++) {
            _success[i] = success[i];
        }

        for (uint i = 0; i < failIndex; i++) {
            _fail[i] = fail[i];
        }

        emit eveUpdateEpoch(_success, _fail);
    }

    function cleanRunningTransactions(uint256 id, uint256[] memory runningEpochTransactions, uint256 last) private {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);
        storageAddress.setBytes1(storageAddress.genKey("status", id), 0x11);

        storageAddress.setBool(storageAddress.genKey("running", id), false);

        for (uint i = 0; i < last; i++) {
            if (runningEpochTransactions[i] == id) {
                runningEpochTransactions[i] = runningEpochTransactions[last - 1];

                storageAddress.removeUintArray("runningEpochTransactions", i);
            }
        }
    }

    function getEpochTransaction(uint256 id) public view returns (address, uint256[] memory, bytes1, uint256[] memory, uint256[] memory) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 createTime = storageAddress.getUint(storageAddress.genKey("createTime", id));

        require(createTime > 0, "not found");

        uint256[] memory uint256Array = new uint256[](8);
        uint256Array[0] = id;
        uint256Array[1] = storageAddress.getUint(storageAddress.genKey("amount", id));
        uint256Array[2] = createTime;
        uint256Array[3] = storageAddress.getUint(storageAddress.genKey("endTime", id));
        uint256Array[4] = storageAddress.getUint(storageAddress.genKey("nextEndTime", id));
        uint256Array[5] = storageAddress.getUint(storageAddress.genKey("nodeId", id));

        uint256Array[6] = storageAddress.getUint(storageAddress.genKey("epoch", id));

        uint256Array[7] = storageAddress.getUint(storageAddress.genKey("useEpoch", id));

        return (storageAddress.getAddress(storageAddress.genKey("account", id)), uint256Array, storageAddress.getBytes1(storageAddress.genKey("status", id)), storageAddress.getUintArray(storageAddress.genKey("epochAmounts", id)), storageAddress.getUintArray(storageAddress.genKey("epochTimes", id)));
    }

    function getRunningEpochTransactions() public view returns (uint256[] memory) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        return storageAddress.getUintArray("runningEpochTransactions");
    }

    function renewal(uint256 orderId, uint256 epochNum) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        address account = storageAddress.getAddress(storageAddress.genKey("account", orderId));

        uint256 createTime = storageAddress.getUint(storageAddress.genKey("createTime", orderId));

        require(createTime > 0, "not found");

        require(msg.sender == account, "not owner");

        uint256 endTime = storageAddress.getUint(storageAddress.genKey("endTime", orderId));

        require(block.timestamp < endTime, "order expired");

        storageAddress.setUint(storageAddress.genKey("endTime", orderId), endTime + (epochNum * 60 * 64) / 10);

        uint256 epoch = storageAddress.getUint(storageAddress.genKey("epoch", orderId));

        epoch += epochNum;

        storageAddress.setUint(storageAddress.genKey("epoch", orderId), epoch);

        bool running = storageAddress.getBool(storageAddress.genKey("running", orderId));

        if (!running) {
            storageAddress.setUintArray("runningEpochTransactions", orderId);
            storageAddress.setBool(storageAddress.genKey("running", orderId), true);
        }

        uint256[] memory epochAmounts = new uint256[](epoch);
        uint256[] memory epochTimes = new uint256[](epoch);

        uint256[] memory _epochAmounts = storageAddress.getUintArray(storageAddress.genKey("epochAmounts", orderId));
        uint256[] memory _epochTimes = storageAddress.getUintArray(storageAddress.genKey("epochTimes", orderId));

        for (uint i = 0; i < _epochAmounts.length; i++) {
            epochAmounts[i] = _epochAmounts[i];
            epochTimes[i] = _epochTimes[i];
        }

        storageAddress.setUintArray(storageAddress.genKey("epochAmounts", orderId), epochAmounts);

        storageAddress.setUintArray(storageAddress.genKey("epochTimes", orderId), epochTimes);

        emit eveEpochTransactionSave(orderId);
    }

    function transferETH(address payable recipient, uint256 amount) private {
        require(address(this).balance >= amount, "Insufficient balance in contract");
        recipient.transfer(amount);
    }
}
