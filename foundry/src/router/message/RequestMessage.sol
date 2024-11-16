// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library RequestMessage {

    function format(
        bytes memory instruction,
        address evmAddress,
        bytes32 solanaAddress
    ) internal pure returns (bytes memory) {
        return abi.encode(instruction, evmAddress, solanaAddress);
    }

    function returnAll(bytes memory message) internal pure returns (bytes memory, address, bytes32) {
        require(message.length >= 0, "Message too short, failed to parse");

        (bytes memory instruction,address evmAddress,bytes32 solanaAddress) = abi.decode(message, (bytes, address, bytes32));
        return (instruction, evmAddress, solanaAddress);
    }
}
