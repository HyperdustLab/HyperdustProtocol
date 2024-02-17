// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../utils/StrUtil.sol";

contract Hyperdust_Token is ERC20, ERC20Burnable, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        address onlyOwner
    ) ERC20(name_, symbol_) Ownable(onlyOwner) {}

    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public _totalSupply = 200000000 ether;

    uint256 public _mintNum = 0;

    address public _GPUMiningAddress;

    uint256 public _GPUMiningTotalAward = (_totalSupply * 68) / 100;

    uint256 public _GPUMiningCurrAward = 0;

    address public _CoreTeamAddeess;

    uint256 public _CoreTeamTotalAward = (_totalSupply * 115) / 1000;

    uint256 public _CoreTeamCurrAward = 0;

    address public _FoundationAddress;

    uint256 public _FoundationTotalAward = (_totalSupply * 1025) / 10000;

    uint256 public _FoundationCurrAward = 0;

    address public _AdvisorAddress;

    uint256 public _AdvisorTotalAward = (_totalSupply * 1) / 100;

    uint256 public _AdvisorCurrAward = 0;

    address public _SeedAddress;

    uint256 public _SeedTotalAward = (_totalSupply * 125) / 10000;

    uint256 public _SeedCurrAward = 0;

    address public _PrivateSaleAddress;

    uint256 public _PrivateSaleTotalAward = (_totalSupply * 3) / 100;
    uint256 public _PrivateSaleCurrAward = 0;

    address public _PublicSaleAddress;

    uint256 public _PublicSaleTotalAward = (_totalSupply * 3) / 100;
    uint256 public _PublicSaleCurrAward = 0;

    address public _AirdropAddress;

    uint256 public _AirdropTotalAward = (_totalSupply * 2) / 100;
    uint256 public _AirdropCurrAward = 0;

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
            _GPUMiningTotalAward - _GPUMiningCurrAward - mintNum >= 0,
            "GPUMiningTotalAward is not enough"
        );

        _GPUMiningCurrAward += mintNum;
        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_GPUMiningAddress, mintNum);
    }

    function CoreTeamMint(uint256 mintNum) private {
        _CoreTeamCurrAward += mintNum;

        require(
            _CoreTeamTotalAward >= _CoreTeamCurrAward,
            "CoreTeamTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_CoreTeamAddeess, mintNum);
    }

    function FoundationMint(uint256 mintNum) private {
        require(mintNum > 0, "There is no mintable amount");

        _FoundationCurrAward += mintNum;

        require(
            _FoundationCurrAward <= _FoundationTotalAward,
            "FoundationTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_FoundationAddress, mintNum);
    }

    function AdvisorMint(uint256 mintNum) private {
        require(mintNum > 0, "There is no mintable amount");

        _AdvisorCurrAward += mintNum;

        require(
            _AdvisorTotalAward >= _AdvisorCurrAward,
            "AdvisorTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_AdvisorAddress, mintNum);
    }

    function SeedMint(uint256 mintNum) private {
        require(mintNum > 0, "There is no mintable amount");

        _SeedCurrAward += mintNum;

        require(
            _SeedTotalAward >= _SeedCurrAward,
            "SeedTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_SeedAddress, mintNum);
    }

    function PrivateSaleMint(uint256 mintNum) private {
        require(mintNum > 0, "There is no mintable amount");

        _PrivateSaleCurrAward += mintNum;

        require(
            _PrivateSaleTotalAward >= _PrivateSaleCurrAward,
            "_PrivateSaleTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_PrivateSaleAddress, mintNum);
    }

    function PublicSaleMint(uint256 mintNum) private {
        require(mintNum > 0, "There is no mintable amount");

        _PublicSaleCurrAward += mintNum;

        require(
            _PublicSaleTotalAward >= _PublicSaleCurrAward,
            "_PublicSaleTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_PublicSaleAddress, mintNum);
    }

    function AirdropMint(uint256 mintNum) private {
        _AirdropCurrAward += mintNum;
        require(
            _AirdropTotalAward >= _AirdropCurrAward,
            "_AirdropTotalAward is not enough"
        );
        _mintNum += mintNum;
        require(_mintNum <= _totalSupply, "totalSupply is not enough");
        _mint(_AirdropAddress, mintNum);
    }

    function mint(uint256 mintNum) public {
        if (msg.sender == _GPUMiningAddress) {
            GPUMiningMint(mintNum);
        } else if (msg.sender == _CoreTeamAddeess) {
            CoreTeamMint(mintNum);
        } else if (msg.sender == _FoundationAddress) {
            FoundationMint(mintNum);
        } else if (msg.sender == _AdvisorAddress) {
            AdvisorMint(mintNum);
        } else if (msg.sender == _SeedAddress) {
            SeedMint(mintNum);
        } else if (msg.sender == _PrivateSaleAddress) {
            PrivateSaleMint(mintNum);
        } else if (msg.sender == _PublicSaleAddress) {
            PublicSaleMint(mintNum);
        } else if (msg.sender == _AirdropAddress) {
            AirdropMint(mintNum);
        } else {
            revert("msg.sender is not allowed");
        }
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
}
