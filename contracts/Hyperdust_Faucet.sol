pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./utils/StrUtil.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_Faucet is OwnableUpgradeable {
    address public _HyperdustTokenAddress;
    address public _fromAddress;
    address public _HyperdustRolesCfgAddress;
    using Strings for *;

    using StrUtil for *;

    event eveTransfer(address[]);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function setHyperdustTokenAddress(
        address HyperdustTokenAddress
    ) public onlyOwner {
        _HyperdustTokenAddress = HyperdustTokenAddress;
    }

    function setFromAddress(address fromAddress) public onlyOwner {
        _fromAddress = fromAddress;
    }

    function transfer(
        address[] memory accounts,
        uint256[] memory amounts
    ) public {
        require(
            IHyperdustRolesCfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        for (uint256 i = 0; i < accounts.length; i++) {
            IERC20(_HyperdustTokenAddress).transferFrom(
                _fromAddress,
                accounts[i],
                amounts[i]
            );
        }

        emit eveTransfer(accounts);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _HyperdustRolesCfgAddress = rolesCfgAddress;
    }
}
