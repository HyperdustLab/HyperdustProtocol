pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/Math.sol";

contract Test1 {
    uint256 constant FACTOR = 10 ** 18;

    function test() public view returns (uint256) {
        uint256 a = 136000000000000000000000000;
        uint256 c = 625000000000000000;

        //5 2.5  1.25 0.615
        uint256 b = Math.mulDiv(a, c, FACTOR * 100);
        return b;
    }
}
