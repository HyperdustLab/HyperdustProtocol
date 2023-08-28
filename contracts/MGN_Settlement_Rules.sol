pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import {StrUtil} from "./utils/StrUtil.sol";

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Settlement_Rules is Ownable {
    SettlementRules[] public _settlementRules;

    address public _roleAddress;

    struct SettlementRules {
        address settlementAddress; //结算地址
        uint256 settlementRatio; //结算比例
    }

    event eveAdd(address settlementAddress, uint256 settlementRatio);

    event eveUpdate(address settlementAddress, uint256 settlementRatio);

    event eveDelete(address settlementAddress);

    function add(address settlementAddress, uint256 settlementRatio) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

        for (uint256 i = 0; i < _settlementRules.length; i++) {
            require(
                _settlementRules[i].settlementAddress != settlementAddress,
                "settlementAddress already exists"
            );
        }

        _settlementRules.push(
            SettlementRules({
                settlementAddress: settlementAddress,
                settlementRatio: settlementRatio
            })
        );

        uint256 settlementRatio = 0;

        for (uint256 i = 0; i < _settlementRules.length; i++) {
            settlementRatio += _settlementRules[i].settlementRatio;
        }

        require(settlementRatio < 100, "settlementRatio must be less than 100");

        emit eveAdd(settlementAddress, settlementRatio);
    }

    function update(address settlementAddress, uint256 settlementRatio) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

        for (uint256 i = 0; i < _settlementRules.length; i++) {
            if (_settlementRules[i].settlementAddress == settlementAddress) {
                _settlementRules[i].settlementRatio = settlementRatio;
                emit eveUpdate(settlementAddress, settlementRatio);
                return;
            }
        }

        for (uint256 i = 0; i < _settlementRules.length; i++) {
            settlementRatio += _settlementRules[i].settlementRatio;
        }

        require(settlementRatio < 100, "settlementRatio must be less than 100");

        revert("settlementAddress does not exist");
    }

    function del(address settlementAddress) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

        for (uint256 i = 0; i < _settlementRules.length; i++) {
            if (_settlementRules[i].settlementAddress == settlementAddress) {
                _settlementRules[i] = _settlementRules[
                    _settlementRules.length - 1
                ];
                _settlementRules.pop();

                emit eveDelete(settlementAddress);
                return;
            }
        }
    }

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function getSettlementRules()
        public
        view
        returns (SettlementRules[] memory)
    {
        return _settlementRules;
    }
}
