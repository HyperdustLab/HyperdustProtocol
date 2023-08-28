pragma solidity ^0.8.0;

abstract contract IMinerNodeCheck {
    function check(address incomeAddress) public view returns (bool) {}
}

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IResourceType {
    function getResourceTypeId(
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

import {StrUtil} from "./utils/StrUtil.sol";

contract MGN_Miner_Node is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _nodeIds;

    MinerNode[] public _minerNodes;

    address _minerNodeCheckAddress;
    address _roleAddress;
    address _resourceTypeAddress;

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

    function setMinerNodeCheckAddress(
        address minerNodeCheckAddress
    ) public onlyOwner {
        _minerNodeCheckAddress = minerNodeCheckAddress;
    }

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function setResourceTypeAddress(
        address resourceTypeAddress
    ) public onlyOwner {
        _resourceTypeAddress = resourceTypeAddress;
    }

    function addMinerNode(
        address incomeAddress,
        string memory ip,
        uint256 price,
        uint256[] memory hardwareInfos
    ) public returns (uint256) {
        IResourceType resourceType = IResourceType(_resourceTypeAddress);

        for (uint256 i = 0; i < _minerNodes.length; i++) {
            if (StrUtil.equals(_minerNodes[i].ip.toSlice(), ip.toSlice())) {
                revert("ip already exists");
            }
        }

        IMinerNodeCheck minerNodeCheck = IMinerNodeCheck(
            _minerNodeCheckAddress
        );

        require(
            minerNodeCheck.check(msg.sender),
            "Registration requirements not met"
        );

        uint256 resourceTypeId = resourceType.getResourceTypeId(
            hardwareInfos[0],
            hardwareInfos[1],
            hardwareInfos[2],
            hardwareInfos[3],
            hardwareInfos[4]
        );

        require(resourceTypeId > 0, "not found resource type");

        string memory status = "0";

        _nodeIds.increment();

        uint256 nodeId = _nodeIds.current();

        add(
            nodeId,
            resourceTypeId,
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
        MinerNode memory minerNode = MinerNode(
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

        _minerNodes.push(minerNode);

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

    function getMinerNodeById(
        uint256 id
    ) public view returns (MinerNode memory) {
        for (uint i = 0; i < _minerNodes.length; i++) {
            if (_minerNodes[i].id == id) {
                return _minerNodes[i];
            }
        }
    }

    function getMinerNodeByIp(
        string memory ip
    ) public view returns (MinerNode memory) {
        for (uint i = 0; i < _minerNodes.length; i++) {
            if (StrUtil.equals(_minerNodes[i].ip.toSlice(), ip.toSlice())) {
                return _minerNodes[i];
            }
        }
    }

    function updateStatus(uint256 nodeId, string memory status) public {
        IRole role = IRole(_roleAddress);

        require(role.hasAdminRole(msg.sender), "No permission");

        for (uint256 i = 0; i < _minerNodes.length; i++) {
            if (_minerNodes[i].id == nodeId) {
                _minerNodes[i].status = status;
                break;
            }
        }

        emit eveUpdateStatus(nodeId, status);
    }

    function updatePrice(uint256 id, uint256 price) public {
        IRole role = IRole(_roleAddress);

        for (uint256 i = 0; i < _minerNodes.length; i++) {
            if (_minerNodes[i].id == id) {
                require(
                    role.hasAdminRole(msg.sender) ||
                        _minerNodes[i].incomeAddress == msg.sender,
                    "No permission"
                );

                _minerNodes[i].price = price;
                break;
            }
        }

        emit eveUpdatePrice(id, price);
    }

    function deleteMinerNode(uint256 id) public {
        IRole role = IRole(_roleAddress);

        uint256 index = 0;

        for (uint256 i = 0; i < _minerNodes.length; i++) {
            if (_minerNodes[i].id == id) {
                require(
                    role.hasAdminRole(msg.sender) ||
                        _minerNodes[i].incomeAddress == msg.sender,
                    "No permission"
                );

                _minerNodes[i] = _minerNodes[_minerNodes.length - 1];
                _minerNodes.pop();

                emit eveDelete(id);

                break;
            }
        }
    }
}
