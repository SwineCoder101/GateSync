import { WalletManager } from "@/components/privy/WalletManager";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-black to-gray-900 text-white">
      <header className="fixed top-0 w-full border-b bg-gray-900/80 backdrop-blur-sm z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <div className="flex items-center">
            <svg
              className="h-8 w-8 mr-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M12 2l2 7h7l-5.5 4 2 7-5.5-4-5.5 4 2-7L3 9h7z"
              />
            </svg>
            <span className="text-xl font-bold">Gate Sync</span>
          </div>
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

      <footer className="fixed bottom-0 w-full border-t bg-gray-900/80 backdrop-blur-sm"></footer>
    </div>
  );
}