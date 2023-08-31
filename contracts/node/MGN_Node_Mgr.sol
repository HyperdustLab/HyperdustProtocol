pragma solidity ^0.8.0;

abstract contract IMGNNodeCheckIn {
    function check(address incomeAddress) public view returns (bool) {}
}

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract INodeType {
    function getNodeTypeId(
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory
    ) public view returns (uint256) {}
}

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import {StrUtil} from "../utils/StrUtil.sol";

contract MGN_Node_Mgr is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _nodeIds;

    Node[] public _nodes;

    address public _nodeCheckInAddress;
    address public _rolesCfgAddress;
    address public _nodeTypeAddress;

    struct Node {
        address incomeAddress;
        string ip; //Node public network IP
        string status; //Status: 0 unused -1: limited use 1: in use
        uint256 nodeType; //Node resource level
        uint256 price; //Price
        uint256 id; //Node ID
        uint256 cpuNum; //CPUS
        uint256 memoryNum; //memory size
        uint256 diskNum; //HDD size
        uint256 cudaNum; //Number of CUDA Cores
        uint256 videoMemory; //Memory Size
    }

    event eveAdd(
        address incomeAddress,
        string ip,
        string status,
        uint256 nodeType,
        uint256 price,
        uint256 id,
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory
    );

    event eveUpdateStatus(uint256 id, string status);

    event eveUpdatePrice(uint256 id, uint256 price);

    event eveDelete(uint256 id);

    function setNodeCheckInAddress(
        address nodeCheckInAddress
    ) public onlyOwner {
        _nodeCheckInAddress = nodeCheckInAddress;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setNodeTypeAddress(address nodeTypeAddress) public onlyOwner {
        _nodeTypeAddress = nodeTypeAddress;
    }

    function addNode(
        address incomeAddress,
        string memory ip,
        uint256 price,
        uint256[] memory hardwareInfos
    ) public returns (uint256) {
        INodeType nodeType = INodeType(_nodeTypeAddress);

        for (uint256 i = 0; i < _nodes.length; i++) {
            if (StrUtil.equals(_nodes[i].ip.toSlice(), ip.toSlice())) {
                revert("ip already exists");
            }
        }

        IMGNNodeCheckIn minerNodeCheck = IMGNNodeCheckIn(_nodeCheckInAddress);

        require(
            minerNodeCheck.check(msg.sender),
            "Registration requirements not met"
        );

        uint256 nodeTypeId = nodeType.getNodeTypeId(
            hardwareInfos[0],
            hardwareInfos[1],
            hardwareInfos[2],
            hardwareInfos[3],
            hardwareInfos[4]
        );

        require(nodeTypeId > 0, "not found node type");

        string memory status = "0";

        _nodeIds.increment();

        uint256 nodeId = _nodeIds.current();

        add(
            nodeId,
            nodeTypeId,
            incomeAddress,
            status,
            ip,
            price,
            hardwareInfos
        );

        return nodeId;
    }

    function add(
        uint256 id,
        uint256 nodeTypeId,
        address incomeAddress,
        string memory status,
        string memory ip,
        uint256 price,
        uint256[] memory hardwareInfos
    ) private {
        Node memory node = Node(
            incomeAddress,
            ip,
            status,
            nodeTypeId,
            price,
            id,
            hardwareInfos[0],
            hardwareInfos[1],
            hardwareInfos[2],
            hardwareInfos[3],
            hardwareInfos[4]
        );

        _nodes.push(node);

        emit eveAdd(
            incomeAddress,
            ip,
            status,
            nodeTypeId,
            price,
            id,
            hardwareInfos[0],
            hardwareInfos[1],
            hardwareInfos[2],
            hardwareInfos[3],
            hardwareInfos[4]
        );
    }

    function getNodeById(uint256 id) public view returns (Node memory) {
        for (uint i = 0; i < _nodes.length; i++) {
            if (_nodes[i].id == id) {
                return _nodes[i];
            }
        }
    }

    function getNodeByIp(string memory ip) public view returns (Node memory) {
        for (uint i = 0; i < _nodes.length; i++) {
            if (StrUtil.equals(_nodes[i].ip.toSlice(), ip.toSlice())) {
                return _nodes[i];
            }
        }
    }

    function updateStatus(uint256 nodeId, string memory status) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint256 i = 0; i < _nodes.length; i++) {
            if (_nodes[i].id == nodeId) {
                _nodes[i].status = status;
                break;
            }
        }

        emit eveUpdateStatus(nodeId, status);
    }

    function updatePrice(uint256 id, uint256 price) public {
        for (uint256 i = 0; i < _nodes.length; i++) {
            if (_nodes[i].id == id) {
                require(_nodes[i].incomeAddress == msg.sender, "No permission");
                _nodes[i].price = price;
                break;
            }
        }

        emit eveUpdatePrice(id, price);
    }

    function deleteMinerNode(uint256 id) public {
        IMGNRolesCfg role = IMGNRolesCfg(_rolesCfgAddress);
        uint256 index = 0;

        for (uint256 i = 0; i < _nodes.length; i++) {
            if (_nodes[i].id == id) {
                require(
                    role.hasAdminRole(msg.sender) ||
                        _nodes[i].incomeAddress == msg.sender,
                    "No permission"
                );

                _nodes[i] = _nodes[_nodes.length - 1];
                _nodes.pop();

                emit eveDelete(id);

                break;
            }
        }
    }
}
