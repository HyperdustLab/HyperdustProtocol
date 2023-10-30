pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_HYDT_Price is FunctionsClient, ConfirmedOwner {
    using FunctionsRequest for FunctionsRequest.Request;

    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;

    uint256 public _HYDT_Price = 100000000000000000;

    address public _router;

    address public _rolesCfgAddress;

    string public _source;

    uint64 public _subscriptionId;

    uint32 public _gasLimit;

    bytes32 public _jobId;

    error UnexpectedRequestID(bytes32 requestId);

    event Response(bytes32 requestId, bytes response, bytes err);

    constructor(
        address router
    ) FunctionsClient(router) ConfirmedOwner(msg.sender) {
        _router = router;
    }

    function setSource(string memory source) public onlyOwner {
        _source = source;
    }

    function setSubscriptionId(uint64 subscriptionId) public onlyOwner {
        _subscriptionId = subscriptionId;
    }

    function setGasLimit(uint32 gstLimie) public onlyOwner {
        _gasLimit = gstLimie;
    }

    function setJobId(bytes32 jobId) public onlyOwner {
        _jobId = jobId;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function getHYDTPrice() public view returns (uint256) {
        return _HYDT_Price;
    }

    function sendRequest(
        string[] memory args,
        bytes[] memory bytesArgs
    ) external returns (bytes32 requestId) {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(_source);
        if (args.length > 0) req.setArgs(args);
        if (bytesArgs.length > 0) req.setBytesArgs(bytesArgs);
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            _subscriptionId,
            _gasLimit,
            _jobId
        );
        return s_lastRequestId;
    }

    /**
     * @notice Store latest result/error
     * @param requestId The request ID, returned by sendRequest()
     * @param response Aggregated response from the user code
     * @param err Aggregated error from the user code or from the execution pipeline
     * Either response or error parameter will be set, but never both
     */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        // require(_router == msg.sender, "Only callable by router");

        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId);
        }
        s_lastResponse = response;
        s_lastError = err;

        //_HYDT_Price = bytesToUint256(s_lastResponse);
        emit Response(requestId, s_lastResponse, s_lastError);
    }

    function bytesToUint256(bytes memory data) public pure returns (uint256) {
        require(data.length >= 32, "Invalid data length");
        uint256 number = abi.decode(data, (uint256));
        return number;
    }
}
