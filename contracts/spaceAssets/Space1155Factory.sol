pragma solidity ^0.8.0;

import {Space_1155} from "../spaceAssets/Space_1155.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "../utils/StrUtil.sol";

contract Space1155Factory {
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
        Space_1155 space1155Address = new Space_1155(spaceAssetsCfgAddress);

        space1155Address.grantRole(DEFAULT_ADMIN_ROLE, account);
        space1155Address.grantRole(MINTER_ROLE, account);

        space1155Address.grantRole(URI_SETTER_ROLE, account);
        space1155Address.grantRole(PAUSER_ROLE, account);

        address _space1155Address = address(space1155Address);

        return _space1155Address;
    }
}
