// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

abstract contract IHyperdustNodeProduct {
    function get(
        uint256 id
    ) public view returns (uint256, string memory, uint32, uint256) {}
}

contract Hyperdust_Node_Service is Ownable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;
    address public _erc20Address;
    address public _HyperdustNodeProductAddress;
    address public _creditedAccount;

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
    }

    using Counters for Counters.Counter;
    Counters.Counter private _id;

    struct NodeService {
        uint256 id;
        address account;
        uint256 startTime;
        uint256 endTime;
        uint256[] nodeIds;
        uint32[] nodeNums;
        bytes1 status;
        uint256 amount;
        uint256 price;
        uint32 num;
        uint32 day;
    }

    event eveSave(uint256 id);

    NodeService[] public _nodeServices;
    mapping(address => uint256) _accountNodeService;

    function buy(uint256 id, uint32 num) public {
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

        _id.increment();

        _nodeServices.push(
            NodeService(
                _id.current(),
                msg.sender,
                0,
                0,
                new uint256[](0),
                new uint32[](0),
                0x00,
                payAmount,
                price,
                num,
                day
            )
        );

        emit eveSave(_id.current());
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

        (, , uint32 day, uint256 price) = IHyperdustNodeProduct(
            _HyperdustNodeProductAddress
        ).get(id);

        require(day > 0, "day must > 0");

        require(num > 0, "num must > 0");

        _id.increment();

        _nodeServices.push(
            NodeService(
                _id.current(),
                account,
                0,
                0,
                new uint256[](0),
                new uint32[](0),
                0x00,
                0,
                price,
                num,
                day
            )
        );

        emit eveSave(_id.current());
    }

    function assignmentNode(
        uint256 id,
        uint256[] memory nodeIds,
        uint32[] memory nodeNums
    ) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        //require(_nodeServices[id - 1].status == 0x00, "status must be 0x00");

        uint32 num = _nodeServices[id - 1].num;

        for (uint32 i = 0; i < nodeNums.length; i++) {
            num = num - nodeNums[i];
        }

        require(num == 0, "Allocation error");

        _nodeServices[id - 1].nodeIds = nodeIds;
        _nodeServices[id - 1].nodeNums = nodeNums;
        _nodeServices[id - 1].status = 0x01;
        _nodeServices[id - 1].startTime = block.timestamp;
        _nodeServices[id - 1].endTime =
            block.timestamp +
            _nodeServices[id - 1].day *
            1 days;

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
            uint32[] memory,
            bytes1,
            uint32,
            uint32
        )
    {
        NodeService memory nodeService = _nodeServices[id - 1];

        uint256[] memory uint256Array = new uint256[](5);
        uint256Array[0] = nodeService.id;
        uint256Array[1] = nodeService.startTime;
        uint256Array[2] = nodeService.endTime;
        uint256Array[3] = nodeService.amount;
        uint256Array[4] = nodeService.price;
        return (
            nodeService.account,
            nodeService.nodeIds,
            uint256Array,
            nodeService.nodeNums,
            nodeService.status,
            nodeService.num,
            nodeService.day
        );
    }
}
