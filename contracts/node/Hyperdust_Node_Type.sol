pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

//The node types are reserved for future extension
contract Hyperdust_Node_Type is OwnableUpgradeable {
    address public _rolesCfgAddress;
    address public _HyperdustStorageAddress;

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

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    event eveSave(uint256 id);

    event eveDelete(uint256 id);

    uint256[] public _ids;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setHyperdustStorageAddress(address hyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function addNodeType(uint256 orderNum, string memory name, uint256 cpuNum, uint256 memoryNum, uint256 diskNum, uint256 cudaNum, uint256 videoMemory, string memory coverImage, string memory frameRate, string memory remark) public returns (uint256) {
        require(IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        uint256 id = hyperdustStorage.getNextId();

        _ids.push(id);

        hyperdustStorage.setUint(hyperdustStorage.genKey("orderNum", id), orderNum);

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setUint(hyperdustStorage.genKey("cpuNum", id), cpuNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("memoryNum", id), memoryNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("diskNum", id), diskNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("cudaNum", id), cudaNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("videoMemory", id), videoMemory);
        hyperdustStorage.setString(hyperdustStorage.genKey("coverImage", id), coverImage);
        hyperdustStorage.setString(hyperdustStorage.genKey("frameRate", id), frameRate);
        hyperdustStorage.setString(hyperdustStorage.genKey("remark", id), remark);
        emit eveSave(id);
        return id;
    }

    function updateNodeType(uint256 id, uint256 orderNum, string memory name, uint256 cpuNum, uint256 memoryNum, uint256 diskNum, uint256 cudaNum, uint256 videoMemory, string memory coverImage, string memory frameRate, string memory remark) public {
        require(IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        string memory _name = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        require(bytes(_name).length > 0, "not found");

        hyperdustStorage.setUint(hyperdustStorage.genKey("orderNum", id), orderNum);

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setUint(hyperdustStorage.genKey("cpuNum", id), cpuNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("memoryNum", id), memoryNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("diskNum", id), diskNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("cudaNum", id), cudaNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("videoMemory", id), videoMemory);
        hyperdustStorage.setString(hyperdustStorage.genKey("coverImage", id), coverImage);
        hyperdustStorage.setString(hyperdustStorage.genKey("frameRate", id), frameRate);
        hyperdustStorage.setString(hyperdustStorage.genKey("remark", id), remark);

        emit eveSave(id);
    }

    function getNodeType(uint256 id) public view returns (uint256[] memory, string[] memory) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);
        string[] memory strArray = new string[](4);
        uint256[] memory uint256Array = new uint256[](7);

        strArray[0] = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        require(bytes(strArray[0]).length > 0, "not found");

        strArray[1] = hyperdustStorage.getString(hyperdustStorage.genKey("coverImage", id));
        strArray[2] = hyperdustStorage.getString(hyperdustStorage.genKey("frameRate", id));
        strArray[3] = hyperdustStorage.getString(hyperdustStorage.genKey("remark", id));

        uint256Array[0] = id;
        uint256Array[1] = hyperdustStorage.getUint(hyperdustStorage.genKey("orderNum", id));

        uint256Array[2] = hyperdustStorage.getUint(hyperdustStorage.genKey("cpuNum", id));
        uint256Array[3] = hyperdustStorage.getUint(hyperdustStorage.genKey("memoryNum", id));

        uint256Array[4] = hyperdustStorage.getUint(hyperdustStorage.genKey("diskNum", id));

        uint256Array[5] = hyperdustStorage.getUint(hyperdustStorage.genKey("nodeType", id));

        uint256Array[6] = hyperdustStorage.getUint(hyperdustStorage.genKey("videoMemory", id));

        return (uint256Array, strArray);
    }

    function deleteNodeType(uint256 id) public {
        require(IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        string memory name = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        require(bytes(name).length > 0, "not found");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), "");

        emit eveDelete(id);
    }

    function getNodeTypeList() public view returns (NodeType[] memory) {
        NodeType[] memory list = new NodeType[](_ids.length);
        for (uint i = 0; i < _ids.length; i++) {
            uint256 id = _ids[i];
            (uint256[] memory uint256Array, string[] memory strArray) = getNodeType(id);
            list[i] = NodeType(uint256Array[0], uint256Array[1], strArray[0], uint256Array[2], uint256Array[3], uint256Array[4], uint256Array[5], uint256Array[6], strArray[1], strArray[2], strArray[3]);
        }

        return list;
    }

    function getNodeTypeId(uint256 cpuNum, uint256 memoryNum, uint256 diskNum, uint256 cudaNum, uint256 videoMemory) public view returns (uint256) {
        NodeType[] memory sortedData = getNodeTypeList();
        uint n = sortedData.length;

        if (n > 1) {
            for (uint i = 0; i < n - 1; i++) {
                for (uint j = 0; j < n - i - 1; j++) {
                    if (sortedData[j].orderNum < sortedData[j + 1].orderNum) {
                        // switch data elements
                        (sortedData[j], sortedData[j + 1]) = (sortedData[j + 1], sortedData[j]);
                    }
                }
            }
        }

        uint256 min = 0;

        for (uint i = 0; i < n; i++) {
            NodeType memory nodeType = sortedData[i];

            if (cpuNum >= nodeType.cpuNum && memoryNum >= nodeType.memoryNum && diskNum >= nodeType.diskNum && cudaNum >= nodeType.cudaNum && videoMemory >= nodeType.videoMemory) {
                min = nodeType.id;

                break;
            }
        }

        return min;
    }
}
