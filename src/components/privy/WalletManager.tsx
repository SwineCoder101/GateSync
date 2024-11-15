"use client";
import React, { useEffect, useState } from "react";
import { usePrivy, useLinkAccount, useSolanaWallets } from "@privy-io/react-auth";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { toast } from "sonner";
import { checkEpikBalance } from "../utils";
import { Header } from "./Header";
import { LoginCard } from "./LoginCard";
import { LoadingState, AddWalletCard, WalletList } from "./WalletComponents";

export function WalletManager() {
  // To fetch the registred users
  // useEffect(() => {
  //   fetch("/api/privy/users")
  //     .then((res) => res.json())
  //     .then((res) => {
  //       console.log("users", res);
  //     });

  //   return () => {};
  // }, []);
  const [isLinking, setIsLinking] = useState(false);
  const [isChecking, setIsChecking] = useState(false);
  const [error, setError] = useState<string>();
  const [isConnecting, setIsConnecting] = useState(false);
  const { ready, authenticated, login, logout, exportWallet, unlinkWallet, connectWallet, user } = usePrivy();
  const { wallets } = useSolanaWallets();
  const { linkWallet } = useLinkAccount();

  useEffect(() => {
    async function checkWallet() {
      if (isConnecting && wallets.length > 0) {
        setIsConnecting(false);

        try {
          const balance = await checkEpikBalance(wallets[0].address);
          // if (balance < 1) {
          //   setError("You need at least 1 $EPIK token to get access");
          //   return;
          // }

          await login();
        } catch (error) {
          console.error("Failed to verify wallet:", error);
          setError("Failed to verify wallet. Please try again.");
        } finally {
          setIsChecking(false);
        }
      }
    }

    if (wallets.length > 0) {
      checkWallet();
    }
  }, [wallets, isConnecting, login]);

  async function handleInitialWalletConnect() {
    try {
      setIsChecking(true);
      setError(undefined);
      setIsConnecting(true);
      await connectWallet();
    } catch (error) {
      console.error("Connection failed:", error);
      setError("Failed to connect wallet. Please try again.");
      setIsConnecting(false);
      setIsChecking(false);
    }
  }

  function handleLogout() {
    try {
      return logout();
    } catch (error) {
      console.error("Logout failed:", error);
      return Promise.reject(error);
    }
  }

  async function handleLinkWallet() {
    try {
      setIsLinking(true);
      await linkWallet();
    } catch (error) {
      console.error("Failed to link wallet:", error);
    } finally {
      setIsLinking(false);
    }
  }

  function handleUnlinkWallet(address: string) {
    try {
      return unlinkWallet(address);
    } catch (error) {
      console.error("Failed to unlink wallet:", error);
      return Promise.reject(error);
    }
  }

  function handleExportWallet(address: string) {
    try {
      return exportWallet({ address });
    } catch (error) {
      console.error("Failed to export wallet:", error);
      return Promise.reject(error);
    }
  }

  function handleCopyAddress(address: string) {
    navigator.clipboard.writeText(address);
    toast.success("Address copied", {
      description: `${address}`,
      duration: 3000,
    });
  }

  if (!ready) {
    return <LoadingState />;
  }

  if (!authenticated) {
    return <LoginCard onInitialConnect={handleInitialWalletConnect} isChecking={isChecking} error={error} />;
  }

  const allWallets = user?.linkedAccounts.filter((acc) => acc.type === "wallet") ?? [];

  return (
    <div className="w-full max-w-4xl mx-auto space-y-6">
      <Header onLogout={handleLogout} />
      <AddWalletCard isLinking={isLinking} onLinkWallet={handleLinkWallet} />
      <Card className="backdrop-blur-sm bg-white/50 shadow-lg border-opacity-50">
        <CardHeader>
          <CardTitle className="text-xl">Connected Wallets</CardTitle>
          <CardDescription>Manage your connected Solana wallets</CardDescription>
        </CardHeader>
        <CardContent>
          <WalletList
            wallets={allWallets}
            onExport={handleExportWallet}
            onUnlink={handleUnlinkWallet}
            onCopy={handleCopyAddress}
          />
        </CardContent>
      </Card>
    </div>
  );
}
