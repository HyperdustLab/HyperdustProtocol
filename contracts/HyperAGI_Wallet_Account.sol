pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./utils/StrUtil.sol";
import "./HyperAGI_Roles_Cfg.sol";

contract HyperAGI_Wallet_Account is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _GasFeeCollectionWallet;

    event eveGasFee(uint256 amount, uint256 time);

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setGasFeeCollectionWallet(address gasFeeCollectionWallet) public onlyOwner {
        _GasFeeCollectionWallet = gasFeeCollectionWallet;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _GasFeeCollectionWallet = contractaddressArray[1];
    }

    function addAmount(uint256 amount) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        emit eveGasFee(amount, block.timestamp);
    }
}
