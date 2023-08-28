pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract ISpaceType {
    function getResourceTypeId(
        uint256 pledgeAmount
    ) public view returns (uint256) {}
}

contract MGN_Pledge_Record is Ownable {
    address public _roleAddress;
    address public _spaceTypeAddress;

    using Counters for Counters.Counter;
    Counters.Counter private _id;
    using Strings for *;
    using StrUtil for *;

    PledgeRecord[] public _pledgeRecords;

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function setSpaceTypeAddress(address spaceTypeAddress) public onlyOwner {
        _spaceTypeAddress = spaceTypeAddress;
    }

    struct PledgeRecord {
        uint256 id; //质押记录ID
        address userAddress; //用户地址
        uint256 pledgeTime; //质押时间
        uint256 pledgeAmount; //质押金额
        uint256 spaceTypeId; //空间分类ID
        address erc721Address; //721 NFT地址
        address erc1155Address; //1155 NFT地址
        bool mintStatus; //是否已经铸造
        string mintURI; //铸造URI
    }

    event eveAdd(
        uint256 id,
        address userAddress,
        uint256 pledgeTime,
        uint256 pledgeAmount,
        uint256 spaceTypeId,
        address erc721Address,
        address erc1155Address,
        bool mintStatus,
        string mintURI
    );

    event eveDelete(uint256 id);

    event eveUpdate(uint256 id, bool mintStatus);

    function add(
        address userAddress,
        uint256 pledgeAmount,
        address erc721Address,
        address erc1155Address,
        string memory mintURI
    ) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");
        ISpaceType spaceTypeAddress = ISpaceType(_spaceTypeAddress);
        uint256 resourceTypeId = spaceTypeAddress.getResourceTypeId(
            pledgeAmount
        );
        require(resourceTypeId > 0, "pledgeAmount error");
        _id.increment();
        uint256 id = _id.current();

        uint256 pledgeTime = block.timestamp;

        _pledgeRecords.push(
            PledgeRecord(
                id,
                userAddress,
                pledgeTime,
                pledgeAmount,
                resourceTypeId,
                erc721Address,
                erc1155Address,
                false,
                mintURI
            )
        );
        emit eveAdd(
            id,
            userAddress,
            pledgeTime,
            pledgeAmount,
            resourceTypeId,
            erc721Address,
            erc1155Address,
            false,
            mintURI
        );
    }

    function del(uint256 id) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");
        bool isDelete = false;
        for (uint256 i = 0; i < _pledgeRecords.length; i++) {
            if (_pledgeRecords[i].id == id) {
                _pledgeRecords[i] = _pledgeRecords[_pledgeRecords.length - 1];
                _pledgeRecords.pop();
                isDelete = true;
                break;
            }
        }
        require(isDelete, "not found");
        emit eveDelete(id);
    }

    function getMintPledgeRecord(
        uint256 id
    ) public view returns (PledgeRecord memory) {
        for (uint256 i = 0; i < _pledgeRecords.length; i++) {
            if (_pledgeRecords[i].id == id) {
                return _pledgeRecords[i];
            }
        }

        revert("not found");
    }

    function updateMintStatus(uint256 id) public {
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");
        bool isUpdate = false;
        for (uint256 i = 0; i < _pledgeRecords.length; i++) {
            if (_pledgeRecords[i].id == id) {
                _pledgeRecords[i].mintStatus = true;
                isUpdate = true;
                break;
            }
        }
        require(isUpdate, "not found");

        emit eveUpdate(id, true);
    }
}
