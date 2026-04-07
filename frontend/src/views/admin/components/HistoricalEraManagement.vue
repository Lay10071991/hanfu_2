<template>
  <div class="management-container">
    <div class="header">
      <h2>历史时间线管理</h2>
      <button @click="showAddDialog" class="btn-primary">新增朝代</button>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>朝代名称</th>
            <th>年代</th>
            <th>标题</th>
            <th>描述</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.years }}</td>
            <td>{{ item.title }}</td>
            <td>{{ item.description.substring(0, 50) }}...</td>
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
        <h3>{{ isEdit ? '编辑朝代' : '新增朝代' }}</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>朝代名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>年代</label>
            <input v-model="form.years" required />
          </div>
          <div class="form-group">
            <label>标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>描述</label>
            <textarea v-model="form.description" rows="8" required></textarea>
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
  name: 'HistoricalEraManagement',
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
        name: '',
        years: '',
        title: '',
        description: ''
      }
    }
  },
  mounted() {
    this.loadItems()
  },
  methods: {
    async loadItems() {
      try {
        const response = await fetch('http://localhost:8082/api/historical-era')
        const allItems = await response.json()
        this.totalPages = Math.ceil(allItems.length / this.pageSize)
        const start = (this.currentPage - 1) * this.pageSize
        this.items = allItems.slice(start, start + this.pageSize)
      } catch (error) {
        console.error('加载历史朝代失败', error)
      }
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        name: '',
        years: '',
        title: '',
        description: ''
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
          ? `http://localhost:8082/api/historical-era/${this.form.id}`
          : 'http://localhost:8082/api/historical-era'

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
      if (confirm('确定要删除这个朝代吗？')) {
        try {
          await fetch(`http://localhost:8082/api/historical-era/${id}`, {
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
    }
  }
}
</script>

<style scoped>
@import './management-common.css';
</style>
