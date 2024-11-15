pragma solidity ^0.8.13;

contract WalletRegistry {
    mapping(bytes32 => address) private solanaToEthereum;

    mapping(bytes32 => address) private solanaOwners;

    event AddressRegistered(bytes32 indexed solanaAddress, address indexed ethereumAddress);

    function registerAddress(bytes32 solanaAddress, address ethereumAddress) public {
        if (solanaOwners[solanaAddress] != address(0)) {
            require(solanaOwners[solanaAddress] == msg.sender, "Only the owner can update the address");
        } else {
            solanaOwners[solanaAddress] = msg.sender;
        }

        solanaToEthereum[solanaAddress] = ethereumAddress;

        emit AddressRegistered(solanaAddress, ethereumAddress);
    }

    function getEthereumAddress(bytes32 solanaAddress) public view returns (address) {
        return solanaToEthereum[solanaAddress];
    }
}