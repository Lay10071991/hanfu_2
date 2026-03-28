<template>
  <div class="merchant-dashboard">
    <div class="dashboard-header">
      <h1>商家管理后台</h1>
      <button @click="logout" class="logout-btn">退出登录</button>
    </div>

    <div class="dashboard-content">
      <div class="sidebar">
        <div 
          :class="['menu-item', { active: activeTab === 'shop' }]"
          @click="activeTab = 'shop'"
        >
          <i class="icon">🏪</i>
          <span>店铺管理</span>
        </div>
        <div 
          :class="['menu-item', { active: activeTab === 'evaluation' }]"
          @click="activeTab = 'evaluation'"
        >
          <i class="icon">⭐</i>
          <span>评价管理</span>
        </div>
      </div>

      <div class="main-content">
        <!-- 店铺管理 -->
        <div v-if="activeTab === 'shop'" class="tab-content">
          <div class="section-header">
            <h2>店铺信息</h2>
            <button @click="showShopForm = true" class="btn-primary">添加店铺</button>
          </div>
          
          <div v-if="shops.length === 0" class="empty-state">
            <p>暂无店铺信息</p>
          </div>
          
          <div v-else class="shop-list">
            <div v-for="shop in shops" :key="shop.id" class="shop-card">
              <h3>{{ shop.name }}</h3>
              <p class="shop-desc">{{ shop.description }}</p>
              <div class="shop-info">
                <span>📍 {{ shop.address }}</span>
                <span>📞 {{ shop.contact }}</span>
                <span>⭐ {{ shop.averageRating || 0 }} ({{ shop.reviewCount || 0 }}条评价)</span>
              </div>
              <div class="shop-actions">
                <button @click="editShop(shop)" class="btn-edit">编辑</button>
                <button @click="deleteShop(shop.id)" class="btn-delete">删除</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 评价管理 -->
        <div v-if="activeTab === 'evaluation'" class="tab-content">
          <h2>店铺评价</h2>
          
          <div v-if="evaluations.length === 0" class="empty-state">
            <p>暂无评价</p>
          </div>
          
          <div v-else class="evaluation-list">
            <div v-for="evaluation in evaluations" :key="evaluation.id" class="evaluation-card">
              <div class="evaluation-header">
                <span class="user-name">{{ evaluation.userName }}</span>
                <span class="rating">⭐ {{ evaluation.rating }}</span>
                <span class="date">{{ formatDate(evaluation.createTime) }}</span>
              </div>
              <p class="evaluation-content">{{ evaluation.content }}</p>
              <div class="shop-name">店铺：{{ evaluation.shopName }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 店铺表单弹窗 -->
    <div v-if="showShopForm" class="modal" @click.self="closeShopForm">
      <div class="modal-content">
        <h2>{{ editingShop ? '编辑店铺' : '添加店铺' }}</h2>
        <form @submit.prevent="saveShop">
          <div class="form-group">
            <label>店铺名称</label>
            <input v-model="shopForm.name" required />
          </div>
          <div class="form-group">
            <label>店铺描述</label>
            <textarea v-model="shopForm.description" rows="3"></textarea>
          </div>
          <div class="form-group">
            <label>店铺地址</label>
            <input v-model="shopForm.address" />
          </div>
          <div class="form-group">
            <label>联系方式</label>
            <input v-model="shopForm.contact" />
          </div>
          <div class="form-actions">
            <button type="button" @click="closeShopForm" class="btn-cancel">取消</button>
            <button type="submit" class="btn-primary">保存</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MerchantDashboard',
  data() {
    return {
      activeTab: 'shop',
      shops: [],
      evaluations: [],
      showShopForm: false,
      editingShop: null,
      shopForm: {
        name: '',
        description: '',
        address: '',
        contact: ''
      }
    }
  },
  mounted() {
    this.checkAuth()
    this.loadShops().then(() => {
      this.loadEvaluations()
    })
  },
  methods: {
    checkAuth() {
      const user = JSON.parse(localStorage.getItem('user') || '{}')
      if (!user.userRole || user.userRole.id !== 2) {
        this.$router.push('/login')
      }
    },
    async loadShops() {
      try {
        const response = await fetch('http://localhost:8082/api/shops')
        this.shops = await response.json()
      } catch (error) {
        console.error('加载店铺失败', error)
      }
    },
    async loadEvaluations() {
      try {
        // 获取所有店铺的评价
        if (this.shops.length > 0) {
          const allEvaluations = []
          for (const shop of this.shops) {
            const response = await fetch(`http://localhost:8082/api/evaluations/shop/${shop.id}`)
            const evaluations = await response.json()
            evaluations.forEach(e => {
              e.shopName = shop.name
              allEvaluations.push(e)
            })
          }
          this.evaluations = allEvaluations
        }
      } catch (error) {
        console.error('加载评价失败', error)
      }
    },
    editShop(shop) {
      this.editingShop = shop
      this.shopForm = { ...shop }
      this.showShopForm = true
    },
    async saveShop() {
      try {
        const url = this.editingShop 
          ? `http://localhost:8082/api/shops/${this.editingShop.id}`
          : 'http://localhost:8082/api/shops'
        
        const method = this.editingShop ? 'PUT' : 'POST'
        
        await fetch(url, {
          method: method,
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(this.shopForm)
        })
        
        this.closeShopForm()
        this.loadShops()
      } catch (error) {
        console.error('保存店铺失败', error)
      }
    },
    async deleteShop(id) {
      if (confirm('确定要删除这个店铺吗？')) {
        try {
          await fetch(`http://localhost:8082/api/shops/${id}`, {
            method: 'DELETE'
          })
          this.loadShops()
        } catch (error) {
          console.error('删除店铺失败', error)
        }
      }
    },
    closeShopForm() {
      this.showShopForm = false
      this.editingShop = null
      this.shopForm = {
        name: '',
        description: '',
        address: '',
        contact: ''
      }
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString('zh-CN')
    },
    logout() {
      localStorage.removeItem('user')
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.merchant-dashboard {
  min-height: 100vh;
  background: #f5f5f5;
}

.dashboard-header {
  background: white;
  padding: 20px 40px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dashboard-header h1 {
  margin: 0;
  color: #8B4513;
}

.logout-btn {
  padding: 8px 20px;
  background: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.dashboard-content {
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

.tab-content {
  background: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.btn-primary {
  padding: 10px 20px;
  background: #8B4513;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
}

.shop-list {
  display: grid;
  gap: 20px;
}

.shop-card {
  border: 1px solid #e0e0e0;
  padding: 20px;
  border-radius: 8px;
}

.shop-card h3 {
  margin: 0 0 10px 0;
  color: #8B4513;
}

.shop-desc {
  color: #666;
  margin-bottom: 15px;
}

.shop-info {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.shop-actions {
  display: flex;
  gap: 10px;
}

.btn-edit, .btn-delete {
  padding: 6px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-edit {
  background: #28a745;
  color: white;
}

.btn-delete {
  background: #dc3545;
  color: white;
}

.evaluation-list {
  display: grid;
  gap: 15px;
}

.evaluation-card {
  border: 1px solid #e0e0e0;
  padding: 15px;
  border-radius: 8px;
}

.evaluation-header {
  display: flex;
  gap: 15px;
  margin-bottom: 10px;
  font-size: 14px;
}

.user-name {
  font-weight: bold;
  color: #333;
}

.rating {
  color: #ff9800;
}

.date {
  color: #999;
}

.evaluation-content {
  color: #666;
  margin-bottom: 10px;
}

.shop-name {
  font-size: 12px;
  color: #999;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  padding: 30px;
  border-radius: 8px;
  width: 500px;
  max-width: 90%;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  color: #333;
  font-weight: 500;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.btn-cancel {
  padding: 8px 20px;
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
