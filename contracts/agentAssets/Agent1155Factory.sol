pragma solidity ^0.8.0;

import "./Agent_1155.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Agent1155Factory is OwnableUpgradeable {
    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function deploy(address account, string memory name, string memory symbol) public returns (address) {
        require(account != address(0x0), "account is zero address");
        Agent_1155 _gent1155Address = new Agent_1155(account, name, symbol);

        address gent1155Address = address(_gent1155Address);

        return gent1155Address;
    }
}
