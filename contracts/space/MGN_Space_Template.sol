pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Space_Template is Ownable {
    address public _rolesCfgAddress;

    SpaceTemplate[] public _spaceTemplate;

    using Counters for Counters.Counter;
    Counters.Counter private _id;
    using Strings for *;
    using StrUtil for *;

    struct SpaceTemplate {
        uint256 id;
        string name;
        string coverImage;
        string file;
        uint256 spaceTypeId;
        string fileHash;
    }

    event eveDelete(uint256 id);

    event eveAdd(
        uint256 id,
        string name,
        string coverImage,
        string file,
        uint256 spaceTypeId,
        string fileHash
    );

    event eveUpdate(
        uint256 id,
        string name,
        string coverImage,
        string file,
        uint256 spaceTypeId,
        string fileHash
    );

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function add(
        string memory name,
        string memory coverImage,
        string memory file,
        uint256 spaceTypeId,
        string memory fileHash
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        _id.increment();
        uint256 id = _id.current();
        _spaceTemplate.push(
            SpaceTemplate({
                id: id,
                name: name,
                coverImage: coverImage,
                file: file,
                spaceTypeId: spaceTypeId,
                fileHash: fileHash
            })
        );
        emit eveAdd(id, name, coverImage, file, spaceTypeId, fileHash);
    }

    function update(
        uint256 id,
        string memory name,
        string memory coverImage,
        string memory file,
        uint256 spaceTypeId,
        string memory fileHash
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        bool isUpdate = false;
        for (uint256 i = 0; i < _spaceTemplate.length; i++) {
            if (_spaceTemplate[i].id == id) {
                _spaceTemplate[i].name = name;
                _spaceTemplate[i].coverImage = coverImage;
                _spaceTemplate[i].file = file;
                _spaceTemplate[i].spaceTypeId = spaceTypeId;
                _spaceTemplate[i].fileHash = fileHash;
                isUpdate = true;
                break;
            }
        }
        require(isUpdate, "not found");
        emit eveUpdate(id, name, coverImage, file, spaceTypeId, fileHash);
    }

    function deleteSpaceTemplate(uint256 id) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        uint256 index = 0;

        for (uint i = 0; i < _spaceTemplate.length; i++) {
            if (_spaceTemplate[i].id == id) {
                index = i + 1;
                break;
            }
        }

        require(index > 0, "not found");
        _spaceTemplate[index - 1] = _spaceTemplate[_spaceTemplate.length - 1];
        _spaceTemplate.pop();

        emit eveDelete(id);
    }
}
