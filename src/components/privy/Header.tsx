import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { LogOut } from "lucide-react";

export interface HeaderProps {
  onLogout: () => Promise<void>;
}

export function Header({ onLogout }: HeaderProps) {
  return (
    <Card className="bg-gradient-to-r from-blue-500 to-blue-600 text-white border-none shadow-xl">
      <CardContent className="flex justify-between items-center pt-6">
        <div>
          <h2 className="text-xl font-semibold">Welcome</h2>
          <p className="text-blue-100 mt-1">Manage your connected wallets</p>
        </div>
        <div className="flex space-x-2">
          <Button
            variant="secondary"
            onClick={onLogout}
            className="bg-white/10 hover:bg-white/20 text-white border-white/20"
          >
            <LogOut className="h-4 w-4 mr-2" />
            Sign Out
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
