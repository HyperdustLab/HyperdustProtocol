pragma solidity ^0.8.0;

contract Test1 {
    function test() public view returns (uint256) {
        uint256 a = 136000000000000000000000000;
        uint256 b = 3000000000000000000;
        uint256 c = 625000000000;
        uint256 d = 10000000000000;

        uint256 actualEpochAward = ((a - b) * c) / d;

        return actualEpochAward;
    }
}
