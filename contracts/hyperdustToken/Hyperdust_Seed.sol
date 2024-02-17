import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";
import "./Hyperdust_Token.sol";

contract Hyperdust_Seed is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public TGE_timestamp;

    uint256 public _monthTime;

    uint256 public _SeedAllowReleaseTime;

    uint256 public _SeedTotalAward;

    uint256 public _SeedCurrAward;

    uint256 private _SeedReleaseInterval;

    uint256 private _SeedReleaseTotalAward;

    uint256 private _SeedMonthReleaseAward;

    address public _HyperdustTokenAddress;

    address public _MintAccountAddress;

    function initialize(
        address onlyOwner,
        uint256 monthTime
    ) public initializer {
        __Ownable_init(onlyOwner);
        _monthTime = monthTime;
        _SeedTotalAward = (200000000 ether * 125) / 10000;
        _SeedReleaseInterval = monthTime;
        _SeedReleaseTotalAward = (_SeedTotalAward * 5) / 100;
        _SeedMonthReleaseAward =
            (_SeedTotalAward - _SeedReleaseTotalAward) /
            18;
    }

    function setHyperdustTokenAddress(
        address HyperdustTokenAddress
    ) public onlyOwner {
        _HyperdustTokenAddress = HyperdustTokenAddress;
    }

    function setMintAccountAddress(
        address MintAccountAddress
    ) public onlyOwner {
        _MintAccountAddress = MintAccountAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _HyperdustTokenAddress = contractaddressArray[0];
        _MintAccountAddress = contractaddressArray[1];
    }

    function getSeedCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _SeedAllowReleaseTime > 0,
            "The commencement of the release of seed has not yet commenced"
        );

        if (block.timestamp < _SeedAllowReleaseTime) {
            return (0, 0);
        }

        uint256 SeedReleaseTotalAward = _SeedReleaseTotalAward;

        uint256 time = block.timestamp - _SeedAllowReleaseTime;

        time = time - (time % _SeedReleaseInterval);

        uint256 num = time / _SeedReleaseInterval;

        if (num > 0) {
            uint256 addAward = _SeedMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (_SeedTotalAward < _SeedCurrAward + _SeedReleaseTotalAward) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _SeedTotalAward -
                    _SeedCurrAward -
                    _SeedReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            SeedReleaseTotalAward += addAward;
        }

        return (SeedReleaseTotalAward - _SeedCurrAward, SeedReleaseTotalAward);
    }

    function mint(address account) public {
        require(msg.sender == _MintAccountAddress, "msg.sender is not allowed");

        require(
            _SeedAllowReleaseTime > 0,
            "The commencement of the release of seed has not yet commenced"
        );

        require(block.timestamp >= _SeedAllowReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _SeedAllowReleaseTime;

        time = time - (time % _SeedReleaseInterval);

        uint256 num = time / _SeedReleaseInterval;

        if (num > 0) {
            uint256 addAward = _SeedMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (_SeedTotalAward < _SeedCurrAward + _SeedReleaseTotalAward) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _SeedTotalAward -
                    _SeedCurrAward -
                    _SeedReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _SeedReleaseTotalAward += addAward;

            _SeedAllowReleaseTime += num * _SeedReleaseInterval;
        }

        uint256 mintNum = _SeedReleaseTotalAward - _SeedCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _SeedCurrAward += mintNum;

        require(
            _SeedTotalAward >= _SeedCurrAward,
            "SeedTotalAward is not enough"
        );

        Hyperdust_Token(_HyperdustTokenAddress).mint(mintNum);

        IERC20(_HyperdustTokenAddress).transfer(account, mintNum);
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
        _SeedAllowReleaseTime = TGE_timestamp;
    }
}
