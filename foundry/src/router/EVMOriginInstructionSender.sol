// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {GasRouter} from "@hyperlane-xyz/core/contracts/client/GasRouter.sol";
import {RequestMessage} from "./message/RequestMessage.sol";
import {ResponseMessage} from "./message/ResponseMessage.sol";
import {ICallSolana} from "../interfaces/ICallSolana.sol";
import {IWalletRegistry} from "../interfaces/IWalletRegistry.sol";

/**
 * @title EVMOriginInstructionSender
 * @dev Facilitates cross-chain interactions between EVM and Solana using Hyperlane's GasRouter.
 */
contract EVMOriginInstructionSender is GasRouter {

    using RequestMessage for bytes;
    using ResponseMessage for bytes;
    
    // State Variables
    uint256 public balance; // Consider renaming or removing if unused
    ICallSolana private callSolana;
    IWalletRegistry private walletRegistry;

    /**
     * @dev Emitted when a message is sent.
     * @param instruction The instruction data sent.
     * @param evmAddress The associated EVM address.
     * @param solanaAddress The associated Solana address.
     */
    event SendMessage(bytes instruction, address evmAddress, bytes32 solanaAddress);

    /**
     * @dev Emitted when a message is received.
     * @param balance The token balance retrieved.
     * @param origin The origin chain ID.
     */
    event ReceivedMessage(uint64 balance, uint32 origin);

    /**
     * @dev Constructor to initialize the contract.
     * @param _mailbox Address of the Hyperlane Mailbox contract.
     * @param _callSolana Address of the ICallSolana contract.
     * @param _walletRegistry Address of the IWalletRegistry contract.
     */
    constructor(address _mailbox, address _callSolana, address _walletRegistry) GasRouter(_mailbox) {
        require(_callSolana != address(0), "Invalid ICallSolana address");
        require(_walletRegistry != address(0), "Invalid IWalletRegistry address");
        callSolana = ICallSolana(_callSolana);
        walletRegistry = IWalletRegistry(_walletRegistry);
    }

    /**
     * @dev Retrieves the token balance of an associated token address on Solana.
     * @param token The token identifier.
     * @param walletAddress The wallet address on EVM.
     * @param get_associated_token_address The instruction to get the associated token address.
     * @return The token balance as a uint256.
     */
    function getTokenBalance(
        bytes32 token,
        address walletAddress,
        bytes memory get_associated_token_address
    ) public returns (uint256) {
        // Retrieve the associated token address from Solana
        bytes memory pubkey = callSolana.execute(gasleft(), get_associated_token_address);
        // Ensure pubkey is valid or handle accordingly

        // Prepare instruction to get the token balance
        bytes memory get_token_balance_instruction = abi.encodePacked("GetBalance", token, walletAddress);
        // Retrieve the token balance from Solana
        bytes memory tokenBalanceData = callSolana.execute(100000, get_token_balance_instruction);

        return abi.decode(tokenBalanceData, (uint256));
    }

    /**
     * @dev Sends a formatted message to the destination chain.
     * @param instruction The instruction data to send.
     * @param evmAddress The associated EVM address.
     * @param solanaAddress The associated Solana address.
     */
    function sendMessage(
        bytes memory instruction,
        address evmAddress,
        bytes32 solanaAddress
    ) external {
        require(evmAddress != address(0), "Invalid EVM address");
        require(solanaAddress != bytes32(0), "Invalid Solana address");

        // Format the message using the RequestMessage library
        bytes memory _message = instruction.format(evmAddress, solanaAddress);

        // Emit the SendMessage event
        emit SendMessage(instruction, evmAddress, solanaAddress);

        // Dispatch the message via GasRouter
        _dispatchMessage(_message);

        // Update the wallet registry
        walletRegistry.registerAddress(solanaAddress, evmAddress);
    }

    /**
     * @dev Internal function to dispatch messages with appropriate gas and destination.
     * @param _message The message payload to send.
     */
    function _dispatchMessage(bytes memory _message) internal {
        uint256 destinationChainId = 421614; // Consider making this a state variable or constructor parameter
        uint256 gasLimit = 1000000; // Adjust based on message complexity

        emit SendMessage(_message, address(this), bytes32(0)); // Adjust event parameters if needed

        _dispatch(destinationChainId, gasLimit, _message, address(0));
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
        // Parse the incoming message using the ResponseMessage library
        uint64 retrievedBalance = _message.returnAll();

        // Emit the ReceivedMessage event
        emit ReceivedMessage(retrievedBalance, _origin);

        // Additional logic can be added here, such as updating state or responding
    }
}
