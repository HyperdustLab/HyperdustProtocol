// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_Token is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Hyperdust", "HYPT Test") {
        address[] memory accounts = new address[](6);
        uint256 totalSupply = 200000000000000000000000000;
        accounts[0] = 0xcDe95087F26df168424393c32c8aE53B573f0B9F;
        accounts[1] = 0xB54C5a9F5292C6D535c0C4220469DeC2DE714807;
        accounts[2] = 0xA7Fb5D4cC31e60F8B8040E53ab55B5c088B256e0;
        accounts[3] = 0x343eB313A6BBBA00CCb524000c030A45F04DC5C9;
        accounts[4] = 0x099f3756D4098c6699c7476623A007455df00Ff5;
        accounts[5] = 0x2BB0f0FA665Ab9ad2B5519227070b2e1E8Ee28F4;

        uint32[] memory mintRatios = new uint32[](6);
        mintRatios[0] = 150;
        mintRatios[1] = 50;
        mintRatios[2] = 115;
        mintRatios[3] = 45;
        mintRatios[4] = 90;
        mintRatios[5] = 550;

        for (uint256 i = 0; i < accounts.length; i++) {
            _mint(accounts[i], (totalSupply * mintRatios[i]) / 1000);
        }
    }

    address public _rolesCfgAddress;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function mint(address to, uint256 amount) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        _mint(to, amount);
    }
}
