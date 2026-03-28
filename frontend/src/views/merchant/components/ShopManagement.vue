<template>
  <div class="management-container">
    <div class="header">
      <h2>店铺管理</h2>
      <button @click="showAddDialog" class="btn-primary">添加店铺</button>
    </div>

    <div v-if="shops.length === 0" class="empty-state">
      <p>暂无店铺信息，点击上方按钮添加店铺</p>
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

    <!-- 添加/编辑对话框 -->
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? '编辑店铺' : '添加店铺' }}</h3>
        <form @submit.prevent="saveShop">
          <div class="form-group">
            <label>店铺名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>店铺描述</label>
            <textarea v-model="form.description" rows="3"></textarea>
          </div>
          <div class="form-group">
            <label>店铺地址</label>
            <input v-model="form.address" />
          </div>
          <div class="form-group">
            <label>联系方式</label>
            <input v-model="form.contact" />
          </div>
          <div class="form-group">
            <label>店铺图片</label>
            <div class="upload-area">
              <input 
                type="file" 
                ref="imageInput" 
                @change="handleImageChange" 
                accept="image/*"
                style="display: none"
              />
              <div v-if="!imagePreview" class="upload-placeholder" @click="$refs.imageInput.click()">
                <span>点击上传店铺图片</span>
              </div>
              <div v-else class="image-preview">
                <img :src="imagePreview" alt="店铺图片" />
                <button type="button" @click="removeImage" class="btn-remove-img">删除</button>
              </div>
            </div>
            <small v-if="uploading" style="color: #666;">上传中...</small>
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
  name: 'ShopManagement',
  data() {
    return {
      shops: [],
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        name: '',
        description: '',
        address: '',
        contact: '',
        image: ''
      },
      imagePreview: null,
      uploading: false
    }
  },
  mounted() {
    this.loadShops()
  },
  methods: {
    async loadShops() {
      try {
        const response = await fetch('http://localhost:8082/api/shops')
        this.shops = await response.json()
      } catch (error) {
        console.error('加载店铺失败', error)
      }
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        name: '',
        description: '',
        address: '',
        contact: '',
        image: ''
      }
      this.imagePreview = null
      this.showDialog = true
    },
    editShop(shop) {
      this.isEdit = true
      this.form = { ...shop }
      if (shop.image) {
        this.imagePreview = shop.image.startsWith('http') ? shop.image : `http://localhost:8082${shop.image}`
      } else {
        this.imagePreview = null
      }
      this.showDialog = true
    },
    async handleImageChange(event) {
      const file = event.target.files[0]
      if (!file) return
      if (!file.type.startsWith('image/')) {
        alert('请选择图片文件')
        return
      }
      if (file.size > 5 * 1024 * 1024) {
        alert('图片大小不能超过5MB')
        return
      }
      this.uploading = true
      try {
        const formData = new FormData()
        formData.append('file', file)
        const response = await fetch('http://localhost:8082/api/upload/image', {
          method: 'POST',
          body: formData
        })
        const result = await response.json()
        if (result.success) {
          this.form.image = result.url
          this.imagePreview = `http://localhost:8082${result.url}`
        } else {
          alert(result.message || '上传失败')
        }
      } catch (error) {
        console.error('上传失败', error)
        alert('上传失败，请稍后重试')
      } finally {
        this.uploading = false
      }
    },
    removeImage() {
      this.form.image = ''
      this.imagePreview = null
      if (this.$refs.imageInput) {
        this.$refs.imageInput.value = ''
      }
    },
    async saveShop() {
      try {
        const url = this.isEdit 
          ? `http://localhost:8082/api/shops/${this.form.id}`
          : 'http://localhost:8082/api/shops'
        
        await fetch(url, {
          method: this.isEdit ? 'PUT' : 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.form)
        })
        
        this.closeDialog()
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
    closeDialog() {
      this.showDialog = false
      this.imagePreview = null
    }
  }
}
</script>

<style scoped>
@import '../../admin/components/management-common.css';

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
  background: white;
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
  flex-wrap: wrap;
}

.shop-actions {
  display: flex;
  gap: 10px;
}

.upload-area {
  margin-top: 5px;
}

.upload-placeholder {
  border: 2px dashed #ddd;
  border-radius: 8px;
  padding: 30px;
  text-align: center;
  cursor: pointer;
  color: #999;
  transition: border-color 0.3s;
}

.upload-placeholder:hover {
  border-color: #8B4513;
  color: #8B4513;
}

.image-preview {
  position: relative;
  display: inline-block;
}

.image-preview img {
  max-width: 200px;
  max-height: 150px;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
}

.btn-remove-img {
  position: absolute;
  top: 5px;
  right: 5px;
  padding: 2px 8px;
  background: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}
</style>
