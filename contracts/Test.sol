pragma solidity ^0.8.7;

pragma solidity ^0.8.0;

contract EndiannessExample {
    constructor() {}

    function getIndividualBytes(
        bytes32 number
    ) public view returns (bytes1[] memory) {
        bytes1[] memory bytes1s = new bytes1[](32);

        for (uint i = 0; i < 32; i++) {
            if (i == 1) {
                revert("11");
            }
        }

        return bytes1s;
    }
}
