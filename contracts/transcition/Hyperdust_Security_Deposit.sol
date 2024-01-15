pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../utils/StrUtil.sol";

import "../Hyperdust_Storage.sol";

import "../node/Hyperdust_Node_Mgr.sol";

abstract contract IHyperdustNodeMgr {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_Security_Deposit is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _erc20Address;
    address public _HyperdustStorageAddress;
    address public _HyperdustNodeMgrAddress;
    uint32 public _withdrawalInterval;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
        _withdrawalInterval = 30 days;
    }

    event eveSave(uint256 nodeId, uint256 totalSecurityAmount);

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setHyperdustStorageAddress(
        address hyperdustStorageAddress
    ) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setERC20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setHyperdustNodeMgrAddress(
        address HyperdustNodeMgrAddress
    ) public onlyOwner {
        _HyperdustNodeMgrAddress = HyperdustNodeMgrAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _HyperdustStorageAddress = contractaddressArray[2];
        _HyperdustNodeMgrAddress = contractaddressArray[3];
    }

    function addSecurityDeposit(uint256 nodeId, uint256 amount) public {
        require(
            IHyperdustNodeMgr(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        Hyperdust_Node_Mgr hyperdustNodeMgr = Hyperdust_Node_Mgr(
            _HyperdustNodeMgrAddress
        );

        (address incomeAddress, , ) = hyperdustNodeMgr.getNode(nodeId);

        string memory key = nodeId.toString();

        uint256 _amount = hyperdustStorage.getUint(key) + amount;

        hyperdustStorage.setUint(key, _amount);

        hyperdustStorage.setUint(
            incomeAddress.toHexString(),
            hyperdustStorage.getUint(incomeAddress.toHexString()) + amount
        );

        string memory incomeAddressIndexKey = incomeAddress
            .toHexString()
            .toSlice()
            .concat("_index".toSlice());

        uint256 incomeAddressIndex = hyperdustStorage.getUint(
            incomeAddressIndexKey
        );

        if (incomeAddressIndex == 0) {
            hyperdustStorage.setAddressArray(
                "incomeAddressList",
                incomeAddress
            );

            uint256 incomeAddressListTotal = hyperdustStorage.getUint(
                "incomeAddressListTotal"
            );

            hyperdustStorage.setUint(
                incomeAddressIndexKey,
                incomeAddressListTotal
            );

            incomeAddressListTotal++;

            hyperdustStorage.setUint(
                "incomeAddressListTotal",
                incomeAddressListTotal + 1
            );
        }

        emit eveSave(nodeId, _amount);
    }

    function applyWithdrawal(uint256 nodeId) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        Hyperdust_Node_Mgr hyperdustNodeMgr = Hyperdust_Node_Mgr(
            _HyperdustNodeMgrAddress
        );

        (address incomeAddress, , ) = hyperdustNodeMgr.getNode(nodeId);

        require(incomeAddress == msg.sender, "not income address");

        string memory key = hyperdustStorage.genKey("applyWithdrawal_", nodeId);

        uint256 time = hyperdustStorage.getUint(key);

        require(time == 0, "already apply");

        hyperdustStorage.setUint(key, block.timestamp);

        hyperdustNodeMgr.updateStatus(nodeId, true);
    }

    function cancelWithdrawal(uint256 nodeId) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        Hyperdust_Node_Mgr hyperdustNodeMgr = Hyperdust_Node_Mgr(
            _HyperdustNodeMgrAddress
        );

        (address incomeAddress, , ) = hyperdustNodeMgr.getNode(nodeId);

        require(incomeAddress == msg.sender, "not income address");

        string memory key = hyperdustStorage.genKey("applyWithdrawal_", nodeId);

        hyperdustStorage.setUint(key, 0);

        hyperdustNodeMgr.updateStatus(nodeId, false);
    }

    function withdrawal(uint256 nodeId) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        Hyperdust_Node_Mgr hyperdustNodeMgr = Hyperdust_Node_Mgr(
            _HyperdustNodeMgrAddress
        );

        (address incomeAddress, , ) = hyperdustNodeMgr.getNode(nodeId);

        require(incomeAddress == msg.sender, "not income address");

        uint256 amount = hyperdustStorage.getUint(nodeId.toString());

        require(amount > 0, "There is no amount to withdraw");

        string memory applyWithdrawalKey = hyperdustStorage.genKey(
            "applyWithdrawal_",
            nodeId
        );

        uint256 applyWithdrawalTime = hyperdustStorage.getUint(
            applyWithdrawalKey
        );

        require(
            applyWithdrawalTime > 0 &&
                applyWithdrawalTime + _withdrawalInterval < block.timestamp,
            "not apply withdrawal or not reach withdrawal time"
        );

        hyperdustStorage.setUint(applyWithdrawalKey, 0);

        hyperdustStorage.setUint(nodeId.toString(), 0);

        string memory incomeAddressKey = incomeAddress.toHexString();

        uint256 incomeAddressAmount = hyperdustStorage.getUint(
            incomeAddressKey
        );

        incomeAddressAmount -= amount;

        hyperdustStorage.setUint(incomeAddressKey, incomeAddressAmount);

        if (incomeAddressAmount == 0) {
            uint256 incomeAddressListTotal = hyperdustStorage.getUint(
                "incomeAddressListTotal"
            );

            incomeAddressListTotal--;

            string memory incomeAddressIndexKey = incomeAddress
                .toHexString()
                .toSlice()
                .concat("_index".toSlice());

            uint256 incomeAddressIndex = hyperdustStorage.getUint(
                incomeAddressIndexKey
            );

            hyperdustStorage.removeAddressArray(
                "incomeAddressList",
                incomeAddressIndex
            );

            if (
                incomeAddressListTotal > 0 ||
                incomeAddressIndex != incomeAddressListTotal
            ) {
                address newAddress = hyperdustStorage.getAddressArray(
                    "incomeAddressList"
                )[incomeAddressIndex];

                hyperdustStorage.setAddress(incomeAddressIndexKey, newAddress);
            }

            hyperdustStorage.setUint(
                "incomeAddressListTotal",
                incomeAddressListTotal
            );
        }

        IERC20(_erc20Address).transfer(incomeAddress, amount);
    }

    function getNodeSecurityDeposit(
        uint256 nodeId
    ) public view returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        return hyperdustStorage.getUint(nodeId.toString());
    }

    function getIncomeAddressList() public view returns (address[] memory) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        return hyperdustStorage.getAddressArray("incomeAddressList");
    }

    function getSecurityDeposit(address account) public view returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        return hyperdustStorage.getUint(account.toHexString());
    }
}
