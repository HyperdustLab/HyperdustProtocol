pragma solidity ^0.8.0;

abstract contract IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {}

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {}

    function balanceOf(address account) external view returns (uint256) {}

    function approve(address spender, uint256 amount) external returns (bool) {}
}

abstract contract IMGNNodeMgr {
    function getNodeById(uint256 id) public view returns (Node memory) {}

    function updateStatus(uint256 nodeId, string memory status) public {}

    struct Node {
        address incomeAddress;
        string ip;
        string status;
        uint256 nodeType;
        uint256 price;
        uint256 id;
        uint256 cpuNum;
        uint256 memoryNum;
        uint256 diskNum;
        uint256 cudaNum;
        uint256 videoMemory;
    }
}

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract ISettlementRules {
    struct SettlementRules {
        address settlementAddress;
        uint256 settlementRatio;
    }

    function getSettlementRules()
        public
        view
        returns (SettlementRules[] memory)
    {}
}

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import {StrUtil} from "./utils/StrUtil.sol";

contract MGN_Render_Transcition is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _orderIds;
    address public _rolesCfgAddress;
    address public _nodeAddress;
    address public _erc20Address;
    address public _settlementRulesAddress;
    address public _nodeMgrAddress;

    struct Order {
        address serviceAccount;
        address account;
        string status;
        uint256 time;
        uint256 price;
        uint256 amount;
        uint256 id;
        uint256 createTime;
        uint256 nodeId;
        uint256 endTime;
    }

    event eveAdd(
        address serviceAccount,
        address account,
        string status,
        uint256 time,
        uint256 price,
        uint256 amount,
        uint256 id,
        uint256 createTime,
        uint256 nodeId,
        uint256 endTime
    );

    event eveSettlement(
        string status,
        uint256 id,
        address[] settlementAddress,
        uint256[] settlementAmounts,
        uint256[] settlementRatios
    );

    Order[] public _orders;

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setSettlementRulesAddress(
        address settlementRulesAddress
    ) public onlyOwner {
        _settlementRulesAddress = settlementRulesAddress;
    }

    function setNodeAddress(address nodeAddress) public onlyOwner {
        _nodeAddress = nodeAddress;
    }

    function createOrder(
        uint256 nodeId,
        uint256 time
    ) public returns (uint256) {
        IMGNNodeMgr _nodeMgr = IMGNNodeMgr(_nodeAddress);

        IMGNNodeMgr.Node memory node = _nodeMgr.getNodeById(nodeId);

        require(
            StrUtil.equals(node.status.toSlice(), "0".toSlice()),
            "The miner node is not available"
        );

        IERC20 erc20 = IERC20(_erc20Address);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        require(amount >= node.price * time, "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, address(this), node.price * time);

        _nodeMgr.updateStatus(nodeId, "1");
        _orderIds.increment();

        uint256 createTime = block.timestamp;
        uint256 endTime = createTime + time * 60;

        Order memory order = Order(
            node.incomeAddress,
            msg.sender,
            "1",
            time,
            node.price,
            node.price * time,
            _orderIds.current(),
            createTime,
            nodeId,
            endTime
        );

        _orders.push(order);

        emit eveAdd(
            node.incomeAddress,
            msg.sender,
            "1",
            time,
            node.price,
            node.price * time,
            _orderIds.current(),
            createTime,
            order.nodeId,
            endTime
        );

        return _orderIds.current();
    }

    function settlementOrder(uint256 orderId) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        Order memory order;

        for (uint256 i = 0; i < _orders.length; i++) {
            if (_orders[i].id == orderId) {
                order = _orders[i];
                _orders[i].status = "2";
                break;
            }
        }

        require(order.id > 0, "order not found");

        require(
            StrUtil.equals(order.status.toSlice(), "1".toSlice()),
            "order status error"
        );

        require(block.timestamp >= order.endTime, "The order has not expired");

        ISettlementRules settlementRulesAddress = ISettlementRules(
            _settlementRulesAddress
        );

        ISettlementRules.SettlementRules[]
            memory settlementRulesList = settlementRulesAddress
                .getSettlementRules();

        uint256 amount = order.amount;
        IERC20 erc20 = IERC20(_erc20Address);

        erc20.approve(address(this), amount);

        address[] memory settlementAddress = new address[](
            settlementRulesList.length + 1
        );
        uint256[] memory settlementAmounts = new uint256[](
            settlementRulesList.length + 1
        );

        uint256[] memory settlementRatios = new uint256[](
            settlementRulesList.length + 1
        );

        uint256 totalRatio = 100;

        for (uint256 i = 0; i < settlementRulesList.length; i++) {
            uint256 settlementAmount = (order.amount *
                settlementRulesList[i].settlementRatio) / 100;

            erc20.transferFrom(
                address(this),
                settlementRulesList[i].settlementAddress,
                settlementAmount
            );

            settlementAddress[i] = settlementRulesList[i].settlementAddress;
            settlementAmounts[i] = settlementAmount;
            settlementRatios[i] = settlementRulesList[i].settlementRatio;

            amount = amount - settlementAmount;

            totalRatio = totalRatio - settlementRulesList[i].settlementRatio;
        }

        settlementAddress[settlementRulesList.length] = order.serviceAccount;
        settlementAmounts[settlementRulesList.length] = amount;
        settlementRatios[settlementRulesList.length] = totalRatio;

        IMGNNodeMgr _nodeMgr = IMGNNodeMgr(_nodeAddress);

        erc20.transferFrom(address(this), order.serviceAccount, amount);
        _nodeMgr.updateStatus(order.nodeId, "0");

        emit eveSettlement(
            "2",
            order.id,
            settlementAddress,
            settlementAmounts,
            settlementRatios
        );
    }
}
