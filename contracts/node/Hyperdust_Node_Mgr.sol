pragma solidity ^0.8.0;

abstract contract IHyperdustNodeCheckIn {
    function check(address incomeAddress) public view returns (bool) {}
}

abstract contract IHyperdustRolesCfg {
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

contract Hyperdust_Node_Mgr is Ownable {
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
        uint256[] uint256Array; //id,nodeType,cpuNum,memoryNum,diskNum,cudaNum,videoMemory
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

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _nodeCheckInAddress = contractaddressArray[1];
        _nodeTypeAddress = contractaddressArray[2];
    }

    function addNode(
        address incomeAddress,
        string memory ip,
        uint256[] memory hardwareInfos
    ) public returns (uint256) {
        INodeType nodeType = INodeType(_nodeTypeAddress);

        for (uint256 i = 0; i < _nodes.length; i++) {
            if (StrUtil.equals(_nodes[i].ip.toSlice(), ip.toSlice())) {
                revert("ip already exists");
            }
        }

        IHyperdustNodeCheckIn minerNodeCheck = IHyperdustNodeCheckIn(
            _nodeCheckInAddress
        );

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

        _nodeIds.increment();

        uint256 nodeId = _nodeIds.current();

        add(nodeId, nodeTypeId, incomeAddress, ip, hardwareInfos);

        return nodeId;
    }

    function add(
        uint256 id,
        uint256 nodeTypeId,
        address incomeAddress,
        string memory ip,
        uint256[] memory hardwareInfos
    ) private {
        uint256[] memory uint256Array = new uint256[](8);
        uint256Array[0] = id;
        uint256Array[1] = nodeTypeId;
        uint256Array[2] = hardwareInfos[0];
        uint256Array[3] = hardwareInfos[1];
        uint256Array[4] = hardwareInfos[2];
        uint256Array[5] = hardwareInfos[3];
        uint256Array[6] = hardwareInfos[4];

        Node memory node = Node(incomeAddress, ip, uint256Array);

        _nodes.push(node);

        emit eveSave(id);
    }

    function getNode(
        uint256 id
    ) public view returns (address, string memory, uint256[] memory) {
        for (uint i = 0; i < _nodes.length; i++) {
            if (_nodes[i].uint256Array[0] == id) {
                Node memory node = _nodes[i];
                return (node.incomeAddress, node.ip, _nodes[i].uint256Array);
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

    function deleteNode(uint256 id) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
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
}
