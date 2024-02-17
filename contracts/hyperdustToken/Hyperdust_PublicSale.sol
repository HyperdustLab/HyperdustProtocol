import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";
import "./Hyperdust_Token.sol";

contract Hyperdust_PublicSale is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public TGE_timestamp;

    uint256 public _monthTime;

    uint256 public _PublicSaleTotalAward;
    uint256 public _PublicSaleCurrAward;
    uint256 private _PublicSaleReleaseInterval;
    uint256 public _PublicSaleReleaseTime;
    uint256 private _PublicSaleReleaseTotalAward;
    uint256 private _PublicSaleMonthReleaseAward;

    address public _HyperdustTokenAddress;

    address public _MintAccountAddress;

    function initialize(
        address onlyOwner,
        uint256 monthTime
    ) public initializer {
        __Ownable_init(onlyOwner);
        _monthTime = monthTime;
        _PublicSaleTotalAward = (200000000 ether * 3) / 100;
        _PublicSaleReleaseInterval = monthTime;
        _PublicSaleReleaseTotalAward = (_PublicSaleTotalAward * 25) / 100;
        _PublicSaleMonthReleaseAward =
            (_PublicSaleTotalAward - _PublicSaleReleaseTotalAward) /
            9;
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

    function getPublicSaleCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _PublicSaleReleaseTime > 0,
            "The commencement of the release of public sale has not yet commenced"
        );

        if (block.timestamp < _PublicSaleReleaseTime) {
            return (0, 0);
        }

        uint256 PublicSaleReleaseTotalAward = _PublicSaleReleaseTotalAward;

        uint256 time = block.timestamp - _PublicSaleReleaseTime;

        time = time - (time % _PublicSaleReleaseInterval);

        uint256 num = time / _PublicSaleReleaseInterval;

        if (num > 0) {
            uint256 addAward = _PublicSaleMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (
                _PublicSaleTotalAward <
                _PublicSaleCurrAward + _PublicSaleReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _PublicSaleTotalAward -
                    _PublicSaleCurrAward -
                    _PublicSaleReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            PublicSaleReleaseTotalAward += addAward;
        }

        return (
            PublicSaleReleaseTotalAward - _PublicSaleCurrAward,
            PublicSaleReleaseTotalAward
        );
    }

    function mint(address account) public {
        require(msg.sender == _MintAccountAddress, "msg.sender is not allowed");

        require(
            _PublicSaleReleaseTime > 0,
            "The commencement of the release of public sale has not yet commenced"
        );

        require(block.timestamp >= _PublicSaleReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _PublicSaleReleaseTime;

        time = time - (time % _PublicSaleReleaseInterval);

        uint256 num = time / _PublicSaleReleaseInterval;

        if (num > 0) {
            uint256 addAward = _PublicSaleMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (
                _PublicSaleTotalAward <
                _PublicSaleCurrAward + _PublicSaleReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _PublicSaleTotalAward -
                    _PublicSaleCurrAward -
                    _PublicSaleReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _PublicSaleReleaseTotalAward += addAward;
            _PublicSaleReleaseTime += num * _PublicSaleReleaseInterval;
        }

        uint256 mintNum = _PublicSaleReleaseTotalAward - _PublicSaleCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _PublicSaleCurrAward += mintNum;

        require(
            _PublicSaleTotalAward >= _PublicSaleCurrAward,
            "_PublicSaleTotalAward is not enough"
        );

        Hyperdust_Token(_HyperdustTokenAddress).mint(mintNum);

        IERC20(_HyperdustTokenAddress).transfer(account, mintNum);
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
        _PublicSaleReleaseTime = TGE_timestamp;
    }
}
