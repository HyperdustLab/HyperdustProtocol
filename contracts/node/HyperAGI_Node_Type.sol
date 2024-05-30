pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../utils/StrUtil.sol";

import "./../HyperAGI_Roles_Cfg.sol";
import "./../HyperAGI_Storage.sol";

import "./../node/HyperAGI_Node_Mgr.sol";

contract HyperAGI_Node_Type is OwnableUpgradeable {
    address public _rolesCfgAddress;
    address public _storageAddress;

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

    function setStorageAddress(address storageAddress) public onlyOwner {
        _storageAddress = storageAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _storageAddress = contractaddressArray[0];
        _rolesCfgAddress = contractaddressArray[1];
    }

    function addNodeType(uint256 orderNum, string memory name, uint256 cpuNum, uint256 memoryNum, uint256 diskNum, uint256 cudaNum, uint256 videoMemory, string memory coverImage, string memory frameRate, string memory remark) public returns (uint256) {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);
        uint256 id = storageAddress.getNextId();

        _ids.push(id);

        storageAddress.setUint(storageAddress.genKey("orderNum", id), orderNum);

        storageAddress.setString(storageAddress.genKey("name", id), name);
        storageAddress.setUint(storageAddress.genKey("cpuNum", id), cpuNum);
        storageAddress.setUint(storageAddress.genKey("memoryNum", id), memoryNum);
        storageAddress.setUint(storageAddress.genKey("diskNum", id), diskNum);
        storageAddress.setUint(storageAddress.genKey("cudaNum", id), cudaNum);
        storageAddress.setUint(storageAddress.genKey("videoMemory", id), videoMemory);
        storageAddress.setString(storageAddress.genKey("coverImage", id), coverImage);
        storageAddress.setString(storageAddress.genKey("frameRate", id), frameRate);
        storageAddress.setString(storageAddress.genKey("remark", id), remark);
        emit eveSave(id);
        return id;
    }

    function updateNodeType(uint256 id, uint256 orderNum, string memory name, uint256 cpuNum, uint256 memoryNum, uint256 diskNum, uint256 cudaNum, uint256 videoMemory, string memory coverImage, string memory frameRate, string memory remark) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        string memory _name = storageAddress.getString(storageAddress.genKey("name", id));

        require(bytes(_name).length > 0, "not found");

        storageAddress.setUint(storageAddress.genKey("orderNum", id), orderNum);

        storageAddress.setString(storageAddress.genKey("name", id), name);
        storageAddress.setUint(storageAddress.genKey("cpuNum", id), cpuNum);
        storageAddress.setUint(storageAddress.genKey("memoryNum", id), memoryNum);
        storageAddress.setUint(storageAddress.genKey("diskNum", id), diskNum);
        storageAddress.setUint(storageAddress.genKey("cudaNum", id), cudaNum);
        storageAddress.setUint(storageAddress.genKey("videoMemory", id), videoMemory);
        storageAddress.setString(storageAddress.genKey("coverImage", id), coverImage);
        storageAddress.setString(storageAddress.genKey("frameRate", id), frameRate);
        storageAddress.setString(storageAddress.genKey("remark", id), remark);

        emit eveSave(id);
    }

    function getNodeType(uint256 id) public view returns (uint256[] memory, string[] memory) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        string[] memory strArray = new string[](4);
        uint256[] memory uint256Array = new uint256[](7);

        strArray[0] = storageAddress.getString(storageAddress.genKey("name", id));

        require(bytes(strArray[0]).length > 0, "not found");

        strArray[1] = storageAddress.getString(storageAddress.genKey("coverImage", id));
        strArray[2] = storageAddress.getString(storageAddress.genKey("frameRate", id));
        strArray[3] = storageAddress.getString(storageAddress.genKey("remark", id));

        uint256Array[0] = id;
        uint256Array[1] = storageAddress.getUint(storageAddress.genKey("orderNum", id));

        uint256Array[2] = storageAddress.getUint(storageAddress.genKey("cpuNum", id));
        uint256Array[3] = storageAddress.getUint(storageAddress.genKey("memoryNum", id));

        uint256Array[4] = storageAddress.getUint(storageAddress.genKey("diskNum", id));

        uint256Array[5] = storageAddress.getUint(storageAddress.genKey("nodeType", id));

        uint256Array[6] = storageAddress.getUint(storageAddress.genKey("videoMemory", id));

        return (uint256Array, strArray);
    }

    function deleteNodeType(uint256 id) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        string memory name = storageAddress.getString(storageAddress.genKey("name", id));

        require(bytes(name).length > 0, "not found");

        storageAddress.setString(storageAddress.genKey("name", id), "");

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
