// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";

abstract contract IHyperdustNodeProduct {
    function get(
        uint256 id
    ) public view returns (uint256, string memory, uint32, uint256) {}
}

contract Hyperdust_Node_Service is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;
    address public _erc20Address;
    address public _HyperdustNodeProductAddress;
    address public _creditedAccount;
    address public _HyperdustStorageAddress;

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function setHyperdustRolesCfgAddress(
        address HyperdustRolesCfgAddress
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setHyperdustNodeProductAddress(
        address HyperdustNodeProductAddress
    ) public onlyOwner {
        _HyperdustNodeProductAddress = HyperdustNodeProductAddress;
    }

    function setCreditedAccount(address creditedAccount) public onlyOwner {
        _creditedAccount = creditedAccount;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _HyperdustNodeProductAddress = contractaddressArray[2];
        _creditedAccount = contractaddressArray[3];
        _HyperdustStorageAddress = contractaddressArray[4];
    }

    function setHyperdustStorageAddress(
        address hyperdustStorageAddress
    ) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    event eveSave(uint256 id);

    mapping(address => uint256) _accountNodeService;

    function buy(uint256 id, uint32 num) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        (, , uint32 day, uint256 price) = IHyperdustNodeProduct(
            _HyperdustNodeProductAddress
        ).get(id);

        require(day > 0, "day must > 0");

        require(num > 0, "num must > 0");

        IERC20 erc20 = IERC20(_erc20Address);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        uint256 payAmount = price * num;

        require(amount >= payAmount, "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, _creditedAccount, payAmount);

        uint256 id = hyperdustStorage.getNextId();

        hyperdustStorage.setAddress(
            hyperdustStorage.genKey("account", id),
            msg.sender
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("status", id),
            "0x00"
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("payAmount", id),
            payAmount
        );

        hyperdustStorage.setUint(hyperdustStorage.genKey("price", id), price);

        hyperdustStorage.setUint(hyperdustStorage.genKey("num", id), num);

        hyperdustStorage.setUint(hyperdustStorage.genKey("day", id), day);

        emit eveSave(id);
    }

    function addAccountNodeService(
        address account,
        uint256 id,
        uint32 num
    ) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        (, , uint32 day, uint256 price) = IHyperdustNodeProduct(
            _HyperdustNodeProductAddress
        ).get(id);

        require(day > 0, "day must > 0");

        require(num > 0, "num must > 0");

        uint256 id = hyperdustStorage.getNextId();

        hyperdustStorage.setAddress(
            hyperdustStorage.genKey("account", id),
            msg.sender
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("status", id),
            "0x00"
        );

        hyperdustStorage.setUint(hyperdustStorage.genKey("price", id), price);

        hyperdustStorage.setUint(hyperdustStorage.genKey("num", id), num);

        hyperdustStorage.setUint(hyperdustStorage.genKey("day", id), day);

        emit eveSave(id);
    }

    function assignmentNode(
        uint256 id,
        uint256[] memory nodeIds,
        uint256[] memory nodeNums
    ) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        //require(_nodeServices[id - 1].status == 0x00, "status must be 0x00");

        uint256 num = hyperdustStorage.getUint(
            hyperdustStorage.genKey("num", id)
        );

        uint256 day = hyperdustStorage.getUint(
            hyperdustStorage.genKey("day", id)
        );

        for (uint32 i = 0; i < nodeNums.length; i++) {
            num = num - nodeNums[i];
        }

        require(num == 0, "Allocation error");

        hyperdustStorage.setUintArray(
            hyperdustStorage.genKey("nodeIds", id),
            nodeIds
        );

        hyperdustStorage.setUintArray(
            hyperdustStorage.genKey("nodeNums", id),
            nodeNums
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("status", id),
            "0x01"
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("startTime", id),
            block.timestamp
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("endTime", id),
            block.timestamp + day * 1 days
        );

        emit eveSave(id);
    }

    function get(
        uint256 id
    )
        public
        view
        returns (
            address,
            uint256[] memory,
            uint256[] memory,
            uint256[] memory,
            string memory,
            uint256,
            uint256
        )
    {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256[] memory uint256Array = new uint256[](5);
        uint256Array[0] = id;
        uint256Array[1] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("startTime", id)
        );

        uint256Array[2] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("endTime", id)
        );

        uint256Array[3] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("amount", id)
        );

        uint256Array[4] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("price", id)
        );

        address account = hyperdustStorage.getAddress(
            hyperdustStorage.genKey("account", id)
        );

        uint256[] memory nodeIds = hyperdustStorage.getUintArray(
            hyperdustStorage.genKey("nodeIds", id)
        );

        uint256[] memory nodeNums = hyperdustStorage.getUintArray(
            hyperdustStorage.genKey("nodeNums", id)
        );

        string memory status = hyperdustStorage.getString(
            hyperdustStorage.genKey("status", id)
        );

        uint256 num = hyperdustStorage.getUint(
            hyperdustStorage.genKey("num", id)
        );

        uint256 day = hyperdustStorage.getUint(
            hyperdustStorage.genKey("day", id)
        );

        return (account, nodeIds, uint256Array, nodeNums, status, num, day);
    }
}
