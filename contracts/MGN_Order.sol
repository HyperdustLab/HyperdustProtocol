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

abstract contract IMinerNode {
    function getMinerNodeById(
        uint256 id
    ) public view returns (MinerNode memory) {}

    function updateStatus(uint256 nodeId, string memory status) public {}

    struct MinerNode {
        address incomeAddress; //收益钱包地址
        string ip; //节点公网IP
        string status; //状态：0 未使用  -1：限制使用  1：使用中
        uint256 nodeType; //节点资源等级
        uint256 price; //服务单价
        uint256 id;
        uint256 cpuNum; //CPU核心数量
        uint256 memoryNum; //内存大小
        uint256 diskNum; //硬盘大小
        uint256 cudaNum; //cuda核心数量
        uint256 videoMemory; //显存大小
    }
}

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract ISettlementRules {
    struct SettlementRules {
        address settlementAddress; //结算地址
        uint256 settlementRatio; //结算比例
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

contract MGN_Order is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _orderIds;
    address public _roleAddress;
    address public _minerNodeAddress;
    address public _erc20Address;
    address public _settlementRulesAddress;

    struct Order {
        address serviceAccount; //服务账号
        address account; //购买账号
        string status; //订单状态（1：进行中 -1：订单异常  2：已完成）
        uint256 time; //服务时长
        uint256 price; //服务单价
        uint256 amount; //订单总价
        uint256 id; //订单ID
        uint256 createTime; //订单创建时间
        uint256 minerNodeId; //矿机节点ID
        uint256 endTime; //订单结束时间
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
        uint256 minerNodeId,
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

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setMinerNodeAddress(address minerNodeAddress) public onlyOwner {
        _minerNodeAddress = minerNodeAddress;
    }

    function setSettlementRulesAddress(
        address settlementRulesAddress
    ) public onlyOwner {
        _settlementRulesAddress = settlementRulesAddress;
    }

    function createOrder(
        uint256 minerNodeId,
        uint256 time
    ) public returns (uint256) {
        IMinerNode _minerNode = IMinerNode(_minerNodeAddress);

        IMinerNode.MinerNode memory minerNode = _minerNode.getMinerNodeById(
            minerNodeId
        );

        require(
            StrUtil.equals(minerNode.status.toSlice(), "0".toSlice()),
            "The miner node is not available"
        );

        IERC20 erc20 = IERC20(_erc20Address);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        require(
            amount >= minerNode.price * time,
            "Insufficient authorized amount"
        );

        erc20.transferFrom(msg.sender, address(this), minerNode.price * time);

        _minerNode.updateStatus(minerNodeId, "1");
        _orderIds.increment();

        uint256 createTime = block.timestamp;
        uint256 endTime = createTime + time * 60;

        Order memory order = Order(
            minerNode.incomeAddress,
            msg.sender,
            "1",
            time,
            minerNode.price,
            minerNode.price * time,
            _orderIds.current(),
            createTime,
            minerNodeId,
            endTime
        );

        _orders.push(order);

        emit eveAdd(
            minerNode.incomeAddress,
            msg.sender,
            "1",
            time,
            minerNode.price,
            minerNode.price * time,
            _orderIds.current(),
            createTime,
            order.minerNodeId,
            endTime
        );

        return _orderIds.current();
    }

    function settlementOrder(uint256 orderId) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

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

        IMinerNode _minerNode = IMinerNode(_minerNodeAddress);

        erc20.transferFrom(address(this), order.serviceAccount, amount);
        _minerNode.updateStatus(order.minerNodeId, "0");

        emit eveSettlement(
            "2",
            order.id,
            settlementAddress,
            settlementAmounts,
            settlementRatios
        );
    }
}
