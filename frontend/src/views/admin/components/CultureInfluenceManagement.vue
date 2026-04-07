<template>
  <div class="management-container">
    <div class="header">
      <h2>文化影响与传承管理</h2>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>标题</th>
            <th>内容预览</th>
            <th>创建时间</th>
            <th>更新时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items" :key="item.id">
            <td>{{ item.id }}</td>
            <td>{{ item.title }}</td>
            <td>{{ item.description ? item.description.substring(0, 50) + '...' : '-' }}</td>
            <td>{{ formatDate(item.createTime) }}</td>
            <td>{{ formatDate(item.updateTime) }}</td>
            <td>
              <button @click="editItem(item)" class="btn-edit">编辑</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 编辑模态框 -->
    <div v-if="dialogVisible" class="modal-overlay" @click.self="dialogVisible = false">
      <div class="modal-content">
        <div class="modal-header">
          <h3>编辑文化影响</h3>
          <button class="close-btn" @click="dialogVisible = false">×</button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="saveItem">
            <div class="form-group">
              <label>标题</label>
              <input v-model="form.title" required placeholder="请输入标题" />
            </div>
            <div class="form-group">
              <label>内容</label>
              <textarea v-model="form.description" rows="10" placeholder="请输入内容，多个段落用换行分隔"></textarea>
            </div>
            <div class="form-actions">
              <button type="button" @click="dialogVisible = false" class="btn-cancel">取消</button>
              <button type="submit" class="btn-save">保存</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

const items = ref([])
const dialogVisible = ref(false)
const form = ref({
  id: null,
  title: '',
  description: ''
})

// 加载数据
const loadItems = async () => {
  try {
    const response = await fetch('http://localhost:8082/api/culture-influence')
    if (response.ok) {
      items.value = await response.json()
    }
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败')
  }
}

// 编辑
const editItem = (item) => {
  form.value = { ...item }
  dialogVisible.value = true
}

// 保存
const saveItem = async () => {
  try {
    const url = `http://localhost:8082/api/culture-influence/${form.value.id}`
    const method = 'PUT'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(form.value)
    })

    if (response.ok) {
      ElMessage.success('更新成功')
      dialogVisible.value = false
      loadItems()
    } else {
      ElMessage.error('保存失败')
    }
  } catch (error) {
    console.error('保存失败:', error)
    ElMessage.error('保存失败')
  }
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN')
}

onMounted(() => {
  loadItems()
})
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
}

.header h2 {
  margin: 0;
  color: #8b4513;
}

.btn-primary {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary:hover {
  opacity: 0.9;
}

.table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

th {
  background: #f9f5f0;
  color: #8b4513;
  font-weight: 600;
}

tr:hover {
  background: #f9f9f9;
}

.btn-edit, .btn-delete {
  padding: 5px 10px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  margin-right: 5px;
}

.btn-edit {
  background: #e6a23c;
  color: white;
}

.btn-delete {
  background: #f56c6c;
  color: white;
}

/* 模态框样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
}

.modal-header h3 {
  margin: 0;
  color: #8b4513;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #999;
}

.modal-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 15px;
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
  box-sizing: border-box;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #d2691e;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.btn-cancel, .btn-save {
  padding: 8px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-cancel {
  background: #909399;
  color: white;
}

.btn-save {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
}
</style>
