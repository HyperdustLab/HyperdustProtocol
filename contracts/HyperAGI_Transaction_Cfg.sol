pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./utils/StrUtil.sol";

import "./HyperAGI_Roles_Cfg.sol";
import "./node/HyperAGI_Node_Mgr.sol";

contract HyperAGI_Transaction_Cfg is OwnableUpgradeable {
    address public _rolesCfgAddress;

    address public _nodeMgrAddress;

    mapping(string => uint256) public _minGasFeeMap;

    using Strings for *;
    using StrUtil for *;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setNodeMgrAddress(address nodeMgrAddress) public onlyOwner {
        _nodeMgrAddress = nodeMgrAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _nodeMgrAddress = contractaddressArray[1];
    }

    mapping(string => uint256) public _transactionProceduresMap;

    function add(string memory func, uint256 rate) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        _transactionProceduresMap[func] = rate;
    }

    function del(string memory func) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        delete _transactionProceduresMap[func];
    }

    function get(string memory func) public view returns (uint256) {
        return _transactionProceduresMap[func];
    }

    function getGasFee(string memory func) public view returns (uint256) {
        (uint256 _totalNum, uint256 _activeNum) = HyperAGI_Node_Mgr(_nodeMgrAddress).getStatisticalIndex();
        uint256 renderPrice = _transactionProceduresMap[func];

        if (_activeNum == 0 || renderPrice == 0) {
            return _minGasFeeMap[func];
        }

        if (_totalNum < 10) {
            _totalNum = 10;
        }

        uint256 accuracy = 10000000000000;

        uint256 difficulty = (_totalNum * accuracy) / _activeNum;

        uint256 gasPrice = (renderPrice * accuracy) / difficulty;

        uint256 gasFee = (renderPrice * gasPrice * 1 ether) / accuracy;

        return gasFee;
    }

    function setMinGasFee(string memory key, uint256 minGasFee) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        _minGasFeeMap[key] = minGasFee;
    }

    function getMaxGasFee(string memory func) public view returns (uint256) {
        (, uint256 _activeNum) = HyperAGI_Node_Mgr(_nodeMgrAddress).getStatisticalIndex();
        uint256 renderPrice = _transactionProceduresMap[func];

        if (_activeNum == 0 || renderPrice == 0) {
            return _minGasFeeMap[func];
        }

        uint256 accuracy = 10000000000000;

        uint256 difficulty = (1 * accuracy) / 1;

        uint256 gasPrice = (renderPrice * accuracy) / difficulty;

        uint256 gasFee = (renderPrice * gasPrice * 1 ether) / accuracy;

        return gasFee;
    }
}
