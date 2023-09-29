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
        uint256[] uint256Array; //id,nodeType,price,cpuNum,memoryNum,diskNum,cudaNum,videoMemory
    }

    event eveSave(uint256 id);

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
        uint256[] memory uint256Array = new uint256[](8);
        uint256Array[0] = id;
        uint256Array[1] = nodeTypeId;
        uint256Array[2] = price;
        uint256Array[3] = hardwareInfos[0];
        uint256Array[4] = hardwareInfos[1];
        uint256Array[5] = hardwareInfos[2];
        uint256Array[6] = hardwareInfos[3];
        uint256Array[7] = hardwareInfos[4];

        Node memory node = Node(incomeAddress, ip, status, uint256Array);

        _nodes.push(node);

        emit eveSave(id);
    }

    function getNode(
        uint256 id
    )
        public
        view
        returns (address, string memory, string memory, uint256[] memory)
    {
        for (uint i = 0; i < _nodes.length; i++) {
            if (_nodes[i].uint256Array[0] == id) {
                Node memory node = _nodes[i];
                return (
                    node.incomeAddress,
                    node.ip,
                    node.status,
                    _nodes[i].uint256Array
                );
            }
        }
        revert("node not found");
    }

    function getNodeObj(uint256 id) public view returns (Node memory) {
        for (uint i = 0; i < _nodes.length; i++) {
            if (_nodes[i].uint256Array[0] == id) {
                Node memory node = _nodes[i];
                return node;
            }
        }

        revert("node not found");
    }

    function updateStatus(uint256 nodeId, string memory status) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint256 i = 0; i < _nodes.length; i++) {
            if (_nodes[i].uint256Array[0] == nodeId) {
                _nodes[i].status = status;
                emit eveSave(nodeId);
                return;
            }
        }

        revert("node not found");
    }

    function updatePrice(uint256 id, uint256 price) public {
        for (uint256 i = 0; i < _nodes.length; i++) {
            if (_nodes[i].uint256Array[0] == id) {
                require(_nodes[i].incomeAddress == msg.sender, "No permission");
                _nodes[i].uint256Array[2] = price;

                emit eveSave(id);
                return;
            }
        }

        revert("node not found");
    }

    function deleteNode(uint256 id) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint256 i = 0; i < _nodes.length; i++) {
            if (_nodes[i].uint256Array[0] == id) {
                _nodes[i] = _nodes[_nodes.length - 1];
                _nodes.pop();

                emit eveDelete(id);

                return;
            }
        }
        revert("node not found");
    }

    function count() public view returns (uint256, uint256) {
        uint256 total = _nodes.length;
        uint256 useToatl = 0;

        for (uint256 i = 0; i < _nodes.length; i++) {
            if (StrUtil.equals(_nodes[i].status.toSlice(), "1".toSlice())) {
                useToatl++;
            }
        }

        return (total, useToatl);
    }
}
