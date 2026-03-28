<template>
  <div class="management-container">
    <div class="header">
      <h2>活动管理</h2>
      <button @click="showAddDialog" class="btn-primary">新增活动</button>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>活动标题</th>
            <th>地点</th>
            <th>开始时间</th>
            <th>结束时间</th>
            <th>状态</th>
            <th>参与人数</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(activity, index) in activities" :key="activity.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ activity.title }}</td>
            <td>{{ activity.location }}</td>
            <td>{{ formatDateTime(activity.startTime) }}</td>
            <td>{{ formatDateTime(activity.endTime) }}</td>
            <td>{{ getStatusText(activity.status) }}</td>
            <td>{{ activity.participantsCount }}</td>
            <td>
              <button @click="editActivity(activity)" class="btn-edit">编辑</button>
              <button @click="deleteActivity(activity.id)" class="btn-delete">删除</button>
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
        <h3>{{ isEdit ? '编辑活动' : '新增活动' }}</h3>
        <form @submit.prevent="saveActivity">
          <div class="form-group">
            <label>活动标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>活动描述</label>
            <textarea v-model="form.description" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label>活动地点</label>
            <input v-model="form.location" required />
          </div>
          <div class="form-group">
            <label>开始时间</label>
            <input v-model="form.startTime" type="datetime-local" required />
          </div>
          <div class="form-group">
            <label>结束时间</label>
            <input v-model="form.endTime" type="datetime-local" required />
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
          <div class="form-group">
            <label>最大参与人数</label>
            <input v-model.number="form.maxParticipants" type="number" />
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
  name: 'ActivityManagement',
  data() {
    return {
      activities: [],
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
        startTime: '',
        endTime: '',
        status: 'upcoming',
        maxParticipants: 100,
        organizerId: 1
      }
    }
  },
  mounted() {
    this.loadActivities()
  },
  methods: {
    async loadActivities() {
      try {
        const response = await fetch('http://localhost:8082/api/activities')
        const allActivities = await response.json()
        this.totalPages = Math.ceil(allActivities.length / this.pageSize)
        const start = (this.currentPage - 1) * this.pageSize
        this.activities = allActivities.slice(start, start + this.pageSize)
      } catch (error) {
        console.error('加载活动失败', error)
      }
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        title: '',
        description: '',
        location: '',
        startTime: '',
        endTime: '',
        status: 'upcoming',
        maxParticipants: 100,
        organizerId: 1
      }
      this.showDialog = true
    },
    editActivity(activity) {
      this.isEdit = true
      this.form = {
        ...activity,
        startTime: this.formatDateTimeForInput(activity.startTime),
        endTime: this.formatDateTimeForInput(activity.endTime)
      }
      this.showDialog = true
    },
    async saveActivity() {
      try {
        const url = this.isEdit 
          ? `http://localhost:8082/api/activities/${this.form.id}`
          : 'http://localhost:8082/api/activities'
        
        await fetch(url, {
          method: this.isEdit ? 'PUT' : 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.form)
        })
        
        this.closeDialog()
        this.loadActivities()
      } catch (error) {
        console.error('保存活动失败', error)
      }
    },
    async deleteActivity(id) {
      if (confirm('确定要删除这个活动吗？')) {
        try {
          await fetch(`http://localhost:8082/api/activities/${id}`, {
            method: 'DELETE'
          })
          this.loadActivities()
        } catch (error) {
          console.error('删除活动失败', error)
        }
      }
    },
    closeDialog() {
      this.showDialog = false
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
        this.loadActivities()
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
        this.loadActivities()
      }
    },
    formatDateTime(datetime) {
      return new Date(datetime).toLocaleString('zh-CN')
    },
    formatDateTimeForInput(datetime) {
      const date = new Date(datetime)
      return date.toISOString().slice(0, 16)
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
