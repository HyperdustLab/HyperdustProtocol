pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./utils/StrUtil.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IHyperdustNodeMgr {
    struct Node {
        address incomeAddress;
        string ip; //Node public network IP
        uint256[] uint256Array; //id,nodeType,cpuNum,memoryNum,diskNum,cudaNum,videoMemory
    }

    function getNodeObj(uint256 id) public view returns (Node memory) {}

    function getStatisticalIndex()
        public
        view
        returns (uint256, uint32, uint32)
    {}
}

contract Hyperdust_Transaction_Cfg is OwnableUpgradeable {
    address public _rolesCfgAddress;

    address public _nodeMgrAddress;

    mapping(string => uint256) public _minGasFeeMap;

    using Strings for *;
    using StrUtil for *;

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setNodeMgrAddress(address nodeMgrAddress) public onlyOwner {
        _nodeMgrAddress = nodeMgrAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _nodeMgrAddress = contractaddressArray[1];
    }

    mapping(string => uint256) public _transactionProceduresMap;

    function add(string memory func, uint256 rate) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        _transactionProceduresMap[func] = rate;
    }

    function del(string memory func) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        delete _transactionProceduresMap[func];
    }

    function get(string memory func) public view returns (uint256) {
        return _transactionProceduresMap[func];
    }

    function getGasFee(string memory func) public view returns (uint256) {
        (, uint32 _totalNum, uint32 _activeNum) = IHyperdustNodeMgr(
            _nodeMgrAddress
        ).getStatisticalIndex();
        uint256 renderPrice = _transactionProceduresMap[func];

        if (_activeNum == 0 || renderPrice == 0) {
            return _minGasFeeMap[func];
        }

        uint32 accuracy = 1000000;

        uint256 difficuty = (_totalNum * accuracy) / _activeNum;

        uint256 gasPrice = (renderPrice * accuracy) / difficuty;

        uint256 gasFee = (renderPrice * gasPrice * 1 ether) / accuracy / 10000;

        return gasFee;
    }

    function setMinGasFee(string memory key, uint256 minGasFee) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        _minGasFeeMap[key] = minGasFee;
    }
}
