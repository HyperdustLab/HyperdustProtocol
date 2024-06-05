pragma solidity ^0.8.0;

import "./Agent_721.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Agent721Factory is OwnableUpgradeable {
    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function deploy(address account, string memory name, string memory symbol) public returns (address) {
        require(account != address(0x0), "account is zero address");
        Agent_721 agent721Address = new Agent_721(account, name, symbol);

        address _agent721Address = address(agent721Address);

        return _agent721Address;
    }
}
