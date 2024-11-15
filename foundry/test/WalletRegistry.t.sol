// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/WalletRegistry.sol";

contract WalletRegistryTest is Test {
    WalletRegistry private walletRegistry;

    // Sample Solana and Ethereum addresses
    bytes32 private solanaAddress1 = keccak256(abi.encodePacked("solanaAddress1"));
    address private ethereumAddress1 = address(0x123);
    bytes32 private solanaAddress2 = keccak256(abi.encodePacked("solanaAddress2"));
    address private ethereumAddress2 = address(0x456);

    function setUp() public {
        walletRegistry = new WalletRegistry();
    }

    function testRegisterAddress() public {
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Verify that the Ethereum address is correctly registered
        assertEq(walletRegistry.getEthereumAddress(solanaAddress1), ethereumAddress1);
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress1), solanaAddress1);
    }

    function testUpdateAddress() public {
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Update the Ethereum address
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress2);

        // Verify that the Ethereum address is correctly updated
        assertEq(walletRegistry.getEthereumAddress(solanaAddress1), ethereumAddress2);
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress2), solanaAddress1);
    }

    function testOnlyOwnerCanUpdate() public {
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Try to update the address from a different account
        vm.prank(address(0x789));
        vm.expectRevert("Only the owner can update the address");
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress2);
    }

    function testGetEthereumAddress() public {
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Verify that the Ethereum address is correctly retrieved
        assertEq(walletRegistry.getEthereumAddress(solanaAddress1), ethereumAddress1);
    }

    function testGetSolanaAddress() public {
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Verify that the Solana address is correctly retrieved
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress1), solanaAddress1);
    }
}