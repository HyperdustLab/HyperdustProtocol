pragma solidity ^0.8.0;

contract Test1 {
    function test() public view returns (uint256) {
        uint32 accuracy = 1000000;
        uint256 _totalNum = 10;
        uint256 _activeNum = 2;
        uint256 epochAward = 133942161339421613394;

        uint256 difficuty = (_totalNum * accuracy) / _activeNum;

        uint256 actualEpochAward = (epochAward * accuracy) / difficuty;

        return actualEpochAward;
    }
}
