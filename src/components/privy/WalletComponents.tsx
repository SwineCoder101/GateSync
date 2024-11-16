import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { Loader2, Plus, Wallet, Key, Unlink } from "lucide-react";
import { User, WalletWithMetadata } from "@privy-io/react-auth";
import { getChainIcon } from "@/utils/utils";

export interface WalletListProps {
  wallets: WalletWithMetadata[];
  onExport: (address: string) => Promise<void>;
  onUnlink: (address: string) => Promise<User>;
  onCopy: (address: string) => void;
}

export interface WalletActionsProps {
  wallet: WalletWithMetadata;
  onExport: (address: string) => Promise<void>;
  onUnlink: (address: string) => Promise<User>;
}

export interface AddWalletCardProps {
  isLinking: boolean;
  onLinkWallet: () => Promise<void>;
}

export function AddWalletCard({ isLinking, onLinkWallet }: AddWalletCardProps) {
  return (
    <Card className="backdrop-blur-sm bg-white/50 shadow-lg border-opacity-50">
      <CardHeader>
        <CardTitle className="text-xl">Add New Wallet</CardTitle>
        <CardDescription>Connect an additional wallet to your account</CardDescription>
      </CardHeader>
      <CardContent>
        <Button
          onClick={onLinkWallet}
          disabled={isLinking}
          size="lg"
          className="bg-blue-500 hover:bg-blue-600 text-white"
        >
          {isLinking ? (
            <>
              <Loader2 className="h-4 w-4 mr-2 animate-spin" />
              Linking Wallet...
            </>
          ) : (
            <>
              <Plus className="h-4 w-4 mr-2" />
              Link New Wallet
            </>
          )}
        </Button>
      </CardContent>
    </Card>
  );
}

export function WalletAddress({ address, onCopy }: { address: string; onCopy: (address: string) => void }) {
  return (
    <TooltipProvider>
      <Tooltip>
        <TooltipTrigger asChild>
          <button
            onClick={() => onCopy(address)}
            className="font-medium text-gray-900 hover:text-blue-600 transition-colors cursor-pointer group flex items-center"
          >
            <span>
              {address.slice(0, 6)}...{address.slice(-4)}
            </span>
          </button>
        </TooltipTrigger>
        <TooltipContent>
          <p>Click to copy address</p>
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}

export function WalletActions({ wallet, onExport, onUnlink }: WalletActionsProps) {
  const isEmbedded = wallet.walletClientType === "privy";

  return (
    <div className="flex items-center space-x-2">
      {isEmbedded && (
        <Button
          variant="outline"
          size="sm"
          onClick={() => onExport(wallet.address)}
          className="text-yellow-600 hover:text-yellow-700 hover:bg-yellow-50"
        >
          <Key className="h-4 w-4 mr-2" />
          Export
        </Button>
      )}

      <AlertDialog>
        <AlertDialogTrigger asChild>
          <Button variant="outline" size="sm" className="text-red-600 hover:text-red-700 hover:bg-red-50">
            <Unlink className="h-4 w-4 mr-2" />
            Unlink
          </Button>
        </AlertDialogTrigger>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Unlink Wallet</AlertDialogTitle>
            <AlertDialogDescription>Are you sure you want to unlink this wallet?</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={() => onUnlink(wallet.address)} className="bg-red-600 hover:bg-red-700">
              Unlink Wallet
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

export function WalletList({ wallets, onCopy, onExport, onUnlink }: WalletListProps) {
  console.log("🚀 ~ WalletList ~ wallets:", wallets);
  if (wallets.length === 0) {
    return (
      <Alert className="bg-blue-50 border-blue-100">
        <AlertDescription className="text-blue-700">
          No wallets connected yet. Link your first wallet above.
        </AlertDescription>
      </Alert>
    );
  }

  return (
    <div className="space-y-4">
      {wallets.map((wallet) => (
        <div
          key={wallet.address}
          className="flex items-center justify-between p-4 rounded-xl border bg-white/50 backdrop-blur-sm hover:bg-white/80 transition-colors"
        >
          <div className="flex items-center space-x-4">
            <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
              <Wallet className="h-5 w-5 text-blue-500" />
            </div>
            <div>
              <WalletAddress address={wallet.address} onCopy={onCopy} />
              <div className="flex items-center space-x-2 mt-1">
                <p className="text-sm text-gray-500 capitalize">
                  {wallet.walletClientType === "privy" ? "Embedded Wallet" : wallet.walletClientType?.toLowerCase()}
                </p>
                <span className="text-gray-300">•</span>
                <div className="flex items-center space-x-1">
                  {getChainIcon(wallet.chainType)}
                  <span className="text-sm text-gray-500 capitalize">{wallet.chainType}</span>
                </div>
              </div>
            </div>
          </div>
          <WalletActions wallet={wallet} onExport={onExport} onUnlink={onUnlink} />
        </div>
      ))}
    </div>
  );
}

export function LoadingState() {
  return (
    <div className="w-full flex items-center justify-center">
      <div className="md:w-[450px] w-full h-[110px] flex items-center justify-center bg-white/50 backdrop-blur-sm rounded-2xl border shadow-lg">
        <Loader2 className="h-8 w-8 animate-spin text-blue-500" />
      </div>
    </div>
  );
}
