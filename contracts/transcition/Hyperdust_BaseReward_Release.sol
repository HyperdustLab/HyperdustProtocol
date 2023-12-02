pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_BaseReward_Release is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _id;

    struct BaseRewardReleaseRecord {
        uint256 id;
        uint256 amount;
        uint256 releaseTime;
        address account;
        uint256 nodeId;
    }

    address public _rolesCfgAddress;
    address public _erc20Address;

    uint256 public _intervalTime = 60 * 24 * 30 * 2;

    uint256 public _intervalCount = 12;

    event eveSave(
        uint256[] ids,
        uint256 amount,
        uint256[] releaseTimes,
        address account,
        uint256 nodeId
    );

    event eveRelease(uint256[] ids);

    mapping(address => BaseRewardReleaseRecord[])
        public _baseRewardReleaseRecordsMap;

    mapping(uint256 => uint256) public _indexReleaseTimeMap;
    mapping(uint256 => uint256) public _indexReleaseAmountMap;
    mapping(address => uint256[]) public _indexReleaseAmountMap1;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setERC20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
    }

    function addBaseRewardReleaseRecord(
        uint256 amount,
        address account,
        uint256 nodeId
    ) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        uint256 time = block.timestamp;

        uint256 avgAmount = amount / _intervalCount;

        if (avgAmount == 0) {
            return;
        }

        uint256[] memory ids = new uint256[](_intervalCount);
        uint256[] memory releaseTimes = new uint256[](_intervalCount);

        for (uint256 i = 0; i < _intervalCount; i++) {
            _id.increment();

            ids[i] = _id.current();
            releaseTimes[i] = time + _intervalTime * i;

            _baseRewardReleaseRecordsMap[account].push(
                BaseRewardReleaseRecord(
                    _id.current(),
                    avgAmount,
                    releaseTimes[i],
                    account,
                    nodeId
                )
            );
        }

        emit eveSave(ids, avgAmount, releaseTimes, account, nodeId);
    }

    function release() public {
        uint256 amount = 0;

        BaseRewardReleaseRecord[]
            memory baseRewardReleaseRecords = _baseRewardReleaseRecordsMap[
                msg.sender
            ];

        require(baseRewardReleaseRecords.length > 0, "no release");

        uint256[] memory ids = new uint256[](baseRewardReleaseRecords.length);

        uint256 index = 0;
        for (uint256 i = 0; i < baseRewardReleaseRecords.length; i++) {
            if (
                baseRewardReleaseRecords[i].releaseTime <= block.timestamp &&
                index < 10
            ) {
                amount += baseRewardReleaseRecords[i].amount;
                ids[index] = baseRewardReleaseRecords[i].id;
                index++;

                _baseRewardReleaseRecordsMap[msg.sender][
                    i
                ] = baseRewardReleaseRecords[
                    baseRewardReleaseRecords.length - 1
                ];
                _baseRewardReleaseRecordsMap[msg.sender].pop();
            }
        }

        IERC20(_erc20Address).transfer(msg.sender, amount);

        uint256[] memory newIds = new uint256[](index);
        for (uint256 i = 0; i < index; i++) {
            newIds[i] = ids[i];
        }

        emit eveRelease(newIds);
    }

    function getBaseRewardReleaseRecords(
        address account
    )
        public
        view
        returns (uint256[] memory, uint256[] memory, uint256[] memory)
    {
        BaseRewardReleaseRecord[]
            memory baseRewardReleaseRecords = _baseRewardReleaseRecordsMap[
                account
            ];
        uint256[] memory ids = new uint256[](baseRewardReleaseRecords.length);
        uint256[] memory amounts = new uint256[](
            baseRewardReleaseRecords.length
        );
        uint256[] memory releaseTime = new uint256[](
            baseRewardReleaseRecords.length
        );

        for (uint256 i = 0; i < baseRewardReleaseRecords.length; i++) {
            ids[i] = baseRewardReleaseRecords[i].id;
            amounts[i] = baseRewardReleaseRecords[i].amount;
            releaseTime[i] = baseRewardReleaseRecords[i].releaseTime;
        }

        return (ids, amounts, releaseTime);
    }
}
