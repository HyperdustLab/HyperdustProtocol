pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/Math.sol";

contract Test1 {
    function test() public view returns (uint256) {
        uint256 _totalNum = 1000;
        uint256 _activeNum = 1;

        uint256 renderPrice = 38000;

        uint256 accuracy = 10000000000000;

        uint256 difficuty = (_totalNum * accuracy) / _activeNum;

        uint256 gasPrice = (renderPrice * accuracy) / difficuty;

        uint256 gasFee = (renderPrice * gasPrice * 1 ether) / accuracy;

        return gasFee;
    }
}
