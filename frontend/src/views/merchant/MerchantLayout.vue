<template>
  <div class="merchant-layout">
    <div class="merchant-header">
      <h1>商家管理后台</h1>
      <div class="user-info">
        <span>{{ username }}</span>
        <button @click="logout" class="logout-btn">退出登录</button>
      </div>
    </div>

    <div class="merchant-content">
      <div class="sidebar">
        <div 
          v-for="item in menuItems" 
          :key="item.name"
          :class="['menu-item', { active: activeMenu === item.name }]"
          @click="activeMenu = item.name"
        >
          <i class="icon">{{ item.icon }}</i>
          <span>{{ item.label }}</span>
        </div>
      </div>

      <div class="main-content">
        <component :is="currentComponent" />
      </div>
    </div>
  </div>
</template>

<script>
import ShopManagement from './components/ShopManagement.vue'
import EvaluationManagement from './components/EvaluationManagement.vue'

export default {
  name: 'MerchantLayout',
  components: {
    ShopManagement,
    EvaluationManagement
  },
  data() {
    return {
      activeMenu: 'shops',
      username: '',
      menuItems: [
        { name: 'shops', label: '店铺管理', icon: '🏪' },
        { name: 'evaluations', label: '评价管理', icon: '⭐' }
      ]
    }
  },
  computed: {
    currentComponent() {
      const componentMap = {
        shops: 'ShopManagement',
        evaluations: 'EvaluationManagement'
      }
      return componentMap[this.activeMenu]
    }
  },
  mounted() {
    this.checkAuth()
  },
  methods: {
    checkAuth() {
      const user = JSON.parse(localStorage.getItem('user') || '{}')
      if (!user.userRole || user.userRole.id !== 2) {
        this.$router.push('/login')
      } else {
        this.username = user.username
      }
    },
    logout() {
      localStorage.removeItem('user')
      localStorage.removeItem('isLoggedIn')
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.merchant-layout {
  min-height: 100vh;
  background: #f5f5f5;
}

.merchant-header {
  background: white;
  padding: 20px 40px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.merchant-header h1 {
  margin: 0;
  color: #8B4513;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 15px;
}

.logout-btn {
  padding: 8px 20px;
  background: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.merchant-content {
  display: flex;
  height: calc(100vh - 80px);
}

.sidebar {
  width: 200px;
  background: white;
  padding: 20px 0;
  box-shadow: 2px 0 4px rgba(0,0,0,0.1);
}

.menu-item {
  padding: 15px 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s;
}

.menu-item:hover {
  background: #f8f9fa;
}

.menu-item.active {
  background: #8B4513;
  color: white;
}

.main-content {
  flex: 1;
  padding: 30px;
  overflow-y: auto;
}
</style>
