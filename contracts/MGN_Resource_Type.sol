pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Resource_Type is Ownable {
    address _roleAddress;

    using Counters for Counters.Counter;
    Counters.Counter private _id;
    using Strings for *;
    using StrUtil for *;

    struct ResourceType {
        uint256 id; //资源分类ID
        uint256 orderNum; //资源分类排序
        string name; //资源分类名称
        uint256 cpuNum; //CPU核心数量
        uint256 memoryNum; //内存大小
        uint256 diskNum; //硬盘大小
        uint256 cudaNum; //cuda核心数量
        uint256 videoMemory; //显存大小
        string coverImage; //封面图片
        string frameRate; //帧率范围
        string remark; //描述
    }

    event eveAdd(
        uint256 id,
        uint256 orderNum,
        string name,
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory,
        string coverImage,
        string frameRate,
        string remark
    );

    event eveUpdate(
        uint256 id,
        uint256 orderNum,
        string name,
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory,
        string coverImage,
        string frameRate,
        string remark
    );

    event eveDelete(uint256 id);

    ResourceType[] public _resourceTypes;

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function addResourceType(
        uint256 orderNum,
        string memory name,
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory,
        string memory coverImage, //封面图片
        string memory frameRate, //帧率范围
        string memory remark //描述
    ) public returns (uint256) {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

        _id.increment();
        uint256 id = _id.current();

        ResourceType memory resourceType = ResourceType(
            id,
            orderNum,
            name,
            cpuNum,
            memoryNum,
            diskNum,
            cudaNum,
            videoMemory,
            coverImage,
            frameRate,
            remark
        );

        _resourceTypes.push(resourceType);

        emit eveAdd(
            id,
            orderNum,
            name,
            cpuNum,
            memoryNum,
            diskNum,
            cudaNum,
            videoMemory,
            coverImage,
            frameRate,
            remark
        );
        return id;
    }

    function updateResourceType(
        uint256 id,
        uint256 orderNum,
        string memory name,
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory,
        string memory coverImage, //封面图片
        string memory frameRate, //帧率范围
        string memory remark //描述
    ) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

        for (uint256 i = 0; i < _resourceTypes.length; i++) {
            if (_resourceTypes[i].id == id) {
                _resourceTypes[i].orderNum = orderNum;
                _resourceTypes[i].name = name;
                _resourceTypes[i].cpuNum = cpuNum;
                _resourceTypes[i].memoryNum = memoryNum;
                _resourceTypes[i].diskNum = diskNum;
                _resourceTypes[i].cudaNum = cudaNum;
                _resourceTypes[i].videoMemory = videoMemory;
                break;
            }
        }

        emit eveUpdate(
            id,
            orderNum,
            name,
            cpuNum,
            memoryNum,
            diskNum,
            cudaNum,
            videoMemory,
            coverImage,
            frameRate,
            remark
        );
    }

    function deleteResourceType(uint256 id) public {
        require(IRole(_roleAddress).hasAdminRole(msg.sender), "not admin role");

        uint256 index = 0;

        for (uint i = 0; i < _resourceTypes.length; i++) {
            if (_resourceTypes[i].id == id) {
                index = i + 1;
                break;
            }
        }

        require(index > 0, "not found");
        _resourceTypes[index - 1] = _resourceTypes[_resourceTypes.length - 1];
        _resourceTypes.pop();

        emit eveDelete(id);
    }

    function getResourceTypeId(
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory
    ) public view returns (uint256) {
        ResourceType[] memory sortedData = _resourceTypes;
        uint n = sortedData.length;

        if (n > 1) {
            for (uint i = 0; i < n - 1; i++) {
                for (uint j = 0; j < n - i - 1; j++) {
                    if (sortedData[j].orderNum < sortedData[j + 1].orderNum) {
                        // 交换元素
                        (sortedData[j], sortedData[j + 1]) = (
                            sortedData[j + 1],
                            sortedData[j]
                        );
                    }
                }
            }
        }

        uint256 min = 0;

        for (uint i = 0; i < n; i++) {
            ResourceType memory resourceType = sortedData[i];

            if (
                cpuNum >= resourceType.cpuNum &&
                memoryNum >= resourceType.memoryNum &&
                diskNum >= resourceType.diskNum &&
                cudaNum >= resourceType.cudaNum &&
                videoMemory >= resourceType.videoMemory
            ) {
                min = resourceType.id;

                break;
            }
        }

        return min;
    }
}
