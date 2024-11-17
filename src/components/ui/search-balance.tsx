// src/components/SearchBalance.tsx

import React, { useState } from 'react';

// Assuming you have a Card component. If not, you can replace it with a div or any other container.
import { Card } from './card';

const SearchBalance: React.FC = () => {
  const [solanaAddress, setSolanaAddress] = useState<string>('');
  const [balance, setBalance] = useState<number | null>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  // Mock function to simulate fetching balance
  const fetchBalance = async (address: string) => {
    setLoading(true);
    setError(null);
    setBalance(null);

    try {
      // Simple validation for Solana address length (Solana addresses are 32 bytes)
      if (address.length !== 44) { // Base58 encoded Solana addresses are typically 43-44 characters
        throw new Error('Invalid Solana address format.');
      }

      // Simulate an API call delay
      await new Promise((resolve) => setTimeout(resolve, 1500));

      // Mocked balance value
      const mockedBalance = Math.floor(Math.random() * 10000); // Random balance between 0 and 9999

      setBalance(mockedBalance);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch balance.');
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = () => {
    if (!solanaAddress) {
      setError('Please enter a Solana address.');
      return;
    }

    fetchBalance(solanaAddress);
  };

  return (
    <Card className="p-6 max-w-md mx-auto mt-10">
      <h2 className="text-xl font-semibold mb-4">Search Solana Token Balance</h2>
      <div className="flex flex-col space-y-4">
        <input
          type="text"
          value={solanaAddress}
          onChange={(e) => setSolanaAddress(e.target.value)}
          placeholder="Enter Solana Address"
          className="p-2 border border-gray-300 rounded"
        />
        <button
          onClick={handleSearch}
          className="bg-blue-500 text-white p-2 rounded hover:bg-blue-600"
          disabled={loading}
        >
          {loading ? 'Searching...' : 'Search'}
        </button>
        {error && <p className="text-red-500">{error}</p>}
        {balance !== null && (
          <p className="text-green-500">Balance: {balance} SOL</p>
        )}
      </div>
    </Card>
  );
};

export default SearchBalance;
