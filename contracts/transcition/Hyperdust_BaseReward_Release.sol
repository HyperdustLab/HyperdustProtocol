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

    address public _rolesCfgAddress;
    address public _erc20Address;

    uint256 public _intervalTime = 30 days;

    uint256 public _intervalCount = 12;

    event eveSave(
        uint256[] amounts,
        uint256[] releaseAmounts,
        uint256[] releaseTimes,
        address account
    );

    mapping(string => uint256[] amount) public _baseRewardReleaseRecordsMap;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setERC20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setIntervalTime(uint256 intervalTime) public onlyOwner {
        _intervalTime = intervalTime;
    }

    function setIntervalCount(uint256 intervalCount) public onlyOwner {
        _intervalCount = intervalCount;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
    }

    function addBaseRewardReleaseRecord(
        uint256 amount,
        address account
    ) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        uint256 time = getStartOfToday();

        uint256 avgAmount = amount / _intervalCount;

        if (avgAmount == 0) {
            return;
        }

        uint256[] memory amounts = new uint256[](_intervalCount);
        uint256[] memory releaseTimes = new uint256[](_intervalCount);
        uint256[] memory releaseAmounts = new uint256[](_intervalCount);

        for (uint256 i = 0; i < _intervalCount; i++) {
            string memory key = account.toHexString().toSlice().concat(
                time.toString().toSlice()
            );

            uint256[] memory amountArray = _baseRewardReleaseRecordsMap[key];

            if (amountArray.length == 0) {
                amountArray = new uint256[](2);
            }

            amountArray[0] += avgAmount;
            releaseTimes[i] = time;
            amounts[i] = amountArray[0];
            releaseAmounts[i] = amountArray[1];

            _baseRewardReleaseRecordsMap[key] = amountArray;

            time += _intervalTime;
        }

        emit eveSave(amounts, releaseAmounts, releaseTimes, account);
    }

    function release(uint256[] memory times) public {
        uint256 totalReleaseAmount = 0;

        uint256[] memory amounts = new uint256[](times.length);
        uint256[] memory releaseTimes = new uint256[](times.length);
        uint256[] memory releaseAmounts = new uint256[](times.length);

        for (uint i = 0; i < times.length; i++) {
            uint256 time = times[i];

            require(block.timestamp >= time, "time error");

            string memory key = msg.sender.toHexString().toSlice().concat(
                time.toString().toSlice()
            );

            uint256[] memory amountArray = _baseRewardReleaseRecordsMap[key];

            if (amountArray.length == 0) {
                continue;
            }

            uint256 releaseAmount = amountArray[0] - amountArray[1];

            if (releaseAmount == 0) {
                continue;
            }

            amountArray[1] += releaseAmount;

            _baseRewardReleaseRecordsMap[key] = amountArray;

            totalReleaseAmount += releaseAmount;

            amounts[i] = amountArray[0];
            releaseTimes[i] = time;
            releaseAmounts[i] = amountArray[1];
        }

        IERC20(_erc20Address).transfer(msg.sender, totalReleaseAmount);

        emit eveSave(amounts, releaseAmounts, releaseTimes, msg.sender);
    }

    function getStartOfToday() private view returns (uint256) {
        uint256 currentTime = block.timestamp;
        uint256 startOfDay = currentTime - (currentTime % 1 days);
        return startOfDay;
    }
}
