<template>
  <div class="management-container">
    <div class="header">
      <h2>讲座管理</h2>
      <button @click="showAddDialog" class="btn-primary">新增讲座</button>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>讲座标题</th>
            <th>地点</th>
            <th>开始时间</th>
            <th>结束时间</th>
            <th>状态</th>
            <th>参与人数</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(lecture, index) in lectures" :key="lecture.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ lecture.title }}</td>
            <td>{{ lecture.location }}</td>
            <td>{{ formatDateTime(lecture.startDate) }}</td>
            <td>{{ formatDateTime(lecture.endDate) }}</td>
            <td>{{ getStatusText(lecture.status) }}</td>
            <td>{{ lecture.participantsCount }}</td>
            <td>
              <button @click="editLecture(lecture)" class="btn-edit">编辑</button>
              <button @click="deleteLecture(lecture.id)" class="btn-delete">删除</button>
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
        <h3>{{ isEdit ? '编辑讲座' : '新增讲座' }}</h3>
        <form @submit.prevent="saveLecture">
          <div class="form-group">
            <label>讲座标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>讲座描述</label>
            <textarea v-model="form.description" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label>讲座地点</label>
            <input v-model="form.location" required />
          </div>
          <div class="form-group">
            <label>开始时间</label>
            <input v-model="form.startDate" type="date" required />
          </div>
          <div class="form-group">
            <label>结束时间</label>
            <input v-model="form.endDate" type="date" required />
          </div>
          <div class="form-group">
            <label>状态</label>
            <select v-model="form.status">
              <option value="upcoming">即将开始</option>
              <option value="ongoing">进行中</option>
              <option value="completed">已完成</option>
              <option value="cancelled">已取消</option>
            </select>
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
  name: 'LectureManagement',
  data() {
    return {
      lectures: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        title: '',
        description: '',
        location: '',
        startDate: '',
        endDate: '',
        status: 'upcoming'
      }
    }
  },
  mounted() {
    this.loadLectures()
  },
  methods: {
    async loadLectures() {
      try {
        const response = await fetch('http://localhost:8082/api/lectures')
        const allLectures = await response.json()
        this.totalPages = Math.ceil(allLectures.length / this.pageSize)
        const start = (this.currentPage - 1) * this.pageSize
        this.lectures = allLectures.slice(start, start + this.pageSize)
      } catch (error) {
        console.error('加载讲座失败', error)
      }
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        title: '',
        description: '',
        location: '',
        startDate: '',
        endDate: '',
        status: 'upcoming'
      }
      this.showDialog = true
    },
    editLecture(lecture) {
      this.isEdit = true
      this.form = {
        ...lecture
      }
      this.showDialog = true
    },
    async saveLecture() {
      try {
        const url = this.isEdit 
          ? `http://localhost:8082/api/lectures/${this.form.id}`
          : 'http://localhost:8082/api/lectures'
        
        await fetch(url, {
          method: this.isEdit ? 'PUT' : 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.form)
        })
        
        this.closeDialog()
        this.loadLectures()
      } catch (error) {
        console.error('保存讲座失败', error)
      }
    },
    async deleteLecture(id) {
      if (confirm('确定要删除这个讲座吗？')) {
        try {
          await fetch(`http://localhost:8082/api/lectures/${id}`, {
            method: 'DELETE'
          })
          this.loadLectures()
        } catch (error) {
          console.error('删除讲座失败', error)
        }
      }
    },
    closeDialog() {
      this.showDialog = false
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
        this.loadLectures()
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
        this.loadLectures()
      }
    },
    formatDateTime(datetime) {
      return new Date(datetime).toLocaleDateString('zh-CN')
    },
    getStatusText(status) {
      const map = {
        upcoming: '即将开始',
        ongoing: '进行中',
        completed: '已完成',
        cancelled: '已取消'
      }
      return map[status] || status
    }
  }
}
</script>

<style scoped>
@import './management-common.css';
</style>