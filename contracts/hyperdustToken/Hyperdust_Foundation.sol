import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";
import "./Hyperdust_Token.sol";

contract Hyperdust_Foundation is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public TGE_timestamp;

    uint256 public _monthTime;

    uint256 public _FoundationTotalAward;

    uint256 public _FoundationCurrAward;

    uint256 private _FoundationReleaseInterval;

    uint256 private _FoundationMonthReleaseAward;
    uint256 private _FoundationReleaseTotalAward;

    uint256 public _FoundationReleaseAllowReleaseTime;

    address public _HyperdustTokenAddress;

    address public _MintAccountAddress;

    function initialize(
        address onlyOwner,
        uint256 monthTime
    ) public initializer {
        __Ownable_init(onlyOwner);
        _monthTime = monthTime;
        _FoundationTotalAward = (200000000 ether * 1025) / 10000;
        _FoundationReleaseInterval = monthTime;
        _FoundationMonthReleaseAward = _FoundationTotalAward / 48;
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

    function getFoundationCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _FoundationReleaseAllowReleaseTime > 0,
            "The commencement of the release of foundation has not yet commenced"
        );

        if (block.timestamp < _FoundationReleaseAllowReleaseTime) {
            return (0, 0);
        }

        uint256 FoundationReleaseTotalAward = _FoundationReleaseTotalAward;

        uint256 time = block.timestamp - _FoundationReleaseAllowReleaseTime;

        time = time - (time % _FoundationReleaseInterval);

        uint256 num = time / _FoundationReleaseInterval;

        if (num > 0) {
            uint256 addAward = _FoundationMonthReleaseAward * num;

            uint256 totalMintAward = 0;
            if (
                _FoundationTotalAward <
                _FoundationCurrAward + _FoundationReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _FoundationTotalAward -
                    _FoundationCurrAward -
                    _FoundationReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            FoundationReleaseTotalAward += addAward;
        }

        return (
            FoundationReleaseTotalAward - _FoundationCurrAward,
            FoundationReleaseTotalAward
        );
    }

    function mint(address account) public {
        require(msg.sender == _MintAccountAddress, "msg.sender is not allowed");

        require(
            _FoundationReleaseAllowReleaseTime > 0,
            "The commencement of the release of foundation has not yet commenced"
        );

        require(
            block.timestamp >= _FoundationReleaseAllowReleaseTime,
            "time is not ok"
        );
        uint256 time = block.timestamp - _FoundationReleaseAllowReleaseTime;

        time = time - (time % _FoundationReleaseInterval);

        uint256 num = time / _FoundationReleaseInterval;

        if (num > 0) {
            uint256 addAward = _FoundationMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (
                _FoundationTotalAward <
                _FoundationCurrAward + _FoundationReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _FoundationTotalAward -
                    _FoundationCurrAward -
                    _FoundationReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _FoundationReleaseTotalAward += addAward;
            _FoundationReleaseAllowReleaseTime +=
                num *
                _FoundationReleaseInterval;
        }

        uint256 mintNum = _FoundationReleaseTotalAward - _FoundationCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _FoundationCurrAward += mintNum;

        require(
            _FoundationTotalAward >= _FoundationCurrAward,
            "_FoundationReleaseTotalAward is not enough"
        );

        Hyperdust_Token(_HyperdustTokenAddress).mint(mintNum);

        IERC20(_HyperdustTokenAddress).transfer(account, mintNum);
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
        _FoundationReleaseAllowReleaseTime = TGE_timestamp + _monthTime;
    }
}
