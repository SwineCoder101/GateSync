import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Loader2 } from "lucide-react";

interface LoginCardProps {
  onInitialConnect: () => Promise<void>;
  isChecking: boolean;
  error?: string;
}

export function LoginCard({ onInitialConnect, isChecking, error }: LoginCardProps) {
  return (
    <div className="w-full max-w-md mx-auto">
      <Card className="backdrop-blur-sm bg-white/50 shadow-xl border-opacity-50">
        <CardHeader className="space-y-1">
          <CardTitle className="text-2xl font-bold">Welcome to EPIK Wallet</CardTitle>
          <CardDescription className="text-base">Connect your wallet to continue</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {error && (
            <Alert variant="destructive">
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}
          <Button
            className="w-full bg-blue-500 hover:bg-blue-600 text-white"
            size="lg"
            onClick={onInitialConnect}
            disabled={isChecking}
          >
            {isChecking ? (
              <>
                <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                Connecting Wallet...
              </>
            ) : (
              "Connect Wallet"
            )}
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
