// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Importing necessary contracts and interfaces
import {GasRouter} from "@hyperlane-xyz/core/contracts/client/GasRouter.sol";
import {RequestMessage} from "./message/RequestMessage.sol";
import {ResponseMessage} from "./message/ResponseMessage.sol";
import {ICallSolana} from "../interfaces/ICallSolana.sol";
import {IWalletRegistry} from "../interfaces/IWalletRegistry.sol";

/**
 * @title NeonEVMInstructionExecutor
 * @dev Executes instructions received from Solana and interacts with Ethereum wallets.
 */
contract NeonEVMInstructionExecutor is GasRouter {
    using RequestMessage for bytes;
    using ResponseMessage for bytes;

    // Events
    event SendMessage(bytes indexed instruction);
    event ReceivedMessage(address indexed evmAddress, bytes32 indexed solanaAddress, uint256 balance);

    // State Variables
    ICallSolana private callSolana;
    IWalletRegistry private walletRegistry;
    uint256 public chainId;

    /**
     * @dev Constructor to initialize the contract.
     * @param _mailbox Address of the Hyperlane Mailbox contract.
     * @param _callSolana Address of the ICallSolana contract.
     * @param _walletRegistry Address of the IWalletRegistry contract.
     * @param _chainId Chain ID for cross-chain messaging.
     */
    constructor(
        address _mailbox,
        address _callSolana,
        address _walletRegistry,
        uint256 _chainId
    ) GasRouter(_mailbox) {
        require(_callSolana != address(0), "Invalid ICallSolana address");
        require(_walletRegistry != address(0), "Invalid IWalletRegistry address");
        callSolana = ICallSolana(_callSolana);
        walletRegistry = IWalletRegistry(_walletRegistry);
        chainId = _chainId;
    }

    /**
     * @dev Sends a formatted message to the specified chain.
     * @param _message The message to be sent.
     */
    function sendMessage(bytes memory _message) internal {
        emit SendMessage(_message);
        // Adjust the gas limit and destination address as per your requirements
        _dispatch(chainId, 1000000, _message, address(0));
    }

    /**
     * @dev Handles incoming messages from other chains.
     * @param _origin The origin chain ID.
     * @param _sender The sender address on the origin chain.
     * @param _message The message payload.
     */
    function _handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _message
    ) internal virtual override {
        // Parse the incoming message to extract Ethereum and Solana addresses along with instructions
        (
            address evmAddress,
            bytes32 solanaAddress,
            bytes memory instructionBytes
        ) = _message.parse();

        // Update the wallet linkage in WalletRegistry
        walletRegistry.registerAddress(solanaAddress, evmAddress);

        // Retrieve the token balance from Solana
        uint256 balance = getTokenAccountBalance(instructionBytes);

        // Format the response message
        bytes memory responseMessageBytes = ResponseMessage.format(balance);

        // Emit the ReceivedMessage event
        emit ReceivedMessage(evmAddress, solanaAddress, balance);

        // Send the response back
        sendMessage(responseMessageBytes);
    }

    /**
     * @dev Retrieves the token account balance from Solana.
     * @param instruction The instruction bytes to execute on Solana.
     * @return The token balance as a uint256.
     */
    function getTokenAccountBalance(bytes memory instruction) public returns (uint256) {
        // Execute the instruction on Solana with a specified gas limit
        bytes memory callData = callSolana.execute(100000, instruction);

        // Decode the response to get the token balance
        uint256 tokenBalance = abi.decode(callData, (uint256));

        return tokenBalance;
    }

    /**
     * @dev Overrides the default _dispatch function to include custom logic if needed.
     * @param _destination The destination chain ID.
     * @param _gasLimit The gas limit for the message.
     * @param _message The message payload.
     * @param _refundAddress The address to refund unused gas.
     */
    function _dispatch(
        uint256 _destination,
        uint256 _gasLimit,
        bytes memory _message,
        address _refundAddress
    ) internal override {
        super._dispatch(_destination, _gasLimit, _message, _refundAddress);
    }
}
