pragma solidity ^0.8.0;

abstract contract ITest1 {
    uint256 public a;
}

contract Test2 {
    address public adAddress;

    event test(uint256 test);

    function setTest1(address _address) public {
        adAddress = _address;
        emit test(1);
    }

    function getTest1() public view returns (uint256) {
        return ITest1(adAddress).a();
    }
}
