pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {}

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {}

    function balanceOf(address account) external view returns (uint256) {}

    function approve(address spender, uint256 amount) external returns (bool) {}

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {}
}

contract MGN_Airdrop is Ownable {
    using Strings for *;
    using StrUtil for *;

    uint256 public _maxAirdrop = 1000000000000000000;

    address public _rolesCfgAddress;

    address public _erc20Address;

    address public _admin;

    uint256 public _sumAirdrop = 500000000000000000000;

    uint256 public _receivedAirdrop = 0;

    constructor() {
        _admin = msg.sender;
    }

    function setSumAirdrop(uint256 sumAirdrop) public onlyOwner {
        _sumAirdrop = sumAirdrop;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setMaxAirdrop(uint256 maxAirdrop) public onlyOwner {
        _maxAirdrop = maxAirdrop;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function airdrop(address account, uint256 num) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        require(num <= _maxAirdrop, "exceed max airdrop");
        require(
            _receivedAirdrop + num <= _sumAirdrop,
            "No airdrop amount available"
        );
        IERC20(_erc20Address).transferFrom(_admin, account, num);

        _receivedAirdrop += num;
    }

    function getRemainingAirdropQuantity() public view returns (uint256) {
        if (_sumAirdrop >= _receivedAirdrop) {
            return _sumAirdrop - _receivedAirdrop;
        } else {
            return 0;
        }
    }
}
