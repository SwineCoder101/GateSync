import { WalletManager } from "@/components/privy/WalletManager";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-50 to-gray-100">
      <header className="fixed top-0 w-full border-b bg-white/80 backdrop-blur-sm z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <span className="text-xl font-semibold"> Gate Sync </span>
        </div>
      </header>

      <main className="pt-24 pb-16 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="relative">
            <div className="relative">
              <WalletManager />
            </div>
          </div>
        </div>
      </main>

      <footer className="fixed bottom-0 w-full border-t bg-white/80 backdrop-blur-sm"></footer>
    </div>
  );
}
