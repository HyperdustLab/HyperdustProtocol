// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../utils/StrUtil.sol";

contract Hyperdust_Token_Test is ERC20, ERC20Burnable, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        address onlyOwner
    ) ERC20(name_, symbol_) Ownable(onlyOwner) {}

    using Strings for *;
    using StrUtil for *;

    uint256 public _monthTime = 600;
    uint256 public _yearTime = 600;

    uint256 public TGE_timestamp = 0;

    uint256 public _totalSupply = 200 ether;

    uint256 public _mintNum = 0;

    address public _GPUMiningAddress;

    uint256 public _GPUMiningTotalAward = (_totalSupply * 68) / 100;

    uint256 public _GPUMiningCurrAward = 0;

    uint32 public _GPUMiningCurrMiningRatio = 100000;

    uint32 public _GPUMiningTotalMiningRatio = _GPUMiningCurrMiningRatio * 10;

    uint256 public _GPUMiningCurrYearTotalSupply =
        (_GPUMiningTotalAward * _GPUMiningCurrMiningRatio) /
            _GPUMiningTotalMiningRatio;

    uint256 public _epochAward = _GPUMiningCurrYearTotalSupply / 365 / 225;

    uint256 public _GPUMiningCurrYearTotalAward = 0;

    uint256 public _GPUMiningReleaseInterval = _yearTime;

    uint256 public _GPUMiningRateInterval = 4 * _yearTime;

    uint256 public _GPUMiningAllowReleaseTime = 0;

    uint256 public _lastGPUMiningRateTime = 0;

    address public _CoreTeamAddeess;

    uint256 public _CoreTeamTotalAward = (_totalSupply * 115) / 1000;

    uint256 public _CoreTeamCurrAward = 0;

    uint256 public _CoreTeamAllowReleaseTime = 0;

    uint256 public _CoreTeamReleaseInterval = _monthTime;

    uint256 public _CoreTeamReleaseTotalAward = _CoreTeamTotalAward / 48;

    uint256 public _CoreTeamReleaseCurrAward = 0;

    address public _FoundationAddress;

    uint256 public _FoundationTotalAward = (_totalSupply * 1025) / 10000;

    uint256 public _FoundationCurrAward = 0;

    uint256 public _FoundationReleaseInterval = _monthTime;

    uint256 public _FoundationReleaseAllowReleaseTime = 0;

    uint256 public _FoundationReleaseTotalAward = _FoundationTotalAward / 48;

    uint256 public _FoundationReleaseCurrAward = 0;

    address public _AdvisorAddress;

    uint256 public _AdvisorAllowReleaseTime = 0;

    uint256 public _AdvisorTotalAward = (_totalSupply * 1) / 100;

    uint256 public _AdvisorCurrAward = 0;

    uint256 public _AdvisorReleaseInterval = _monthTime;

    uint256 public _AdvisorReleaseTotalAward = _AdvisorTotalAward / 12;

    uint256 public _AdvisorReleaseCurrAward = 0;

    address public _SeedAddress;
    uint256 public _SeedAllowReleaseTime = 0;

    uint256 public _SeedTotalAward = (_totalSupply * 125) / 10000;

    uint256 public _SeedCurrAward = 0;

    uint256 public _SeedReleaseInterval = _monthTime;

    uint256 public _SeedReleaseTotalAward = (_SeedTotalAward * 5) / 100;

    uint256 public _SeedMonthReleaseAward =
        (_SeedTotalAward - _SeedReleaseTotalAward) / 18;

    uint256 public _SeedReleaseCurrAward = 0;

    address public _PrivateSaleAddress;

    uint256 public _PrivateSaleTotalAward = (_totalSupply * 3) / 100;
    uint256 public _PrivateSaleCurrAward = 0;

    uint256 public _PrivateSaleReleaseInterval = _monthTime;

    uint256 public _PrivateSaleReleaseTime = 0;
    uint256 public _PrivateSaleReleaseTotalAward =
        (_PrivateSaleTotalAward * 75) / 1000;

    uint256 public _PrivateSaleMonthReleaseAward =
        (_PrivateSaleTotalAward - _PrivateSaleReleaseTotalAward) / 12;

    uint256 public _PrivateSaleReleaseCurrAward = 0;

    address public _PublicSaleAddress;

    uint256 public _PublicSaleTotalAward = (_totalSupply * 3) / 100;
    uint256 public _PublicSaleCurrAward = 0;

    uint256 public _PublicSaleReleaseInterval = _monthTime;

    uint256 public _PublicSaleReleaseTime = 0;
    uint256 public _PublicSaleReleaseTotalAward =
        (_PublicSaleTotalAward * 25) / 100;

    uint256 public _PublicSaleMonthReleaseAward =
        (_PublicSaleTotalAward - _PublicSaleReleaseTotalAward) / 9;

    uint256 public _PublicSaleReleaseCurrAward = 0;

    address public _AirdropAddress;

    uint256 public _AirdropTotalAward = (_totalSupply * 2) / 100;
    uint256 public _AirdropCurrAward = 0;

    uint256 public _AirdropReleaseInterval = _monthTime;

    uint256 public _AirdropReleaseTime = 0;
    uint256 public _AirdropReleaseTotalAward = _AirdropTotalAward / 12;
    uint256 public _AirdropReleaseCurrAward = 0;

    function setGPUMiningAddress(address GPUMiningAddress) public onlyOwner {
        _GPUMiningAddress = GPUMiningAddress;
    }

    function setCoreTeamAddress(address CoreTeamAddress) public onlyOwner {
        _CoreTeamAddeess = CoreTeamAddress;
    }

    function setFoundationAddress(address FoundationAddress) public onlyOwner {
        _FoundationAddress = FoundationAddress;
    }

    function setAdvisorAddress(address AdvisorAddress) public onlyOwner {
        _AdvisorAddress = AdvisorAddress;
    }

    function setSeedAddress(address SeedAddress) public onlyOwner {
        _SeedAddress = SeedAddress;
    }

    function setPrivateSaleAddress(
        address PrivateSaleAddress
    ) public onlyOwner {
        _PrivateSaleAddress = PrivateSaleAddress;
    }

    function setPublicSaleAddress(address PublicSaleAddress) public onlyOwner {
        _PublicSaleAddress = PublicSaleAddress;
    }

    function setAirdropAddress(address AirdropAddress) public onlyOwner {
        _AirdropAddress = AirdropAddress;
    }

    function GPUMiningMint(uint256 mintNum) private {
        require(
            _GPUMiningAllowReleaseTime > 0,
            "The commencement of the release of GPU mining has not yet commenced"
        );

        if (
            block.timestamp >= _lastGPUMiningRateTime + _GPUMiningRateInterval
        ) {
            _GPUMiningCurrMiningRatio = _GPUMiningCurrMiningRatio / 2;
            require(_GPUMiningCurrMiningRatio > 0, "currMiningRatio is 0");

            _lastGPUMiningRateTime += _GPUMiningRateInterval;
        }

        if (
            block.timestamp >=
            _GPUMiningAllowReleaseTime + _GPUMiningReleaseInterval
        ) {
            _GPUMiningCurrYearTotalAward = 0;
            _GPUMiningAllowReleaseTime += _GPUMiningReleaseInterval;

            _GPUMiningCurrYearTotalSupply =
                ((_GPUMiningTotalAward - _GPUMiningCurrAward) *
                    _GPUMiningCurrMiningRatio) /
                _GPUMiningTotalMiningRatio;

            _epochAward = _GPUMiningCurrYearTotalSupply / 365 / 225;
        }

        require(
            _GPUMiningCurrYearTotalSupply -
                _GPUMiningCurrYearTotalAward -
                mintNum >=
                0,
            "currYearTotalSupply is not enough"
        );

        require(
            _GPUMiningTotalAward - _GPUMiningCurrAward - mintNum >= 0,
            "GPUMiningTotalAward is not enough"
        );

        require(_epochAward >= mintNum, "epochAward is not enough");

        _GPUMiningCurrYearTotalAward += mintNum;
        _GPUMiningCurrAward += mintNum;
        _mintNum += mintNum;

        _mint(_GPUMiningAddress, mintNum);
    }

    function CoreTeamMint(uint256 mintNum) private {
        require(
            _CoreTeamAllowReleaseTime > 0,
            "The commencement of the release of core team has not yet commenced"
        );

        if (
            block.timestamp >=
            _CoreTeamAllowReleaseTime + _CoreTeamReleaseInterval
        ) {
            _CoreTeamAllowReleaseTime += _CoreTeamReleaseInterval;

            _CoreTeamReleaseTotalAward =
                (_CoreTeamReleaseTotalAward - _CoreTeamReleaseCurrAward) +
                _CoreTeamTotalAward /
                48;

            _CoreTeamReleaseCurrAward = 0;
        }

        require(block.timestamp >= _CoreTeamAllowReleaseTime, "time is not ok");

        require(
            _CoreTeamTotalAward - _CoreTeamCurrAward - mintNum >= 0,
            "CoreTeamTotalAward is not enough"
        );

        require(
            _CoreTeamReleaseTotalAward - _CoreTeamReleaseCurrAward - mintNum >=
                0,
            "CoreTeamReleaseTotalAward is not enough"
        );

        _CoreTeamCurrAward += mintNum;
        _CoreTeamReleaseCurrAward += mintNum;
        _mintNum += mintNum;

        _mint(_CoreTeamAddeess, mintNum);
    }

    function FoundationMint(uint256 mintNum) private {
        require(
            _FoundationReleaseAllowReleaseTime > 0,
            "The commencement of the release of foundation has not yet commenced"
        );

        if (
            block.timestamp >=
            _FoundationReleaseAllowReleaseTime + _FoundationReleaseInterval
        ) {
            _FoundationReleaseAllowReleaseTime += _FoundationReleaseInterval;

            _FoundationReleaseTotalAward =
                (_FoundationReleaseTotalAward - _FoundationReleaseCurrAward) +
                (_FoundationTotalAward / 48);

            _FoundationReleaseCurrAward = 0;
        }

        require(
            _FoundationReleaseTotalAward -
                _FoundationReleaseCurrAward -
                mintNum >=
                0,
            "_FoundationReleaseTotalAward is not enough"
        );

        require(
            _FoundationTotalAward - _FoundationCurrAward - mintNum >= 0,
            "_FoundationTotalAward is not enough"
        );

        _FoundationCurrAward += mintNum;
        _FoundationReleaseCurrAward += mintNum;
        _mintNum += mintNum;

        _mint(_FoundationAddress, mintNum);
    }

    function AdvisorMint(uint256 mintNum) private {
        require(
            _FoundationReleaseAllowReleaseTime > 0,
            "The commencement of the release of advisor has not yet commenced"
        );

        if (
            block.timestamp >=
            _AdvisorAllowReleaseTime + _AdvisorReleaseInterval
        ) {
            _AdvisorAllowReleaseTime += _CoreTeamReleaseInterval;

            _AdvisorReleaseTotalAward =
                (_AdvisorReleaseTotalAward - _AdvisorReleaseCurrAward) +
                _AdvisorTotalAward /
                12;
            _AdvisorReleaseCurrAward = 0;
        }

        require(block.timestamp >= _AdvisorAllowReleaseTime, "time is not ok");

        require(
            _AdvisorTotalAward - _AdvisorCurrAward - mintNum >= 0,
            "AdvisorTotalAward is not enough"
        );

        require(
            _AdvisorReleaseTotalAward - _AdvisorReleaseCurrAward - mintNum >= 0,
            "AdvisorReleaseTotalAward is not enough"
        );

        _AdvisorCurrAward += mintNum;
        _AdvisorReleaseCurrAward += mintNum;
        _mintNum += mintNum;
        _mint(_AdvisorAddress, mintNum);
    }

    function SeedMint(uint256 mintNum) private {
        require(
            _SeedAllowReleaseTime > 0,
            "The commencement of the release of seed has not yet commenced"
        );

        if (block.timestamp >= _SeedAllowReleaseTime + _SeedReleaseInterval) {
            _SeedAllowReleaseTime += _SeedReleaseInterval;

            _SeedReleaseTotalAward =
                (_SeedReleaseTotalAward - _SeedReleaseCurrAward) +
                _SeedMonthReleaseAward;
            _SeedReleaseCurrAward = 0;
        }

        require(block.timestamp >= _SeedAllowReleaseTime, "time is not ok");

        require(
            _SeedTotalAward - _SeedCurrAward - mintNum >= 0,
            "SeedTotalAward is not enough"
        );

        require(
            _SeedReleaseTotalAward - _SeedReleaseCurrAward - mintNum >= 0,
            "SeedReleaseTotalAward is not enough"
        );

        _SeedCurrAward += mintNum;
        _SeedReleaseCurrAward += mintNum;
        _mintNum += mintNum;
        _mint(_SeedAddress, mintNum);
    }

    function PrivateSaleMint(uint256 mintNum) private {
        require(
            _PrivateSaleReleaseTime > 0,
            "The commencement of the release of private sale has not yet commenced"
        );

        if (
            block.timestamp >=
            _PrivateSaleReleaseTime + _PrivateSaleReleaseInterval
        ) {
            _PrivateSaleReleaseTime += _PrivateSaleReleaseInterval;

            _PrivateSaleReleaseTotalAward =
                (_PrivateSaleReleaseTotalAward - _PrivateSaleReleaseCurrAward) +
                _PrivateSaleMonthReleaseAward;
            _PrivateSaleReleaseCurrAward = 0;
        }

        require(
            _PrivateSaleReleaseTotalAward -
                _PrivateSaleReleaseCurrAward -
                mintNum >=
                0,
            "PrivateSaleReleaseTotalAward is not enough"
        );

        require(
            _PrivateSaleTotalAward - _PrivateSaleCurrAward - mintNum >= 0,
            "PrivateSaleTotalAward is not enough"
        );

        _PrivateSaleCurrAward += mintNum;
        _PrivateSaleReleaseCurrAward += mintNum;
        _mintNum += mintNum;
        _mint(_PrivateSaleAddress, mintNum);
    }

    function PublicSaleMint(uint256 mintNum) private {
        require(
            _PublicSaleReleaseTime > 0,
            "The commencement of the release of public sale has not yet commenced"
        );

        if (
            block.timestamp >=
            _PublicSaleReleaseTime + _PublicSaleReleaseInterval
        ) {
            _PublicSaleReleaseTime += _PublicSaleReleaseInterval;

            _PublicSaleReleaseTotalAward =
                (_PublicSaleReleaseTotalAward - _PublicSaleReleaseCurrAward) +
                _PublicSaleMonthReleaseAward;
            _PublicSaleReleaseCurrAward = 0;
        }

        require(
            _PublicSaleReleaseTotalAward -
                _PublicSaleReleaseCurrAward -
                mintNum >=
                0,
            "PublicSaleReleaseTotalAward is not enough"
        );

        require(
            _PublicSaleTotalAward - _PublicSaleCurrAward - mintNum >= 0,
            "PublicSaleTotalAward is not enough"
        );

        _PublicSaleCurrAward += mintNum;
        _PublicSaleReleaseCurrAward += mintNum;
        _mintNum += mintNum;
        _mint(_PublicSaleAddress, mintNum);
    }

    function AirdropMint(uint256 mintNum) private {
        require(
            _AirdropReleaseTime > 0,
            "The commencement of the release of airdrop has not yet commenced"
        );

        if (block.timestamp >= _AirdropReleaseTime + _AirdropReleaseInterval) {
            _AirdropReleaseTime += _AirdropReleaseInterval;

            _AirdropReleaseTotalAward =
                (_AirdropReleaseTotalAward - _AirdropReleaseCurrAward) +
                _AirdropTotalAward /
                12;
            _AirdropReleaseCurrAward = 0;
        }

        require(block.timestamp >= _AirdropReleaseTime, "time is not ok");

        require(
            _AirdropTotalAward - _AirdropCurrAward - mintNum >= 0,
            "AirdropTotalAward is not enough"
        );

        require(
            _AirdropReleaseTotalAward - _AirdropReleaseCurrAward - mintNum >= 0,
            "AirdropReleaseTotalAward is not enough"
        );

        _AirdropCurrAward += mintNum;
        _AirdropReleaseCurrAward += mintNum;
        _mintNum += mintNum;
        _mint(_AirdropAddress, mintNum);
    }

    function mint(uint256 amount) public {
        require(
            _mintNum + amount <= totalSupply(),
            "totalSupply is not enough"
        );

        if (msg.sender == _GPUMiningAddress) {
            GPUMiningMint(amount);
        } else if (msg.sender == _CoreTeamAddeess) {
            CoreTeamMint(amount);
        } else if (msg.sender == _FoundationAddress) {
            FoundationMint(amount);
        } else if (msg.sender == _AdvisorAddress) {
            AdvisorMint(amount);
        } else if (msg.sender == _SeedAddress) {
            SeedMint(amount);
        } else if (msg.sender == _PrivateSaleAddress) {
            PrivateSaleMint(amount);
        } else if (msg.sender == _PublicSaleAddress) {
            PublicSaleMint(amount);
        } else if (msg.sender == _AirdropAddress) {
            AirdropMint(amount);
        } else {
            revert("msg.sender is not allowed");
        }
    }

    function startTGETimestamp() public onlyOwner {
        TGE_timestamp = block.timestamp;
        _GPUMiningAllowReleaseTime = TGE_timestamp;
        _lastGPUMiningRateTime = TGE_timestamp;
        _CoreTeamAllowReleaseTime = TGE_timestamp + 3 * _monthTime;
        _FoundationReleaseAllowReleaseTime = TGE_timestamp;
        _AdvisorAllowReleaseTime = TGE_timestamp + _monthTime;
        _SeedAllowReleaseTime = TGE_timestamp + _monthTime;
        _PrivateSaleReleaseTime = TGE_timestamp + _monthTime;
        _PublicSaleReleaseTime = TGE_timestamp + _monthTime;
        _AirdropReleaseTime = TGE_timestamp + 6 * _monthTime;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
}
