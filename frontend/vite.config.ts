import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    // Bind to all interfaces inside the container so the host can connect
    host: true, // equivalent to 0.0.0.0
    port: 5173,
    strictPort: true,
    // Ensure HMR uses the host-accessible port
    hmr: {
      clientPort: 5173,
    },
  },
})
