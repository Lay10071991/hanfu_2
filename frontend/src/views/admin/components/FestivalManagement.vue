<template>
  <div class="management-container">
    <div class="header">
      <h2>节日管理</h2>
      <div class="header-buttons">
        <button @click="loadItems" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增节日</button>
      </div>
    </div>
    <div class="table-container">
      <table>
        <thead>
          <tr><th>序号</th><th>节日名称</th><th>日期</th><th>季节</th><th>操作</th></tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.date }}</td>
            <td>{{ getSeasonText(item.season) }}</td>
            <td>
              <button @click="editItem(item)" class="btn-edit">编辑</button>
              <button @click="deleteItem(item.id)" class="btn-delete">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="pagination">
      <button @click="prevPage" :disabled="currentPage === 1">上一页</button>
      <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
      <button @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
    </div>
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? '编辑节日' : '新增节日' }}</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>节日名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>日期</label>
            <input v-model="form.date" required />
          </div>
          <div class="form-group">
            <label>季节</label>
            <select v-model="form.season" required>
              <option value="spring">春季</option>
              <option value="summer">夏季</option>
              <option value="autumn">秋季</option>
              <option value="winter">冬季</option>
            </select>
          </div>
          <div class="form-group">
            <label>图片</label>
            <div class="upload-area">
              <input 
                type="file" 
                ref="fileInput" 
                @change="handleFileChange" 
                accept="image/*"
                style="display: none"
              />
              <div v-if="!imagePreview" class="upload-placeholder" @click="$refs.fileInput.click()">
                <span>点击上传图片</span>
              </div>
              <div v-else class="image-preview">
                <img :src="imagePreview" alt="预览图" />
                <button type="button" @click="removeImage" class="btn-remove">删除</button>
              </div>
            </div>
            <small v-if="uploading">上传中...</small>
          </div>
          <div class="form-group">
            <label>描述</label>
            <textarea v-model="form.description" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label>习俗(用|分隔)</label>
            <textarea v-model="form.customs" rows="3"></textarea>
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
  name: 'FestivalManagement',
  data() {
    return {
      items: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showDialog: false,
      isEdit: false,
      uploading: false,
      imagePreview: null,
      form: {
        id: null,
        name: '',
        date: '',
        season: 'spring',
        image: '',
        description: '',
        customs: ''
      }
    }
  },
  mounted() {
    this.loadItems()
  },
  methods: {
    async loadItems() {
      try {
        const response = await fetch('http://localhost:8082/api/festival')
        const allItems = await response.json()
        this.totalPages = Math.ceil(allItems.length / this.pageSize)
        const start = (this.currentPage - 1) * this.pageSize
        this.items = allItems.slice(start, start + this.pageSize)
      } catch (error) {
        console.error('加载失败', error)
      }
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        name: '',
        date: '',
        season: 'spring',
        image: '',
        description: '',
        customs: ''
      }
      this.imagePreview = null
      this.showDialog = true
    },
    editItem(item) {
      this.isEdit = true
      this.form = { ...item }
      this.imagePreview = item.image ? `http://localhost:8082${item.image}` : null
      this.showDialog = true
    },
    async handleFileChange(event) {
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
        alert('上传失败,请重试')
      } finally {
        this.uploading = false
      }
    },
    removeImage() {
      this.form.image = ''
      this.imagePreview = null
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = ''
      }
    },
    async saveItem() {
      if (!this.form.image) {
        alert('请上传图片')
        return
      }

      try {
        const url = this.isEdit 
          ? `http://localhost:8082/api/festival/${this.form.id}`
          : 'http://localhost:8082/api/festival'
        
        await fetch(url, {
          method: this.isEdit ? 'PUT' : 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.form)
        })
        
        this.closeDialog()
        this.loadItems()
      } catch (error) {
        console.error('保存失败', error)
      }
    },
    async deleteItem(id) {
      if (confirm('确定要删除吗？')) {
        try {
          await fetch(`http://localhost:8082/api/festival/${id}`, {
            method: 'DELETE'
          })
          this.loadItems()
        } catch (error) {
          console.error('删除失败', error)
        }
      }
    },
    closeDialog() {
      this.showDialog = false
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
        this.loadItems()
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
        this.loadItems()
      }
    },
    getSeasonText(season) {
      const map = {
        spring: '春季',
        summer: '夏季',
        autumn: '秋季',
        winter: '冬季'
      }
      return map[season] || season
    }
  }
}
</script>

<style scoped>
@import './management-common.css';

.upload-area {
  margin-top: 8px;
}

.upload-placeholder {
  border: 2px dashed #ddd;
  border-radius: 8px;
  padding: 40px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
}

.upload-placeholder:hover {
  border-color: #8B4513;
  background: #f9f9f9;
}

.upload-placeholder span {
  color: #666;
  font-size: 14px;
}

.image-preview {
  position: relative;
  display: inline-block;
}

.image-preview img {
  max-width: 300px;
  max-height: 200px;
  border-radius: 8px;
  display: block;
}

.btn-remove {
  position: absolute;
  top: 10px;
  right: 10px;
  padding: 5px 10px;
  background: rgba(220, 53, 69, 0.9);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.btn-remove:hover {
  background: rgba(220, 53, 69, 1);
}

.form-group small {
  display: block;
  margin-top: 5px;
  color: #666;
  font-size: 12px;
}
</style>
