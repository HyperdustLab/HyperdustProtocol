import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";
import "./Hyperdust_Token.sol";

contract Hyperdust_CoreTeam is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public TGE_timestamp;

    uint256 public _monthTime;

    uint256 public _CoreTeamTotalAward;

    uint256 public _CoreTeamCurrAward;

    uint256 public _CoreTeamAllowReleaseTime;

    uint256 private _CoreTeamReleaseTotalAward;

    address public _HyperdustTokenAddress;

    address public _MintAccountAddress;

    uint256 private _CoreTeamReleaseInterval;

    uint256 private _CoreTeamMonthReleaseAward;

    function initialize(
        address onlyOwner,
        uint256 monthTime
    ) public initializer {
        __Ownable_init(onlyOwner);
        _monthTime = monthTime;
        _CoreTeamTotalAward = (200000000 ether * 115) / 1000;
        _CoreTeamMonthReleaseAward = _CoreTeamTotalAward / 48;
        _CoreTeamReleaseTotalAward = _CoreTeamReleaseTotalAward;
        _CoreTeamReleaseInterval = monthTime;
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

    function getCoreTeamCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _CoreTeamAllowReleaseTime > 0,
            "The commencement of the release of core team has not yet commenced"
        );

        if (block.timestamp < _CoreTeamAllowReleaseTime) {
            return (0, 0);
        }

        uint256 CoreTeamReleaseTotalAward = _CoreTeamReleaseTotalAward;
        uint256 time = block.timestamp - _CoreTeamAllowReleaseTime;

        time = time - (time % _CoreTeamReleaseInterval);

        uint256 num = time / _CoreTeamReleaseInterval;

        if (num > 0) {
            uint256 addAward = _CoreTeamMonthReleaseAward * (num);
            uint256 totalMintAward = 0;
            if (
                _CoreTeamTotalAward <
                _CoreTeamCurrAward + _CoreTeamReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _CoreTeamTotalAward -
                    _CoreTeamCurrAward -
                    _CoreTeamReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            CoreTeamReleaseTotalAward += addAward;
        }

        return (
            CoreTeamReleaseTotalAward - _CoreTeamCurrAward,
            CoreTeamReleaseTotalAward
        );
    }

    function mint(address account) public {
        require(msg.sender == _MintAccountAddress, "msg.sender is not allowed");

        require(
            _CoreTeamAllowReleaseTime > 0,
            "The commencement of the release of core team has not yet commenced"
        );

        require(block.timestamp >= _CoreTeamAllowReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _CoreTeamAllowReleaseTime;

        time = time - (time % _CoreTeamReleaseInterval);

        uint256 num = time / _CoreTeamReleaseInterval;

        if (num > 0) {
            uint256 addAward = _CoreTeamMonthReleaseAward * num;

            uint256 totalMintAward = 0;
            if (
                _CoreTeamTotalAward <
                _CoreTeamCurrAward + _CoreTeamReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _CoreTeamTotalAward -
                    _CoreTeamCurrAward -
                    _CoreTeamReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _CoreTeamReleaseTotalAward += addAward;
            _CoreTeamAllowReleaseTime += num * _CoreTeamReleaseInterval;
        }

        uint256 mintNum = _CoreTeamReleaseTotalAward - _CoreTeamCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _CoreTeamCurrAward += mintNum;

        require(
            _CoreTeamTotalAward >= _CoreTeamCurrAward,
            "CoreTeamTotalAward is not enough"
        );
        Hyperdust_Token(_HyperdustTokenAddress).mint(mintNum);

        IERC20(_HyperdustTokenAddress).transfer(account, mintNum);
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
        _CoreTeamAllowReleaseTime = TGE_timestamp + 3 * _monthTime;
    }
}
