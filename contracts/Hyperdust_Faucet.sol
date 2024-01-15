pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "./utils/StrUtil.sol";

contract Hyperdust_AirDrop is Ownable {
    address public _HyperdustTokenAddress;
    address public _fromAddress;
    using Strings for *;

    using StrUtil for *;

    constructor() Ownable(msg.sender) {}

    mapping(address => bool) public _airDropMap;

    function setHyperdustTokenAddress(
        address HyperdustTokenAddress
    ) public onlyOwner {
        _HyperdustTokenAddress = HyperdustTokenAddress;
    }

    function setFromAddress(address fromAddress) public onlyOwner {
        _fromAddress = fromAddress;
    }

    function Transfer(
        address[] memory accounts,
        uint256[] memory amounts
    ) public onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            if (_airDropMap[accounts[i]]) {
                string memory errMsg = "airDrop: already airDrop "
                    .toSlice()
                    .concat(accounts[i].toHexString().toSlice());
                revert(errMsg);
            }

            IERC20(_HyperdustTokenAddress).transferFrom(
                _fromAddress,
                accounts[i],
                amounts[i]
            );

            _airDropMap[accounts[i]] = true;
        }
    }
}
