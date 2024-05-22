// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";

import "./../node/Hyperdust_Node_Mgr.sol";

contract Hyperdust_Miner_NFT_Pledge is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;
    address public _HyperdustStorageAddress;
    address public _Hyperdust721Address;
    uint256 public _pledgeTime;
    address public _HyperdustNodeMgrAddress;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
        _pledgeTime = 365 days;
    }

    function setHyperdustRolesCfgAddress(address HyperdustRolesCfgAddress) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function setHyperdustStorageAddress(address hyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setHyperdust721Address(address hyperdust721Address) public onlyOwner {
        _Hyperdust721Address = hyperdust721Address;
    }

    function setHyperdustNodeMgrAddress(address hyperdustNodeMgrAddress) public onlyOwner {
        _HyperdustNodeMgrAddress = hyperdustNodeMgrAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _HyperdustRolesCfgAddress = contractaddressArray[0];
        _HyperdustStorageAddress = contractaddressArray[1];
        _Hyperdust721Address = contractaddressArray[2];
        _HyperdustNodeMgrAddress = contractaddressArray[3];
    }

    event evePledge(address account, address tokenAddress, uint256 tokenId, uint256 allowedRedemptionTime);
    event eveRedemption(address account, address tokenAddress, uint256 tokenId);

    function pledge(uint256 tokenId) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);
        IERC721 erc721 = IERC721(_Hyperdust721Address);
        require(erc721.ownerOf(tokenId) == msg.sender, "not owner");
        string memory key = hyperdustStorage.genKey(_Hyperdust721Address.toHexString(), tokenId);
        hyperdustStorage.setAddress(key, msg.sender);

        string memory allowedRedemptionTimeKey = string(abi.encodePacked(key, "allowedRedemptionTime"));

        uint256 allowedRedemptionTime = hyperdustStorage.getUint(allowedRedemptionTimeKey);

        if (allowedRedemptionTime == 0) {
            hyperdustStorage.setUint(allowedRedemptionTimeKey, block.timestamp + _pledgeTime);
            allowedRedemptionTime = block.timestamp + _pledgeTime;
        }
        erc721.transferFrom(msg.sender, address(this), tokenId);

        string memory accountKey = msg.sender.toHexString();

        uint256 pledgeNum = hyperdustStorage.getUint(accountKey);

        hyperdustStorage.setUint(accountKey, pledgeNum + 1);

        emit evePledge(msg.sender, _Hyperdust721Address, tokenId, allowedRedemptionTime);
    }

    function redemption(uint256 tokenId) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        Hyperdust_Node_Mgr hyperdustNodeMgr = Hyperdust_Node_Mgr(_HyperdustNodeMgrAddress);

        IERC721 erc721 = IERC721(_Hyperdust721Address);
        string memory key = hyperdustStorage.genKey(_Hyperdust721Address.toHexString(), tokenId);
        address ownerAdress = hyperdustStorage.getAddress(key);
        require(ownerAdress == msg.sender, "not owner");

        string memory allowedRedemptionTimeKey = string(abi.encodePacked(key, "allowedRedemptionTime"));

        uint256 allowedRedemptionTime = hyperdustStorage.getUint(allowedRedemptionTimeKey);

        require(block.timestamp > allowedRedemptionTime, "not allowed time");

        erc721.transferFrom(address(this), msg.sender, tokenId);

        string memory accountKey = msg.sender.toHexString();

        uint256 pledgeNum = hyperdustStorage.getUint(accountKey);

        uint256 nodeNum = hyperdustNodeMgr.getAccountNodeNum(msg.sender);

        require(nodeNum <= pledgeNum - 1, "The node must be offline before NFT assets can be redeemed");

        hyperdustStorage.setUint(accountKey, pledgeNum - 1);

        emit eveRedemption(msg.sender, _Hyperdust721Address, tokenId);
    }

    function getAccountPledgeNum(address account) public view returns (uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);
        string memory accountKey = account.toHexString();
        return hyperdustStorage.getUint(accountKey);
    }

    function setPledgeTime(uint256 pledgeTime) public onlyOwner {
        _pledgeTime = pledgeTime;
    }
}
