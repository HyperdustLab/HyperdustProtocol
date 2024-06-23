// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../HyperAGI_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "./../HyperAGI_Storage.sol";

contract HyperAGI_Miner_NFT_Pledge is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _storageAddress;
    address public _721Address;
    uint256 public _pledgeTime;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
        _pledgeTime = 365 days;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setStorageAddress(address storageAddress) public onlyOwner {
        _storageAddress = storageAddress;
    }

    function set721Address(address address721) public onlyOwner {
        _721Address = address721;
    }

    function setPledgeTime(uint256 pledgeTime) public onlyOwner {
        _pledgeTime = pledgeTime;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _storageAddress = contractaddressArray[1];
        _721Address = contractaddressArray[2];
    }

    event evePledge(address account, address tokenAddress, uint256 tokenId, uint256 allowedRedemptionTime);
    event eveRedemption(address account, address tokenAddress, uint256 tokenId);

    function pledge(uint256 tokenId) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);
        IERC721 erc721 = IERC721(_721Address);
        require(erc721.ownerOf(tokenId) == msg.sender, "not owner");
        string memory key = storageAddress.genKey(_721Address.toHexString(), tokenId);
        storageAddress.setAddress(key, msg.sender);

        string memory allowedRedemptionTimeKey = string(abi.encodePacked(key, "allowedRedemptionTime"));

        uint256 allowedRedemptionTime = storageAddress.getUint(allowedRedemptionTimeKey);

        if (allowedRedemptionTime == 0) {
            storageAddress.setUint(allowedRedemptionTimeKey, block.timestamp + _pledgeTime);
            allowedRedemptionTime = block.timestamp + _pledgeTime;
        }
        erc721.transferFrom(msg.sender, address(this), tokenId);

        string memory accountKey = msg.sender.toHexString();

        string memory pledgeNumKey = string(abi.encodePacked(accountKey, "_pledgeNum"));

        uint256 pledgeNum = storageAddress.getUint(pledgeNumKey);

        storageAddress.setUint(pledgeNumKey, pledgeNum + 1);

        emit evePledge(msg.sender, _721Address, tokenId, allowedRedemptionTime);
    }

    function redemption(uint256 tokenId) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        IERC721 erc721 = IERC721(_721Address);
        string memory key = storageAddress.genKey(_721Address.toHexString(), tokenId);
        address ownerAddress = storageAddress.getAddress(key);
        require(ownerAddress == msg.sender, "not owner");

        string memory allowedRedemptionTimeKey = string(abi.encodePacked(key, "allowedRedemptionTime"));

        uint256 allowedRedemptionTime = storageAddress.getUint(allowedRedemptionTimeKey);

        require(block.timestamp > allowedRedemptionTime, "not allowed time");

        erc721.transferFrom(address(this), msg.sender, tokenId);

        string memory accountKey = msg.sender.toHexString();

        uint256 pledgeNum = storageAddress.getUint(accountKey);

        string memory lockNumKey = string(abi.encodePacked(accountKey, "_lockNum"));

        uint256 lockNum = storageAddress.getUint(lockNumKey);

        require(lockNum + 1 <= pledgeNum, "The node must be offline before NFT assets can be redeemed");

        storageAddress.setUint(accountKey, pledgeNum - 1);

        emit eveRedemption(msg.sender, _721Address, tokenId);
    }

    function getAccountPledgeNum(address account) public view returns (uint256[] memory) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        string memory accountKey = account.toHexString();

        string memory pledgeNumKey = string(abi.encodePacked(accountKey, "_pledgeNum"));
        string memory lockNumKey = string(abi.encodePacked(accountKey, "_lockNum"));

        uint256[] memory uint256Array = new uint256[](2);

        uint256Array[0] = storageAddress.getUint(pledgeNumKey);
        uint256Array[1] = storageAddress.getUint(lockNumKey);

        return uint256Array;
    }

    function lock(address account, uint256 num) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        uint256[] memory uint256Array = getAccountPledgeNum(account);

        uint256 lockNum = uint256Array[1] + num;

        require(uint256Array[0] >= lockNum, "The amount of pledged NFT is insufficient, please pledge the NFT first");

        string memory accountKey = account.toHexString();

        string memory lockNumKey = string(abi.encodePacked(accountKey, "_lockNum"));

        storageAddress.setUint(lockNumKey, lockNum);
    }

    function release(address account, uint256 num) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        uint256[] memory uint256Array = getAccountPledgeNum(account);

        require(uint256Array[1] >= num, "not enough lock num");

        uint256 lockNum = uint256Array[1] - num;

        string memory accountKey = account.toHexString();

        string memory lockNumKey = string(abi.encodePacked(accountKey, "_lockNum"));

        storageAddress.setUint(lockNumKey, lockNum);
    }
}
