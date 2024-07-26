pragma solidity ^0.8.7;

contract Test1 {
    function countActiveAgent(bytes32[] memory agentStatus) public view returns (uint256, uint256) {
        uint256 totalSize = 9;

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < agentStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                if (index >= totalSize) {
                    break;
                }

                bytes1 status = agentStatus[i][j];

                if (status == 0x11) {
                    activeIndex++;
                }

                index++;
            }
        }

        return (activeIndex, totalSize);
    }

    function _getRandom(uint256 _start, uint256 _end, uint256 _rand) public view returns (uint256) {
        if (_start == _end) {
            return _start;
        }
        uint256 _length = _end - _start;
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _rand)));
        random = (random % _length) + _start;
        return random;
    }
}
