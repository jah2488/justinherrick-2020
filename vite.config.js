import { defineConfig } from 'vite'
import { plugin as elm } from 'vite-plugin-elm'

export default defineConfig({
  plugins: [
    elm({
      debug: false,
      optimize: true
    })
  ],
  server: {
    port: 5173,
    open: true
  },
  build: {
    outDir: 'dist'
  }
})