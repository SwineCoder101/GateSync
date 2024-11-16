// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the Foundry Test library
import "forge-std/Test.sol";
// Import the WalletRegistry contract and its interface
import "../src/interfaces/IWalletRegistry.sol";
import "../src/WalletRegistry.sol";

/**
 * @title WalletRegistryTest
 * @dev A test suite for the WalletRegistry contract using Foundry's Forge framework.
 */
contract WalletRegistryTest is Test {
    // Instance of the WalletRegistry contract
    WalletRegistry private walletRegistry;

    // Signers representing different users
    address private owner;
    address private user1;
    address private user2;
    address private user3;

    // Sample Solana and Ethereum addresses
    bytes32 private solanaAddress1 = keccak256(abi.encodePacked("solanaAddress1"));
    address private ethereumAddress1 = address(0x123);
    bytes32 private solanaAddress2 = keccak256(abi.encodePacked("solanaAddress2"));
    address private ethereumAddress2 = address(0x456);
    bytes32 private solanaAddress3 = keccak256(abi.encodePacked("solanaAddress3"));
    address private ethereumAddress3 = address(0x789);

    /**
     * @dev Sets up the initial state before each test.
     *      Initializes signers and deploys the WalletRegistry contract.
     */
    function setUp() public {
        // Assign different addresses to represent different users
        owner = address(this); // The test contract itself acts as the owner
        user1 = address(0xABC);
        user2 = address(0xDEF);
        user3 = address(0xFED);

        // Deploy a new WalletRegistry contract instance
        walletRegistry = new WalletRegistry();
    }

    /**
     * @dev Tests the registration of a new Solana and Ethereum address pair.
     */
    function testRegisterAddress() public {
        // Register a new address pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Verify that the Ethereum address is correctly registered
        assertEq(walletRegistry.getEthereumAddress(solanaAddress1), ethereumAddress1, "Ethereum address mismatch");
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress1), solanaAddress1, "Solana address mismatch");

        // Verify ownership
        assertEq(walletRegistry.getOwner(solanaAddress1), owner, "Owner mismatch");

        // Verify that the event was emitted
        vm.expectEmit(true, true, false, true);
        // emit WalletRegistry(walletRegistry).AddressRegistered(solanaAddress1, ethereumAddress1);
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);
    }

    /**
     * @dev Tests updating the Ethereum address linked to a Solana address by the owner.
     */
    function testUpdateAddressByOwner() public {
        // Register initial address pair
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Update the Ethereum address to a new address by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress2);

        // Verify that the Ethereum address is correctly updated
        assertEq(walletRegistry.getEthereumAddress(solanaAddress1), ethereumAddress2, "Ethereum address not updated");
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress2), solanaAddress1, "Solana address not linked to new Ethereum address");

        // Verify that the old Ethereum address is unlinked
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress1), bytes32(0), "Old Ethereum address should be unlinked");

        // Verify that the event was emitted
        vm.expectEmit(true, true, false, true);
        // emit WalletRegistry(walletRegistry).AddressRegistered(solanaAddress1, ethereumAddress2);
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress2);
    }

    /**
     * @dev Tests that only the owner can update the Ethereum address linked to a Solana address.
     */
    function testOnlyOwnerCanUpdateAddress() public {
        // Register initial address pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Attempt to update the Ethereum address from a different account (user1)
        vm.startPrank(user1);
        vm.expectRevert("Only the owner can update the address");
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress2);
        vm.stopPrank();
    }

    /**
     * @dev Tests that an Ethereum address cannot be linked to multiple Solana addresses.
     */
    function testEthereumAddressUniqueness() public {
        // Register first Solana-Ethereum pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Attempt to register a second Solana address with the same Ethereum address by user1
        vm.startPrank(user1);
        vm.expectRevert("Ethereum address is already linked to a different Solana address");
        walletRegistry.registerAddress(solanaAddress2, ethereumAddress1);
        vm.stopPrank();
    }

    /**
     * @dev Tests that a Solana address cannot be linked to multiple Ethereum addresses.
     */
    function testSolanaAddressUniqueness() public {
        // Register initial Solana-Ethereum pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Update the Solana address with a different Ethereum address by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress2);

        // Verify that the Ethereum address is updated and uniqueness is maintained
        assertEq(walletRegistry.getEthereumAddress(solanaAddress1), ethereumAddress2, "Ethereum address not updated correctly");
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress1), bytes32(0), "Old Ethereum address should be unlinked");
    }

    /**
     * @dev Tests the unlinking of a Solana and Ethereum address pair by the owner.
     */
    function testUnlinkAddressByOwner() public {
        // Register a new address pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Unlink the address pair by the owner
        walletRegistry.unlinkAddress(solanaAddress1);

        // Verify that both addresses are unlinked
        assertEq(walletRegistry.getEthereumAddress(solanaAddress1), address(0), "Ethereum address should be unlinked");
        assertEq(walletRegistry.getSolanaAddress(ethereumAddress1), bytes32(0), "Solana address should be unlinked");

        // Verify that the event was emitted
        vm.expectEmit(true, true, false, true);
        // emit WalletRegistry(walletRegistry).AddressUnlinked(solanaAddress1, ethereumAddress1);
        walletRegistry.unlinkAddress(solanaAddress1);
    }

    /**
     * @dev Tests that only the owner can unlink a Solana and Ethereum address pair.
     */
    function testOnlyOwnerCanUnlinkAddress() public {
        // Register a new address pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Attempt to unlink the address pair from a different account (user1)
        vm.startPrank(user1);
        vm.expectRevert("Caller is not the owner of this Solana address");
        walletRegistry.unlinkAddress(solanaAddress1);
        vm.stopPrank();
    }

    /**
     * @dev Tests retrieving the Ethereum address linked to a Solana address.
     */
    function testGetEthereumAddress() public {
        // Register a new address pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Retrieve the Ethereum address linked to the Solana address
        address retrievedEthereum = walletRegistry.getEthereumAddress(solanaAddress1);
        assertEq(retrievedEthereum, ethereumAddress1, "Retrieved Ethereum address does not match");
    }

    /**
     * @dev Tests retrieving the Solana address linked to an Ethereum address.
     */
    function testGetSolanaAddress() public {
        // Register a new address pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Retrieve the Solana address linked to the Ethereum address
        bytes32 retrievedSolana = walletRegistry.getSolanaAddress(ethereumAddress1);
        assertEq(retrievedSolana, solanaAddress1, "Retrieved Solana address does not match");
    }

    /**
     * @dev Tests that a non-registered Solana address returns zero address when querying Ethereum address.
     */
    function testGetEthereumAddressForNonRegisteredSolana() public {
        address retrievedEthereum = walletRegistry.getEthereumAddress(solanaAddress2);
        assertEq(retrievedEthereum, address(0), "Non-registered Solana address should return zero Ethereum address");
    }

    /**
     * @dev Tests that a non-registered Ethereum address returns zero bytes32 when querying Solana address.
     */
    function testGetSolanaAddressForNonRegisteredEthereum() public {
        bytes32 retrievedSolana = walletRegistry.getSolanaAddress(ethereumAddress2);
        assertEq(retrievedSolana, bytes32(0), "Non-registered Ethereum address should return zero Solana address");
    }

    /**
     * @dev Tests that registering an address with zero Ethereum address reverts.
     */
    function testRegisterAddressWithZeroEthereumAddress() public {
        bytes32 invalidSolana = keccak256(abi.encodePacked("invalidSolana"));
        address zeroAddress = address(0);

        vm.expectRevert("Invalid Ethereum address");
        walletRegistry.registerAddress(invalidSolana, zeroAddress);
    }

    /**
     * @dev Tests that registering an address with zero Solana address reverts.
     */
    function testRegisterAddressWithZeroSolanaAddress() public {
        bytes32 zeroSolana = bytes32(0);
        address validEthereum = address(0x123);

        vm.expectRevert("Invalid Solana address");
        walletRegistry.registerAddress(zeroSolana, validEthereum);
    }

    /**
     * @dev Tests that unlinking a non-linked Solana address reverts.
     */
    function testUnlinkNonLinkedAddress() public {
        vm.expectRevert("Solana address is not linked");
        walletRegistry.unlinkAddress(solanaAddress1);
    }

    /**
     * @dev Tests that attempting to register an Ethereum address already linked to another Solana address reverts.
     */
    function testRegisterEthereumAddressAlreadyLinked() public {
        // Register first Solana-Ethereum pair by the owner
        walletRegistry.registerAddress(solanaAddress1, ethereumAddress1);

        // Attempt to link the same Ethereum address to a different Solana address by the owner
        vm.expectRevert("Ethereum address is already linked to a different Solana address");
        walletRegistry.registerAddress(solanaAddress2, ethereumAddress1);
    }
}
