<template>
  <div class="management-container">
    <div class="header">
      <h2>服务项目管理</h2>
      <div class="shop-selector">
        <label>选择店铺：</label>
        <select v-model="selectedShopId" @change="loadServices">
          <option value="">请选择店铺</option>
          <option v-for="shop in shops" :key="shop.id" :value="shop.id">
            {{ shop.name }}
          </option>
        </select>
      </div>
      <button v-if="selectedShopId" @click="showAddDialog" class="btn-primary">添加服务项目</button>
    </div>

    <div v-if="!selectedShopId" class="empty-state">
      <p>请先选择一个店铺</p>
    </div>

    <div v-else-if="services.length === 0" class="empty-state">
      <p>该店铺暂无服务项目，点击上方按钮添加</p>
    </div>

    <div v-else class="service-list">
      <div v-for="service in services" :key="service.id" class="service-card">
        <h3>{{ service.serviceName }}</h3>
        <div class="service-actions">
          <button @click="editService(service)" class="btn-edit">编辑</button>
          <button @click="deleteService(service.id)" class="btn-delete">删除</button>
        </div>
      </div>
    </div>

    <!-- 添加/编辑对话框 -->
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? '编辑服务项目' : '添加服务项目' }}</h3>
        <form @submit.prevent="saveService">
          <div class="form-group">
            <label>服务名称</label>
            <input v-model="form.serviceName" required />
          </div>
          <div class="form-actions">
            <button type="button" @click="closeDialog" class="btn-cancel">取消</button>
            <button type="submit" class="btn-primary">保存</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ServiceManagement',
  data() {
    return {
      shops: [],
      services: [],
      selectedShopId: '',
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        serviceName: ''
      }
    }
  },
  mounted() {
    this.loadShops()
  },
  methods: {
    loadShops() {
      const API_BASE = 'http://localhost:8080/api'
      const user = JSON.parse(localStorage.getItem('user') || '{}')
      if (!user.id) return

      fetch(`${API_BASE}/shops?userId=${user.id}`)
        .then(response => response.json())
        .then(data => {
          this.shops = data
        })
        .catch(error => {
          console.error('加载店铺失败:', error)
        })
    },
    loadServices() {
      if (!this.selectedShopId) {
        this.services = []
        return
      }

      const API_BASE = 'http://localhost:8080/api'
      fetch(`${API_BASE}/shop-services?shopId=${this.selectedShopId}`)
        .then(response => response.json())
        .then(data => {
          this.services = data
        })
        .catch(error => {
          console.error('加载服务项目失败:', error)
        })
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        serviceName: ''
      }
      this.showDialog = true
    },
    editService(service) {
      this.isEdit = true
      this.form = { ...service }
      this.showDialog = true
    },
    closeDialog() {
      this.showDialog = false
    },
    saveService() {
      const API_BASE = 'http://localhost:8080/api'
      if (!this.selectedShopId) return

      const url = this.isEdit 
        ? `${API_BASE}/shop-services/${this.form.id}` 
        : `${API_BASE}/shop-services`
      const method = this.isEdit ? 'PUT' : 'POST'

      const data = {
        ...this.form,
        shopId: this.selectedShopId
      }

      fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })
      .then(response => response.json())
      .then(() => {
        this.showDialog = false
        this.loadServices()
      })
      .catch(error => {
        console.error('保存服务项目失败:', error)
      })
    },
    deleteService(serviceId) {
      if (confirm('确定要删除这个服务项目吗？')) {
        const API_BASE = 'http://localhost:8080/api'
        
        fetch(`${API_BASE}/shop-services/${serviceId}`, {
          method: 'DELETE'
        })
        .then(() => {
          this.loadServices()
        })
        .catch(error => {
          console.error('删除服务项目失败:', error)
        })
      }
    }
  }
}
</script>

<style scoped>
.management-container {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 10px;
}

.header h2 {
  margin: 0;
  color: #8B4513;
}

.shop-selector {
  display: flex;
  align-items: center;
  gap: 10px;
}

.shop-selector select {
  padding: 6px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.btn-primary {
  background: #8B4513;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary:hover {
  background: #6B340E;
}

.empty-state {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  color: #666;
}

.service-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.service-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.service-card h3 {
  margin: 0;
  color: #8B4513;
}

.service-actions {
  display: flex;
  gap: 10px;
}

.btn-edit, .btn-delete {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-edit {
  background: #4CAF50;
  color: white;
}

.btn-delete {
  background: #f44336;
  color: white;
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
  width: 90%;
  max-width: 400px;
}

.modal-content h3 {
  margin: 0 0 20px 0;
  color: #8B4513;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

.form-group input {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.btn-cancel {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: white;
  cursor: pointer;
}

.btn-cancel:hover {
  background: #f5f5f5;
}
</style>