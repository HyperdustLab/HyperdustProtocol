pragma solidity ^0.8.2;

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

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {StrUtil} from "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";

contract Hyperdust_Node_Mgr is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _nodeCheckInAddress;
    address public _rolesCfgAddress;
    address public _nodeTypeAddress;

    address public _HyperdustStorageAddress;

    uint32 public _totalNum;
    uint32 public _activeNum;

    struct Node {
        address incomeAddress;
        string ip; //Node public network IP
        uint256[] uint256Array; //id,nodeType,cpuNum,memoryNum,diskNum,cudaNum,videoMemory
        bool isOffine;
    }

    event eveSave(uint256 id);

    event eveDelete(uint256 id);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

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

    function setHyperdustStorageAddress(
        address hyperdustStorageAddress
    ) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _nodeCheckInAddress = contractaddressArray[1];
        _nodeTypeAddress = contractaddressArray[2];
        _HyperdustStorageAddress = contractaddressArray[3];
    }

    function addNode(
        address incomeAddress,
        string memory ip,
        uint256[] memory hardwareInfos
    ) public returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        require(!hyperdustStorage.getBool(ip), "ip already exists");

        INodeType nodeType = INodeType(_nodeTypeAddress);

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

        uint256 id = hyperdustStorage.getNextId();

        add(id, nodeTypeId, incomeAddress, ip, hardwareInfos);

        return id;
    }

    function add(
        uint256 id,
        uint256 nodeTypeId,
        address incomeAddress,
        string memory ip,
        uint256[] memory hardwareInfos
    ) private {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256 count = hyperdustStorage.getUint("count");

        hyperdustStorage.setBool(ip, true);

        hyperdustStorage.setUint("count", count + 1);

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("nodeTypeId", id),
            nodeTypeId
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("cpuNum", id),
            hardwareInfos[0]
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("memoryNum", id),
            hardwareInfos[1]
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("diskNum", id),
            hardwareInfos[2]
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("cudaNum", id),
            hardwareInfos[3]
        );

        hyperdustStorage.setUint(
            hyperdustStorage.genKey("videoMemory", id),
            hardwareInfos[4]
        );

        hyperdustStorage.setAddress(
            hyperdustStorage.genKey("incomeAddress", id),
            incomeAddress
        );

        hyperdustStorage.setString(hyperdustStorage.genKey("ip", id), ip);

        hyperdustStorage.setUintArray("idList", id);

        emit eveSave(id);
    }

    function getNode(
        uint256 id
    ) public view returns (address, string memory, uint256[] memory) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory ip = hyperdustStorage.getString(
            hyperdustStorage.genKey("ip", id)
        );

        require(bytes(ip).length > 0, "not found");

        address incomeAddress = hyperdustStorage.getAddress(
            hyperdustStorage.genKey("incomeAddress", id)
        );

        uint256[] memory uint256Array = new uint256[](7);

        uint256Array[0] = id;
        uint256Array[1] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("nodeTypeId", id)
        );
        uint256Array[2] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("cpuNum", id)
        );
        uint256Array[3] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("memoryNum", id)
        );
        uint256Array[4] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("diskNum", id)
        );
        uint256Array[5] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("cudaNum", id)
        );
        uint256Array[6] = hyperdustStorage.getUint(
            hyperdustStorage.genKey("videoMemory", id)
        );

        return (incomeAddress, ip, uint256Array);
    }

    function getNodeObj(uint256 id) public view returns (Node memory) {
        (
            address incomeAddress,
            string memory ip,
            uint256[] memory uint256Array,
            bool isOffine
        ) = getNodeV2(id);

        Node memory node = Node({
            incomeAddress: incomeAddress,
            ip: ip,
            uint256Array: uint256Array,
            isOffine: isOffine
        });

        return node;
    }

    function deleteNode(uint256 id) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory ip = hyperdustStorage.getString(
            hyperdustStorage.genKey("ip", id)
        );

        require(bytes(ip).length > 0, "not found");

        hyperdustStorage.setString(hyperdustStorage.genKey("ip", id), "");

        uint256 count = hyperdustStorage.getUint("count");

        hyperdustStorage.setUint("count", count - 1);

        uint256[] memory idList = hyperdustStorage.getUintArray("idList");

        for (uint i = 0; i < idList.length; i++) {
            if (idList[i] == id) {
                hyperdustStorage.removeStringArray("idList", i);
                break;
            }
        }

        emit eveDelete(id);
    }

    function getStatisticalIndex()
        public
        view
        returns (uint256, uint256, uint256)
    {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );
        uint256 count = hyperdustStorage.getUint("count");
        uint256 totalNum = hyperdustStorage.getUint("totalNum");
        uint256 activeNum = hyperdustStorage.getUint("activeNum");

        return (count, totalNum, activeNum);
    }

    function setStatisticalIndex(uint256 totalNum, uint256 activeNum) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        hyperdustStorage.setUint("totalNum", totalNum);
        hyperdustStorage.setUint("activeNum", activeNum);
    }

    function getIdByIndex(uint256 index) public view returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256[] memory ids = hyperdustStorage.getUintArray("idList");

        if (index + 1 > ids.length) {
            return 0;
        }

        return ids[index];
    }

    function setIdList(uint256[] memory idList) public onlyOwner {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        hyperdustStorage.setUintArray("idList", idList);
    }

    function updateStatus(uint256 nodeId, bool isOffine) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        hyperdustStorage.setBool(
            hyperdustStorage.genKey("isOffine", nodeId),
            isOffine
        );

        emit eveSave(nodeId);
    }

    function getNodeV2(
        uint256 id
    ) public view returns (address, string memory, uint256[] memory, bool) {
        (
            address incomeAddress,
            string memory ip,
            uint256[] memory uint256Array
        ) = getNode(id);

        bool isOffine = Hyperdust_Storage(_HyperdustStorageAddress).getBool(
            Hyperdust_Storage(_HyperdustStorageAddress).genKey("isOffine", id)
        );
        return (incomeAddress, ip, uint256Array, isOffine);
    }
}
