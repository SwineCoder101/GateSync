// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IWalletRegistry} from "./interfaces/IWalletRegistry.sol";

/**
 * @title WalletRegistry
 * @dev A contract to register and manage links between Solana and Ethereum wallet addresses.
 */
contract WalletRegistry is IWalletRegistry {
    // Mapping from Solana address (bytes32) to Ethereum address
    mapping(bytes32 => address) private solanaToEthereum;

    // Mapping from Ethereum address to Solana address (bytes32)
    mapping(address => bytes32) private ethereumToSolana;

    // Mapping from Solana address to the owner of the Ethereum address
    mapping(bytes32 => address) private solanaOwners;

    /**
     * @dev Modifier to check if the caller is the owner of the given Solana address.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     */
    modifier onlyOwner(bytes32 solanaAddress) {
        require(
            solanaOwners[solanaAddress] == msg.sender,
            "Caller is not the owner of this Solana address"
        );
        _;
    }

    /**
     * @dev Registers or updates the linkage between a Solana address and an Ethereum address.
     *      Only the owner of a Solana address can update its linked Ethereum address.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     * @param ethereumAddress The Ethereum wallet address.
     */
    function registerAddress(bytes32 solanaAddress, address ethereumAddress) external override {
        require(ethereumAddress != address(0), "Invalid Ethereum address");
        require(solanaAddress != bytes32(0), "Invalid Solana address");

        if (solanaOwners[solanaAddress] != address(0)) {
            // If Solana address is already registered, ensure the caller is the owner
            require(
                solanaOwners[solanaAddress] == msg.sender,
                "Only the owner can update the address"
            );
        } else {
            // If Solana address is new, assign ownership to the caller
            solanaOwners[solanaAddress] = msg.sender;
        }

        // Ensure the Ethereum address is not already linked to another Solana address
        require(
            ethereumToSolana[ethereumAddress] == bytes32(0) || ethereumToSolana[ethereumAddress] == solanaAddress,
            "Ethereum address is already linked to a different Solana address"
        );

        // If the Solana address was previously linked to a different Ethereum address, unlink it
        address previousEthAddress = solanaToEthereum[solanaAddress];
        if (previousEthAddress != address(0) && previousEthAddress != ethereumAddress) {
            ethereumToSolana[previousEthAddress] = bytes32(0);
            emit AddressUnlinked(solanaAddress, previousEthAddress);
        }

        // Link the Solana address to the new Ethereum address
        solanaToEthereum[solanaAddress] = ethereumAddress;
        ethereumToSolana[ethereumAddress] = solanaAddress;

        emit AddressRegistered(solanaAddress, ethereumAddress);
    }

    /**
     * @dev Unlinks the Solana and Ethereum addresses.
     *      Only the owner of the Solana address can unlink.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     */
    function unlinkAddress(bytes32 solanaAddress) external override onlyOwner(solanaAddress) {
        address ethereumAddress = solanaToEthereum[solanaAddress];
        require(ethereumAddress != address(0), "Solana address is not linked");

        // Remove the linkage
        solanaToEthereum[solanaAddress] = address(0);
        ethereumToSolana[ethereumAddress] = bytes32(0);

        emit AddressUnlinked(solanaAddress, ethereumAddress);
    }

    /**
     * @dev Retrieves the Ethereum address linked to a given Solana address.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     * @return The linked Ethereum wallet address.
     */
    function getEthereumAddress(bytes32 solanaAddress) external view override returns (address) {
        return solanaToEthereum[solanaAddress];
    }

    /**
     * @dev Retrieves the Solana address linked to a given Ethereum address.
     * @param ethereumAddress The Ethereum wallet address.
     * @return The linked Solana wallet address in bytes32 format.
     */
    function getSolanaAddress(address ethereumAddress) external view override returns (bytes32) {
        return ethereumToSolana[ethereumAddress];
    }

    /**
     * @dev Retrieves the owner of a given Solana address.
     * @param solanaAddress The Solana wallet address in bytes32 format.
     * @return The owner Ethereum address.
     */
    function getOwner(bytes32 solanaAddress) external view returns (address) {
        return solanaOwners[solanaAddress];
    }
}
