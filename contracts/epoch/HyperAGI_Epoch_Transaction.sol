pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/StorageSlot.sol";

import {StrUtil} from "../utils/StrUtil.sol";

import "../HyperAGI_Storage.sol";
import "../HyperAGI_Wallet_Account.sol";
import "../HyperAGI_Transaction_Cfg.sol";
import "./../node/HyperAGI_Node_Mgr.sol";

import "./../HyperAGI_Roles_Cfg.sol";

contract HyperAGI_Epoch_Transaction is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _nodeMgrAddress;
    address public _transactionCfgAddress;
    address public _walletAccountAddress;
    address public _storageAddress;

    event eveEpochTransactionSave(uint256 id);

    event eveUpdateEpoch(uint256[] ids, uint256 time, uint256 amount);

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

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _nodeMgrAddress = contractaddressArray[1];
        _transactionCfgAddress = contractaddressArray[2];
        _walletAccountAddress = contractaddressArray[3];
        _storageAddress = contractaddressArray[4];
    }

    function createEpochTransaction(uint256 nodeId, uint256 epoch) public payable returns (uint256) {
        require(epoch > 0, "epoch must be greater than 0");
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        HyperAGI_Wallet_Account walletAccountAddress = HyperAGI_Wallet_Account(_walletAccountAddress);
        HyperAGI_Node_Mgr nodeMgrAddress = HyperAGI_Node_Mgr(_nodeMgrAddress);
        HyperAGI_Transaction_Cfg transactionCfgAddress = HyperAGI_Transaction_Cfg(_transactionCfgAddress);

        address _GasFeeCollectionWallet = walletAccountAddress._GasFeeCollectionWallet();

        require(_GasFeeCollectionWallet != address(0), "not set GasFeeCollectionWallet");

        uint256 commission = transactionCfgAddress.getGasFee("epoch");

        uint256 maxCommission = transactionCfgAddress.getMaxGasFee("epoch");

        uint256 payAmount = maxCommission * epoch;

        uint256 id = storageAddress.getNextId();

        require(msg.value == maxCommission * epoch, "Invalid payment amount");

        (uint256 totalNum, uint256 activeNum) = nodeMgrAddress.getStatisticalIndex();

        if (activeNum == 0) {
            emit eveDifficulty(0);
        } else {
            emit eveDifficulty((totalNum * 10 ** 6) / activeNum);
        }

        transferETH(payable(_GasFeeCollectionWallet), commission);

        walletAccountAddress.addAmount(commission);

        uint256 createTime = block.timestamp;

        bytes1 status = 0x11;

        if (epoch > 1) {
            status = 0x00;
        } else {
            if (maxCommission > commission) {
                uint256 returnAmount = maxCommission - commission;
                transferETH(payable(msg.sender), returnAmount);
                storageAddress.setUint(storageAddress.genKey("returnAmount", id), returnAmount);
            }
        }

        storageAddress.setAddress(storageAddress.genKey("account", id), msg.sender);

        storageAddress.setUint(storageAddress.genKey("nodeId", id), nodeId);

        storageAddress.setUint(storageAddress.genKey("epoch", id), epoch);
        storageAddress.setUint(storageAddress.genKey("useEpoch", id), 1);
        storageAddress.setUint(storageAddress.genKey("commission", id), commission);

        storageAddress.setUint(storageAddress.genKey("amount", id), commission);

        storageAddress.setUint(storageAddress.genKey("payAmount", id), payAmount);

        storageAddress.setUint(storageAddress.genKey("createTime", id), createTime);

        storageAddress.setUint(storageAddress.genKey("endTime", id), createTime + (epoch * 60 * 64) / 10);

        storageAddress.setUint(storageAddress.genKey("nextEndTime", id), createTime + (60 * 64) / 10);

        storageAddress.setUint(storageAddress.genKey("nodeId", id), nodeId);

        storageAddress.setBytes1(storageAddress.genKey("status", id), status);

        storageAddress.setUintArray(storageAddress.genKey("epochAmounts", id), commission);
        storageAddress.setUintArray(storageAddress.genKey("epochTimes", id), createTime);

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

        uint256[] memory _runningEpochTransactions = storageAddress.getUintArray("runningEpochTransactions");

        uint256 last = _runningEpochTransactions.length;

        address GasFeeCollectionWalletAddress = walletAccountAddress._GasFeeCollectionWallet();

        if (last == 0) {
            return;
        }

        uint256 commission = transactionCfgAddress.getGasFee("epoch");

        (uint256 totalNum, uint256 activeNum) = nodeMgrAddress.getStatisticalIndex();

        if (activeNum == 0) {
            emit eveDifficulty(0);
        } else {
            emit eveDifficulty((totalNum * 10 ** 6) / activeNum);
        }

        uint256[] memory runningEpochTransactions = storageAddress.getUintArray("runningEpochTransactions");

        uint256 totalAmount = commission * runningEpochTransactions.length;

        for (uint i = 0; i < runningEpochTransactions.length; i++) {
            uint256 id = runningEpochTransactions[i];

            uint256 epoch = storageAddress.getUint(storageAddress.genKey("epoch", id));

            uint256 useEpoch = storageAddress.getUint(storageAddress.genKey("useEpoch", id));

            useEpoch++;

            storageAddress.setUint(storageAddress.genKey("useEpoch", id), useEpoch);

            string memory amountKey = storageAddress.genKey("amount", id);

            uint256 amount = storageAddress.getUint(amountKey);

            amount += commission;

            storageAddress.setUint(amountKey, amount);

            if (useEpoch >= epoch) {
                uint256 payAmount = storageAddress.getUint(storageAddress.genKey("payAmount", id));

                if (payAmount > amount) {
                    address account = storageAddress.getAddress(storageAddress.genKey("account", id));

                    transferETH(payable(account), payAmount - amount);

                    storageAddress.setUint(storageAddress.genKey("returnAmount", id), payAmount - amount);
                }

                storageAddress.setBytes1(storageAddress.genKey("status", id), 0x11);

                cleanRunningTransactions(id, _runningEpochTransactions, last);

                last--;
            }
        }
        if (totalAmount > 0) {
            walletAccountAddress.addAmount(totalAmount);
            transferETH(payable(GasFeeCollectionWalletAddress), totalAmount);
        }
        emit eveUpdateEpoch(runningEpochTransactions, block.timestamp, commission);
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

        uint256[] memory uint256Array = new uint256[](10);
        uint256Array[0] = id;
        uint256Array[1] = storageAddress.getUint(storageAddress.genKey("amount", id));
        uint256Array[2] = createTime;
        uint256Array[3] = storageAddress.getUint(storageAddress.genKey("endTime", id));
        uint256Array[4] = storageAddress.getUint(storageAddress.genKey("nextEndTime", id));
        uint256Array[5] = storageAddress.getUint(storageAddress.genKey("nodeId", id));

        uint256Array[6] = storageAddress.getUint(storageAddress.genKey("epoch", id));

        uint256Array[7] = storageAddress.getUint(storageAddress.genKey("useEpoch", id));
        uint256Array[8] = storageAddress.getUint(storageAddress.genKey("payAmount", id));
        uint256Array[9] = storageAddress.getUint(storageAddress.genKey("returnAmount", id));

        return (storageAddress.getAddress(storageAddress.genKey("account", id)), uint256Array, storageAddress.getBytes1(storageAddress.genKey("status", id)), storageAddress.getUintArray(storageAddress.genKey("epochAmounts", id)), storageAddress.getUintArray(storageAddress.genKey("epochTimes", id)));
    }

    function getRunningEpochTransactions() public view returns (uint256[] memory) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        return storageAddress.getUintArray("runningEpochTransactions");
    }

    function transferETH(address payable recipient, uint256 amount) private {
        require(address(this).balance >= amount, "Insufficient balance in contract");
        recipient.transfer(amount);
    }
}
