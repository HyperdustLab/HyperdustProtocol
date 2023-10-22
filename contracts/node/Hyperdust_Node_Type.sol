pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../utils/StrUtil.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_Node_Type is Ownable {
    address public _rolesCfgAddress;

    using Counters for Counters.Counter;
    Counters.Counter private _id;
    using Strings for *;
    using StrUtil for *;

    struct NodeType {
        uint256 id;
        uint256 orderNum;
        string name;
        uint256 cpuNum;
        uint256 memoryNum;
        uint256 diskNum;
        uint256 cudaNum;
        uint256 videoMemory;
        string coverImage;
        string frameRate;
        string remark;
    }

    event eveSave(uint256 id);

    event eveDelete(uint256 id);

    NodeType[] public _nodeTypes;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function addNodeType(
        uint256 orderNum,
        string memory name,
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory,
        string memory coverImage,
        string memory frameRate,
        string memory remark
    ) public returns (uint256) {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        _id.increment();
        uint256 id = _id.current();

        NodeType memory nodeType = NodeType(
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

        _nodeTypes.push(nodeType);

        emit eveSave(id);
        return id;
    }

    function updateNodeType(
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
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint256 i = 0; i < _nodeTypes.length; i++) {
            if (_nodeTypes[i].id == id) {
                _nodeTypes[i].orderNum = orderNum;
                _nodeTypes[i].name = name;
                _nodeTypes[i].cpuNum = cpuNum;
                _nodeTypes[i].memoryNum = memoryNum;
                _nodeTypes[i].diskNum = diskNum;
                _nodeTypes[i].cudaNum = cudaNum;
                _nodeTypes[i].videoMemory = videoMemory;
                _nodeTypes[i].coverImage = coverImage;
                _nodeTypes[i].frameRate = frameRate;
                _nodeTypes[i].remark = remark;
                break;
            }
        }

        emit eveSave(id);
    }

    function getNodeType(
        uint256 id
    ) public view returns (uint256[] memory, string[] memory) {
        for (uint i = 0; i < _nodeTypes.length; i++) {
            if (_nodeTypes[i].id == id) {
                NodeType memory nodeType = _nodeTypes[i];

                string[] memory strArray = new string[](4);
                uint256[] memory uint256Array = new uint256[](7);

                strArray[0] = nodeType.name;
                strArray[1] = nodeType.coverImage;
                strArray[2] = nodeType.frameRate;
                strArray[3] = nodeType.remark;

                uint256Array[0] = nodeType.id;
                uint256Array[1] = nodeType.orderNum;
                uint256Array[2] = nodeType.cpuNum;
                uint256Array[3] = nodeType.memoryNum;
                uint256Array[4] = nodeType.diskNum;
                uint256Array[5] = nodeType.cudaNum;
                uint256Array[6] = nodeType.videoMemory;

                return (uint256Array, strArray);
            }
        }

        revert("Node Type does not exist");
    }

    function deleteNodeType(uint256 id) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        uint256 index = 0;

        for (uint i = 0; i < _nodeTypes.length; i++) {
            if (_nodeTypes[i].id == id) {
                index = i + 1;
                break;
            }
        }

        require(index > 0, "not found");
        _nodeTypes[index - 1] = _nodeTypes[_nodeTypes.length - 1];
        _nodeTypes.pop();

        emit eveDelete(id);
    }

    function getNodeTypeId(
        uint256 cpuNum,
        uint256 memoryNum,
        uint256 diskNum,
        uint256 cudaNum,
        uint256 videoMemory
    ) public view returns (uint256) {
        NodeType[] memory sortedData = _nodeTypes;
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
            NodeType memory nodeType = sortedData[i];

            if (
                cpuNum >= nodeType.cpuNum &&
                memoryNum >= nodeType.memoryNum &&
                diskNum >= nodeType.diskNum &&
                cudaNum >= nodeType.cudaNum &&
                videoMemory >= nodeType.videoMemory
            ) {
                min = nodeType.id;

                break;
            }
        }

        return min;
    }
}
