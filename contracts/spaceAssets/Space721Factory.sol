pragma solidity ^0.8.0;

import {Space_721} from "../spaceAssets/Space_721.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "../utils/StrUtil.sol";

contract Space721Factory {
    using Strings for *;
    using StrUtil for *;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");

    function deploy(
        address account,
        address spaceAssetsCfgAddress
    ) public returns (address) {
        Space_721 space721Address = new Space_721(spaceAssetsCfgAddress);

        space721Address.grantRole(DEFAULT_ADMIN_ROLE, account);
        space721Address.grantRole(MINTER_ROLE, account);

        address _space721Address = address(space721Address);

        return _space721Address;
    }
}
