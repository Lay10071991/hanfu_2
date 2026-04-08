import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import ElementPlus from 'unplugin-element-plus/vite'

export default defineConfig({
  plugins: [
    vue(),
    ElementPlus(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8082',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      },
      '/uploads': {
        target: 'http://localhost:8082',
        changeOrigin: true
      },
      '/pattern-symbols': {
        target: 'http://localhost:8082',
        changeOrigin: true
      },
      '/etiquette-posture': {
        target: 'http://localhost:8082',
        changeOrigin: true
      },
      '/shop': {
        target: 'http://localhost:8082',
        changeOrigin: true
      },
      '/shopshow': {
        target: 'http://localhost:8082',
        changeOrigin: true
      },
      '/community_post': {
        target: 'http://localhost:8082',
        changeOrigin: true
      }
    }
  }
})
