pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract IHyperdustNodeMgr {
    struct Node {
        address incomeAddress;
        string ip; //Node public network IP
        uint256[] uint256Array; //id,nodeType,cpuNum,memoryNum,diskNum,cudaNum,videoMemory
    }

    function getNodeObj(uint256 id) public view returns (Node memory) {}

    function getStatisticalIndex()
        public
        view
        returns (uint256, uint32, uint32)
    {}
}

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IHyperdustTransactionCfg {
    function get(string memory key) public view returns (uint256) {}

    function getGasFee(string memory func) public view returns (uint256) {}
}

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {StrUtil} from "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";
import "../Hyperdust_Wallet_Account.sol";

contract Hyperdust_Ecpoch_Transcition is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _erc20Address;
    address public _nodeMgrAddress;
    address public _transactionCfgAddress;
    address public _walletAccountAddress;
    address public _HyperdustStorageAddress;

    event eveRenderTranscitionSave(uint256 id);

    event eveUpdateRenderEpoch(uint256[] success, uint256[] fail);

    event eveNodeStatistical(uint256 totalNum, uint256 activeNum);

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setNodeMgrAddress(address nodeMgrAddress) public onlyOwner {
        _nodeMgrAddress = nodeMgrAddress;
    }

    function setTransactionCfg(address transactionCfgAddress) public onlyOwner {
        _transactionCfgAddress = transactionCfgAddress;
    }

    function setWalletAccountAddress(
        address walletAccountAddress
    ) public onlyOwner {
        _walletAccountAddress = walletAccountAddress;
    }

    function setHyperdustStorageAddress(
        address hyperdustStorageAddress
    ) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _nodeMgrAddress = contractaddressArray[2];
        _transactionCfgAddress = contractaddressArray[3];
        _walletAccountAddress = contractaddressArray[4];
        _HyperdustStorageAddress = contractaddressArray[5];
    }

    function createRenderTranscition(
        uint256 nodeId,
        uint256 epoch
    ) public returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        Hyperdust_Wallet_Account walletAccount = Hyperdust_Wallet_Account(
            _walletAccountAddress
        );

        address _GasFeeCollectionWallet = walletAccount
            ._GasFeeCollectionWallet();

        require(
            _GasFeeCollectionWallet != address(0),
            "not set GasFeeCollectionWallet"
        );

        checkRenderTranscition(msg.sender);
        checkRenderNode(nodeId);

        IHyperdustNodeMgr nodeMgr = IHyperdustNodeMgr(_nodeMgrAddress);

        IERC20 erc20 = IERC20(_erc20Address);
        IHyperdustNodeMgr.Node memory node = nodeMgr.getNodeObj(nodeId);

        require(node.uint256Array[0] != 0, "The miner node inexistence");

        uint256 commission = IHyperdustTransactionCfg(_transactionCfgAddress)
            .getGasFee("ecpoch");

        (, uint256 totalNum, uint256 activeNum) = nodeMgr.getStatisticalIndex();

        emit eveNodeStatistical(totalNum, activeNum);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        require(amount >= commission, "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, _GasFeeCollectionWallet, commission);

        walletAccount.addAmount(commission);

        uint256 createTime = block.timestamp;

        bytes1 status = 0x11;

        if (epoch > 1) {
            status = 0x00;
        }

        uint256 id = hyperdustStorage.getNextId();

        hyperdustStorage.setAddress(
            hyperdustStorage.genKey("serviceAccount", id),
            node.incomeAddress
        );

        hyperdustStorage.setAddress(
            hyperdustStorage.genKey("account", id),
            msg.sender
        );

        hyperdustStorage.setUint(hyperdustStorage.genKey("epoch", id), epoch);
        hyperdustStorage.setUint(hyperdustStorage.genKey("useEpoch", id), 1);
        hyperdustStorage.setUint(
            hyperdustStorage.genKey("commission", id),
            commission
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("createTime", id),
            createTime
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("endTime", id),
            createTime + (epoch * 60 * 64) / 10
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("nextEndTime", id),
            createTime + (60 * 64) / 10
        );

        hyperdustStorage.setUint(hyperdustStorage.genKey("nodeId", id), nodeId);

        hyperdustStorage.setBytes1(
            hyperdustStorage.genKey("status", id),
            status
        );
        uint256[] memory epochAmounts = new uint256[](epoch);
        uint256[] memory epochTimes = new uint256[](epoch);

        epochAmounts[0] = commission;
        epochTimes[0] = createTime;

        hyperdustStorage.setUintArray(
            hyperdustStorage.genKey("epochAmounts", id),
            epochAmounts
        );

        hyperdustStorage.setUintArray(
            hyperdustStorage.genKey("epochTimes", id),
            epochTimes
        );

        if (epoch > 1) {
            hyperdustStorage.setUintArray("runingRenderTranscitions", id);
        }

        hyperdustStorage.setUint(msg.sender.toHexString(), id);
        hyperdustStorage.setUint(nodeId.toString(), id);

        emit eveRenderTranscitionSave(id);

        return id;
    }

    function checkRenderTranscition(address account) private {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );
        uint256 _runingRenderTranscitionId = hyperdustStorage.getUint(
            account.toHexString()
        );
        if (_runingRenderTranscitionId == 0) {
            return;
        }
        bytes1 status = hyperdustStorage.getBytes1(
            hyperdustStorage.genKey("status", _runingRenderTranscitionId)
        );
        uint256 nextEndTime = hyperdustStorage.getUint(
            hyperdustStorage.genKey("nextEndTime", _runingRenderTranscitionId)
        );
        require(
            status == 0x11 && block.timestamp > nextEndTime,
            "You have an Render Transcition running"
        );
    }

    function checkRenderNode(uint256 nodeId) private {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );
        uint256 _runingRenderTranscitionId = hyperdustStorage.getUint(
            nodeId.toString()
        );
        if (_runingRenderTranscitionId == 0) {
            return;
        }
        bytes1 status = hyperdustStorage.getBytes1(
            hyperdustStorage.genKey("status", _runingRenderTranscitionId)
        );
        uint256 nextEndTime = hyperdustStorage.getUint(
            hyperdustStorage.genKey("nextEndTime", _runingRenderTranscitionId)
        );
        require(
            status == 0x11 && block.timestamp > nextEndTime,
            "The render node is already in use"
        );
    }

    function updateEpoch() public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        Hyperdust_Wallet_Account walletAccount = Hyperdust_Wallet_Account(
            _walletAccountAddress
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256[] memory _runingRenderTranscitions = hyperdustStorage
            .getUintArray("runingRenderTranscitions");

        uint256 last = _runingRenderTranscitions.length;

        if (last == 0) {
            return;
        }

        IERC20 erc20 = IERC20(_erc20Address);

        uint256 commission = IHyperdustTransactionCfg(_transactionCfgAddress)
            .getGasFee("render");

        IHyperdustNodeMgr nodeMgr = IHyperdustNodeMgr(_nodeMgrAddress);

        (, uint256 totalNum, uint256 activeNum) = nodeMgr.getStatisticalIndex();

        emit eveNodeStatistical(totalNum, activeNum);

        uint256 totalAmount = 0;

        uint256[] memory success = new uint256[](
            _runingRenderTranscitions.length
        );

        uint256[] memory runingRenderTranscitions = hyperdustStorage
            .getUintArray("runingRenderTranscitions");

        uint256[] memory fail = new uint256[](runingRenderTranscitions.length);

        uint32 successIndex = 0;
        uint32 failIndex = 0;

        for (uint i = 0; i < runingRenderTranscitions.length; i++) {
            uint256 id = runingRenderTranscitions[i];

            address account = hyperdustStorage.getAddress(
                hyperdustStorage.genKey("account", id)
            );

            uint256 amount = erc20.allowance(account, address(this));

            uint256 balance = erc20.balanceOf(account);

            if (amount >= commission && balance >= commission) {
                erc20.transferFrom(account, _walletAccountAddress, commission);

                uint256 epoch = hyperdustStorage.getUint(
                    hyperdustStorage.genKey("epoch", id)
                );

                uint256 useEpoch = hyperdustStorage.getUint(
                    hyperdustStorage.genKey("useEpoch", id)
                );

                useEpoch++;

                hyperdustStorage.setUint(
                    hyperdustStorage.genKey("useEpoch", id),
                    useEpoch
                );

                if (useEpoch >= epoch) {
                    hyperdustStorage.setBytes1(
                        hyperdustStorage.genKey("status", id),
                        0x11
                    );
                }

                uint256 nextEndTime = hyperdustStorage.getUint(
                    hyperdustStorage.genKey("nextEndTime", id)
                );

                hyperdustStorage.setUint(
                    hyperdustStorage.genKey("nextEndTime", id),
                    nextEndTime
                );

                hyperdustStorage.setUint(
                    hyperdustStorage.genKey("nextEndTime", id),
                    nextEndTime + (60 * 64) / 10
                );

                hyperdustStorage.setUintArray(
                    hyperdustStorage.genKey("epochTimes", id),
                    useEpoch - 1,
                    block.timestamp
                );

                hyperdustStorage.setUintArray(
                    hyperdustStorage.genKey("epochAmounts", id),
                    useEpoch - 1,
                    commission
                );

                uint256 _amount = hyperdustStorage.getUint(
                    hyperdustStorage.genKey("amount", id)
                );

                hyperdustStorage.setUint(
                    hyperdustStorage.genKey("amount", id),
                    _amount + commission
                );

                totalAmount += commission;

                success[successIndex] = id;
                successIndex++;

                if (useEpoch >= epoch) {
                    cleanRuningRenderTranscitions(
                        id,
                        _runingRenderTranscitions,
                        last
                    );

                    last--;
                }
            } else {
                cleanRuningRenderTranscitions(
                    id,
                    _runingRenderTranscitions,
                    last
                );

                last--;

                fail[failIndex] = id;
                failIndex++;

                hyperdustStorage.setBytes1(
                    hyperdustStorage.genKey("status", id),
                    0x11
                );
            }
        }

        if (totalAmount > 0) {
            walletAccount.addAmount(totalAmount);
        }

        uint256[] memory _success = new uint256[](successIndex);

        uint256[] memory _fail = new uint256[](failIndex);

        for (uint i = 0; i < successIndex; i++) {
            _success[i] = success[i];
        }

        for (uint i = 0; i < failIndex; i++) {
            _fail[i] = fail[i];
        }

        emit eveUpdateRenderEpoch(_success, _fail);
    }

    function cleanRuningRenderTranscitions(
        uint256 id,
        uint256[] memory runingRenderTranscitions,
        uint256 last
    ) private {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        hyperdustStorage.setBytes1(hyperdustStorage.genKey("status", id), 0x11);

        for (uint i = 0; i < last; i++) {
            if (runingRenderTranscitions[i] == id) {
                runingRenderTranscitions[i] = runingRenderTranscitions[
                    last - 1
                ];

                hyperdustStorage.removeUintArray("runingRenderTranscitions", i);
            }
        }
    }

    function getRenderTranscition(
        uint256 id
    )
        public
        view
        returns (
            address,
            address,
            uint256[] memory,
            bytes1,
            uint256[] memory,
            uint256[] memory
        )
    {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256 createTime = hyperdustStorage.getUint(
            hyperdustStorage.genKey("createTime", id)
        );

        require(createTime > 0, "not found");

        uint256[] memory uint256Array = new uint256[](8);
        uint256Array[0] = id;
        uint256Array[1] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("amount", id)
        );
        uint256Array[2] = createTime;
        uint256Array[3] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("endTime", id)
        );
        uint256Array[4] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("nextEndTime", id)
        );
        uint256Array[5] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("nodeId", id)
        );

        uint256Array[6] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("epoch", id)
        );

        uint256Array[7] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("useEpoch", id)
        );

        return (
            hyperdustStorage.getAddress(
                hyperdustStorage.genKey("serviceAccount", id)
            ),
            hyperdustStorage.getAddress(hyperdustStorage.genKey("account", id)),
            uint256Array,
            hyperdustStorage.getBytes1(hyperdustStorage.genKey("status", id)),
            hyperdustStorage.getUintArray(
                hyperdustStorage.genKey("epochAmounts", id)
            ),
            hyperdustStorage.getUintArray(
                hyperdustStorage.genKey("epochTimes", id)
            )
        );
    }

    function getRuningRenderTranscitions()
        public
        view
        returns (uint256[] memory)
    {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        return hyperdustStorage.getUintArray("runingRenderTranscitions");
    }

    function getRuningRenderAccounts(
        address account
    ) public view returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        return hyperdustStorage.getUint(account.toHexString());
    }

    function getRuningRenderNodes(
        uint256 nodeId
    ) public view returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        return hyperdustStorage.getUint(nodeId.toString());
    }
}
