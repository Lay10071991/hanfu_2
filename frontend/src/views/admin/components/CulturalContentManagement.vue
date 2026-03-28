<template>
  <div class="management-container">
    <div class="header">
      <h2>文化内容管理</h2>
      <button @click="showAddDialog" class="btn-primary">新增内容</button>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>标题</th>
            <th>类型</th>
            <th>名称</th>
            <th>年代</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ item.title }}</td>
            <td>{{ getTypeText(item.type) }}</td>
            <td>{{ item.name || '-' }}</td>
            <td>{{ item.years || '-' }}</td>
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

    <!-- 添加/编辑对话框 -->
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? '编辑内容' : '新增内容' }}</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>类型</label>
            <select v-model="form.type" required>
              <option value="overview">概述</option>
              <option value="history">历史演变</option>
            </select>
          </div>
          <div class="form-group">
            <label>名称</label>
            <input v-model="form.name" />
          </div>
          <div class="form-group">
            <label>年代</label>
            <input v-model="form.years" />
          </div>
          <div class="form-group">
            <label>内容</label>
            <textarea v-model="form.content" rows="8" required></textarea>
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
  name: 'CulturalContentManagement',
  data() {
    return {
      items: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        title: '',
        type: 'overview',
        name: '',
        years: '',
        content: ''
      }
    }
  },
  mounted() {
    this.loadItems()
  },
  methods: {
    async loadItems() {
      try {
        const response = await fetch('http://localhost:8082/api/cultural-content')
        const allItems = await response.json()
        this.totalPages = Math.ceil(allItems.length / this.pageSize)
        const start = (this.currentPage - 1) * this.pageSize
        this.items = allItems.slice(start, start + this.pageSize)
      } catch (error) {
        console.error('加载文化内容失败', error)
      }
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        title: '',
        type: 'overview',
        name: '',
        years: '',
        content: ''
      }
      this.showDialog = true
    },
    editItem(item) {
      this.isEdit = true
      this.form = { ...item }
      this.showDialog = true
    },
    async saveItem() {
      try {
        const url = this.isEdit 
          ? `http://localhost:8082/api/cultural-content/${this.form.id}`
          : 'http://localhost:8082/api/cultural-content'
        
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
      if (confirm('确定要删除这条内容吗？')) {
        try {
          await fetch(`http://localhost:8082/api/cultural-content/${id}`, {
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
    getTypeText(type) {
      return type === 'overview' ? '概述' : '历史演变'
    }
  }
}
</script>

<style scoped>
@import './management-common.css';
</style>
