pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Space_Type is Ownable {
    address public _roleAddress;

    using Counters for Counters.Counter;
    Counters.Counter private _id;
    using Strings for *;
    using StrUtil for *;

    SpaceType[] public _spaceTypes;

    struct SpaceType {
        uint256 id; //资源分类ID
        uint256 orderNum; //资源分类排序
        string name; //分类名称
        string coverImage; //封面图片
        string remark; //描述
        uint256 payPrice; //支付价格
        uint256 pledgePrice; //抵押价格
        uint256 airdropPrice; //空投价格
    }

    event eveAdd(
        uint256 id,
        uint256 orderNum,
        string name,
        string coverImage,
        string remark,
        uint256 payPrice,
        uint256 pledgePrice,
        uint256 airdropPrice
    );

    event eveUpdate(
        uint256 id,
        uint256 orderNum,
        string name,
        string coverImage,
        string remark,
        uint payPrice,
        uint pledgePrice,
        uint256 airdropPrice
    );

    event eveDelete(uint256 id);

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function add(
        uint256 orderNum,
        string memory name,
        string memory coverImage,
        string memory remark,
        uint256 payPrice,
        uint256 pledgePrice,
        uint256 airdropPrice
    ) public {
        require(
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );
        _id.increment();
        uint256 id = _id.current();
        _spaceTypes.push(
            SpaceType({
                id: id,
                orderNum: orderNum,
                name: name,
                coverImage: coverImage,
                remark: remark,
                payPrice: payPrice,
                pledgePrice: pledgePrice,
                airdropPrice: airdropPrice
            })
        );
        emit eveAdd(
            id,
            orderNum,
            name,
            coverImage,
            remark,
            payPrice,
            pledgePrice,
            airdropPrice
        );
    }

    function update(
        uint256 id,
        uint256 orderNum,
        string memory name,
        string memory coverImage,
        string memory remark,
        uint256 payPrice,
        uint256 pledgePrice,
        uint256 airdropPrice
    ) public {
        require(
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );
        for (uint256 i = 0; i < _spaceTypes.length; i++) {
            if (_spaceTypes[i].id == id) {
                _spaceTypes[i].orderNum = orderNum;
                _spaceTypes[i].name = name;
                _spaceTypes[i].coverImage = coverImage;
                _spaceTypes[i].remark = remark;
                _spaceTypes[i].payPrice = payPrice;
                _spaceTypes[i].pledgePrice = pledgePrice;
                _spaceTypes[i].airdropPrice = airdropPrice;
                break;
            }
        }
        emit eveUpdate(
            id,
            orderNum,
            name,
            coverImage,
            remark,
            payPrice,
            pledgePrice,
            airdropPrice
        );
    }

    function deleteSpaceType(uint256 id) public {
        require(IRole(_roleAddress).hasAdminRole(msg.sender), "not admin role");

        uint256 index = 0;

        for (uint i = 0; i < _spaceTypes.length; i++) {
            if (_spaceTypes[i].id == id) {
                index = i + 1;
                break;
            }
        }

        require(index > 0, "not found");
        _spaceTypes[index - 1] = _spaceTypes[_spaceTypes.length - 1];
        _spaceTypes.pop();

        emit eveDelete(id);
    }

    function getSpaceType(uint256 id) public view returns (SpaceType memory) {
        for (uint256 i = 0; i < _spaceTypes.length; i++) {
            if (_spaceTypes[i].id == id) {
                return _spaceTypes[i];
            }
        }
    }
}
