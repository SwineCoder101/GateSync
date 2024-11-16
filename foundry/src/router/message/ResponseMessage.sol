// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ResponseMessage {
    function format(
        uint64 balance
    ) internal pure returns (bytes memory) {
        return abi.encode(balance);
    }

    function returnAll(bytes memory message) internal pure returns (uint64) {
        require(message.length >= 1, "Message too short");
        (uint64 balance) = abi.decode(message, (uint64));
        return (balance);
    }
}
