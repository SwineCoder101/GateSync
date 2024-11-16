// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title IWalletRegistry
 * @dev Interface for the WalletRegistry contract.
 */
interface IWalletRegistry {
    /**
     * @dev Emitted when a new address is registered.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     * @param ethereumAddress The Ethereum wallet address.
     */
    event AddressRegistered(bytes32 indexed solanaAddress, address indexed ethereumAddress);

    /**
     * @dev Emitted when an address linkage is removed.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     * @param ethereumAddress The Ethereum wallet address.
     */
    event AddressUnlinked(bytes32 indexed solanaAddress, address indexed ethereumAddress);

    /**
     * @dev Registers or updates the linkage between a Solana address and an Ethereum address.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     * @param ethereumAddress The Ethereum wallet address.
     */
    function registerAddress(bytes32 solanaAddress, address ethereumAddress) external;

    /**
     * @dev Unlinks the Solana and Ethereum addresses.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     */
    function unlinkAddress(bytes32 solanaAddress) external;

    /**
     * @dev Retrieves the Ethereum address linked to a given Solana address.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     * @return The linked Ethereum wallet address.
     */
    function getEthereumAddress(bytes32 solanaAddress) external view returns (address);

    /**
     * @dev Retrieves the Solana address linked to a given Ethereum address.
     * @param ethereumAddress The Ethereum wallet address.
     * @return The linked Solana wallet address in bytes32 format.
     */
    function getSolanaAddress(address ethereumAddress) external view returns (bytes32);
}
