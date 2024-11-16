import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        dark: {
          DEFAULT: '#1a202c', // You can customize this color as needed
        },
      },
      backgroundColor: theme => ({
        ...theme.colors,
        'dark': '#1a202c', // Ensure this matches the color defined above
      }),
    },
  },
  plugins: [require('daisyui')],
};

export default config;