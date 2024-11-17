// src/sdk/EVMOriginInstructionSenderSDK.ts

import { ethers, Contract, providers, Signer } from 'ethers';

// Import ABI of the EVMOriginInstructionSender contract

const EVMOriginInstructionSenderABI="";

// Define types for events
type SendMessageEvent = {
  instruction: string;
  evmAddress: string;
  solanaAddress: string;
};

type ReceivedMessageEvent = {
  balance: number;
  origin: number;
};

// SDK Class
export class EVMOriginInstructionSenderSDK {
  private provider: providers.Web3Provider;
  private signer: Signer;
  private contract: Contract;

  /**
   * Initializes the SDK with the given provider and contract address.
   * @param provider - An ethers.js provider instance.
   * @param contractAddress - The deployed contract address.
   */
  constructor(provider: providers.Web3Provider, contractAddress: string) {
    this.provider = provider;
    this.signer = provider.getSigner();
    this.contract = new ethers.Contract(contractAddress, EVMOriginInstructionSenderABI, this.signer);
  }

  /**
   * Links an EVM address with a Solana address.
   * @param instruction - The instruction bytes.
   * @param evmAddress - The EVM (Ethereum) address.
   * @param solanaAddress - The Solana address in bytes32 format.
   */
  public async linkWallet(
    instruction: string,
    evmAddress: string,
    solanaAddress: string
  ): Promise<ethers.ContractTransaction> {
    const tx = await this.contract.sendMessage(
      ethers.utils.formatBytes32String(instruction),
      evmAddress,
      solanaAddress
    );
    return tx;
  }

  /**
   * Retrieves the token balance for a given token and wallet address.
   * @param token - The token identifier in bytes32 format.
   * @param walletAddress - The EVM (Ethereum) wallet address.
   * @param getAssociatedTokenAddressInstruction - The instruction to get the associated token address.
   * @returns The token balance as a number.
   */
  public async getTokenBalance(
    token: string,
    walletAddress: string,
    getAssociatedTokenAddressInstruction: string
  ): Promise<number> {
    const balance: ethers.BigNumber = await this.contract.getTokenBalance(
      ethers.utils.formatBytes32String(token),
      walletAddress,
      ethers.utils.toUtf8Bytes(getAssociatedTokenAddressInstruction)
    );
    return balance.toNumber();
  }

  /**
   * Sends a custom message to the destination chain.
   * @param instruction - The instruction bytes.
   * @param evmAddress - The EVM (Ethereum) address.
   * @param solanaAddress - The Solana address in bytes32 format.
   */
  public async sendCustomMessage(
    instruction: string,
    evmAddress: string,
    solanaAddress: string
  ): Promise<ethers.ContractTransaction> {
    const tx = await this.contract.sendMessage(
      ethers.utils.formatBytes32String(instruction),
      evmAddress,
      solanaAddress
    );
    return tx;
  }

  /**
   * Listens for SendMessage events emitted by the contract.
   * @param callback - A callback function to handle the event data.
   */
  public listenSendMessage(callback: (event: SendMessageEvent) => void): void {
    this.contract.on('SendMessage', (instruction: string, evmAddress: string, solanaAddress: string) => {
      callback({ instruction, evmAddress, solanaAddress });
    });
  }

  /**
   * Listens for ReceivedMessage events emitted by the contract.
   * @param callback - A callback function to handle the event data.
   */
  public listenReceivedMessage(callback: (event: ReceivedMessageEvent) => void): void {
    this.contract.on('ReceivedMessage', (balance: ethers.BigNumber, origin: number) => {
      callback({ balance: balance.toNumber(), origin });
    });
  }

  /**
   * Disconnects all listeners.
   */
  public disconnectListeners(): void {
    this.contract.removeAllListeners('SendMessage');
    this.contract.removeAllListeners('ReceivedMessage');
  }
}
