import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";
import "./Hyperdust_Token.sol";

contract Hyperdust_Advisor is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public TGE_timestamp;

    uint256 public _monthTime;

    uint256 public _AdvisorAllowReleaseTime;
    uint256 public _AdvisorTotalAward;
    uint256 public _AdvisorCurrAward;
    uint256 private _AdvisorReleaseInterval;
    uint256 private _AdvisorMonthReleaseAward;
    uint256 private _AdvisorReleaseTotalAward;

    address public _HyperdustTokenAddress;

    address public _MintAccountAddress;

    function initialize(
        address onlyOwner,
        uint256 monthTime
    ) public initializer {
        __Ownable_init(onlyOwner);
        _monthTime = monthTime;
        _AdvisorTotalAward = (200000000 ether * 1) / 100;
        _AdvisorReleaseInterval = monthTime;
        _AdvisorMonthReleaseAward = _AdvisorTotalAward / 12;
        _AdvisorReleaseTotalAward = _AdvisorMonthReleaseAward;
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

    function getAdvisorCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _AdvisorAllowReleaseTime > 0,
            "The commencement of the release of advisor has not yet commenced"
        );

        if (block.timestamp < _AdvisorAllowReleaseTime) {
            return (0, 0);
        }

        uint256 AdvisorReleaseTotalAward = _AdvisorReleaseTotalAward;

        uint256 time = block.timestamp - _AdvisorAllowReleaseTime;

        time = time - (time % _AdvisorReleaseInterval);

        uint256 num = time / _AdvisorReleaseInterval;

        if (num > 0) {
            uint256 addAward = _AdvisorMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (
                _AdvisorTotalAward <
                _AdvisorCurrAward + _AdvisorReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _AdvisorTotalAward -
                    _AdvisorCurrAward -
                    _AdvisorReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            AdvisorReleaseTotalAward += addAward;
        }

        return (
            AdvisorReleaseTotalAward - _AdvisorCurrAward,
            AdvisorReleaseTotalAward
        );
    }

    function mint(address account) public {
        require(msg.sender == _MintAccountAddress, "msg.sender is not allowed");

        require(
            _AdvisorAllowReleaseTime > 0,
            "The commencement of the release of advisor has not yet commenced"
        );

        require(block.timestamp >= _AdvisorAllowReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _AdvisorAllowReleaseTime;

        time = time - (time % _AdvisorReleaseInterval);

        uint256 num = time / _AdvisorReleaseInterval;

        if (num > 0) {
            uint256 addAward = _AdvisorMonthReleaseAward * num;

            uint256 totalMintAward = 0;
            if (
                _AdvisorTotalAward <
                _AdvisorCurrAward + _AdvisorReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _AdvisorTotalAward -
                    _AdvisorCurrAward -
                    _AdvisorReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _AdvisorReleaseTotalAward += addAward;

            _AdvisorAllowReleaseTime += num * _AdvisorReleaseInterval;
        }

        uint256 mintNum = _AdvisorReleaseTotalAward - _AdvisorCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _AdvisorCurrAward += mintNum;

        require(
            _AdvisorTotalAward >= _AdvisorCurrAward,
            "AdvisorTotalAward is not enough"
        );

        Hyperdust_Token(_HyperdustTokenAddress).mint(mintNum);

        IERC20(_HyperdustTokenAddress).transfer(account, mintNum);
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
        _AdvisorAllowReleaseTime = TGE_timestamp + _monthTime;
    }
}
