// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hyperdust_Token is ERC20, ERC20Burnable, Ownable {
    uint256 private _totalSupply = 200000000 ether;

    uint256 public _mintNum = 0;

    uint256 public TGE_timestamp;

    bytes32 public constant GPU_MINING = keccak256("GPU_MINING");
    bytes32 public constant CORE_TEAM = keccak256("CORE_TEAM");
    bytes32 public constant FOUNDATION = keccak256("FOUNDATION");
    bytes32 public constant ADVISOR = keccak256("ADVISOR");
    bytes32 public constant SEED = keccak256("SEED");
    bytes32 public constant PRIVATE_SALE = keccak256("PRIVATE_SALE");
    bytes32 public constant PUBLIC_SALE = keccak256("PUBLIC_SALE");
    bytes32 public constant AIRDROP = keccak256("AIRDROP");

    mapping(bytes32 => uint256) private _totalAward;
    mapping(bytes32 => uint256) private _currAward;
    mapping(bytes32 => address) private _minterAddeess;
    mapping(address => bytes32) private _bytes32Address;

    uint256 public _lastGPU_MINING_mint_time;
    uint256 public _maxMININGMintNum = 1133334 ether;

    constructor(
        string memory name_,
        string memory symbol_,
        address onlyOwner
    ) ERC20(name_, symbol_) Ownable(onlyOwner) {
        _totalAward[GPU_MINING] = (_totalSupply * 68) / 100;
        _totalAward[CORE_TEAM] = (_totalSupply * 115) / 1000;
        _totalAward[FOUNDATION] = (_totalSupply * 1025) / 10000;
        _totalAward[ADVISOR] = (_totalSupply * 1) / 100;
        _totalAward[SEED] = (_totalSupply * 125) / 10000;
        _totalAward[PRIVATE_SALE] = (_totalSupply * 3) / 100;
        _totalAward[PUBLIC_SALE] = (_totalSupply * 3) / 100;
        _totalAward[AIRDROP] = (_totalSupply * 2) / 100;
    }

    function setMinterAddeess(bytes32 name, address account) public onlyOwner {
        _minterAddeess[name] = account;

        _bytes32Address[account] = name;
    }

    function mint(uint256 mintNum) public {
        require(
            block.timestamp >= TGE_timestamp,
            "TGE_timestamp is not started"
        );

        bytes32 name = _bytes32Address[msg.sender];

        require(name != bytes32(0), "msg.sender is not allowed");

        require(
            _minterAddeess[name] == msg.sender,
            "msg.sender is not allowed"
        );

        _currAward[name] += mintNum;

        require(
            _totalAward[name] >= _currAward[name],
            "totalAward is not enough"
        );

        if (name == GPU_MINING) {
            require(
                block.timestamp >= _lastGPU_MINING_mint_time + 30 days,
                "GPU_MINING mint time is not enough"
            );

            require(mintNum <= _maxMININGMintNum, "mintNum is not enough");

            _lastGPU_MINING_mint_time = block.timestamp;
        }

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(msg.sender, mintNum);
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function totalAward(bytes32 name) public view returns (uint256) {
        return _totalAward[name];
    }

    function currAward(bytes32 name) public view returns (uint256) {
        return _currAward[name];
    }

    function minterAddeess(bytes32 name) public view returns (address) {
        return _minterAddeess[name];
    }

    function bytes32Address(address account) public view returns (bytes32) {
        return _bytes32Address[account];
    }
}
