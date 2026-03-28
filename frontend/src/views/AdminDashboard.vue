<template>
  <div class="admin-dashboard">
    <div class="dashboard-header">
      <h1>管理员后台</h1>
      <button @click="logout" class="logout-btn">退出登录</button>
    </div>

    <div class="dashboard-content">
      <div class="sidebar">
         <div 
          :class="['menu-item', { active: activeTab === 'statistics' }]"
          @click="activeTab = 'statistics'"
        >
          <i class="icon">📊</i>
          <span>数据统计</span>
        </div>
        <div 
          :class="['menu-item', { active: activeTab === 'users' }]"
          @click="activeTab = 'users'"
        >
          <i class="icon">👥</i>
          <span>用户管理</span>
        </div>
        <div 
          :class="['menu-item', { active: activeTab === 'posts' }]"
          @click="activeTab = 'posts'"
        >
          <i class="icon">📝</i>
          <span>帖子管理</span>
        </div>
        <div 
          :class="['menu-item', { active: activeTab === 'shops' }]"
          @click="activeTab = 'shops'"
        >
          <i class="icon">🏪</i>
          <span>店铺管理</span>
        </div>
        <div 
          :class="['menu-item', { active: activeTab === 'activities' }]"
          @click="activeTab = 'activities'"
        >
          <i class="icon">🎉</i>
          <span>活动管理</span>
        </div>
       
      </div>

      <div class="main-content">
        <!-- 用户管理 -->
        <div v-if="activeTab === 'users'" class="tab-content">
          <h2>用户管理</h2>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>用户名</th>
                  <th>性别</th>
                  <th>角色</th>
                  <th>个人简介</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in users" :key="user.id">
                  <td>{{ user.id }}</td>
                  <td>{{ user.username }}</td>
                  <td>{{ getGenderText(user.gender) }}</td>
                  <td>{{ user.userRole?.roleName || '-' }}</td>
                  <td>{{ user.bio || '-' }}</td>
                  <td>
                    <button @click="deleteUser(user.id)" class="btn-delete">删除</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 帖子管理 -->
        <div v-if="activeTab === 'posts'" class="tab-content">
          <h2>帖子管理</h2>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>标题</th>
                  <th>作者</th>
                  <th>分类</th>
                  <th>点赞数</th>
                  <th>评论数</th>
                  <th>浏览数</th>
                  <th>发布日期</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="post in posts" :key="post.id">
                  <td>{{ post.id }}</td>
                  <td>{{ post.title }}</td>
                  <td>{{ post.authorName }}</td>
                  <td>{{ post.category }}</td>
                  <td>{{ post.likes }}</td>
                  <td>{{ post.comments }}</td>
                  <td>{{ post.views }}</td>
                  <td>{{ formatDate(post.publishDate) }}</td>
                  <td>
                    <button @click="deletePost(post.id)" class="btn-delete">删除</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 店铺管理 -->
        <div v-if="activeTab === 'shops'" class="tab-content">
          <h2>店铺管理</h2>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>店铺名称</th>
                  <th>地址</th>
                  <th>联系方式</th>
                  <th>平均评分</th>
                  <th>评价数</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="shop in shops" :key="shop.id">
                  <td>{{ shop.id }}</td>
                  <td>{{ shop.name }}</td>
                  <td>{{ shop.address }}</td>
                  <td>{{ shop.contact }}</td>
                  <td>{{ shop.averageRating || 0 }}</td>
                  <td>{{ shop.reviewCount || 0 }}</td>
                  <td>
                    <button @click="deleteShop(shop.id)" class="btn-delete">删除</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 活动管理 -->
        <div v-if="activeTab === 'activities'" class="tab-content">
          <h2>活动管理</h2>
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
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
                <tr v-for="activity in activities" :key="activity.id">
                  <td>{{ activity.id }}</td>
                  <td>{{ activity.title }}</td>
                  <td>{{ activity.location }}</td>
                  <td>{{ formatDateTime(activity.startTime) }}</td>
                  <td>{{ formatDateTime(activity.endTime) }}</td>
                  <td>{{ getStatusText(activity.status) }}</td>
                  <td>{{ activity.participantsCount }}</td>
                  <td>
                    <button @click="deleteActivity(activity.id)" class="btn-delete">删除</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 数据统计 -->
        <div v-if="activeTab === 'statistics'" class="tab-content">
          <h2>数据统计</h2>
          <div class="statistics-grid">
            <div class="stat-card">
              <div class="stat-icon">👥</div>
              <div class="stat-info">
                <div class="stat-value">{{ statistics.totalUsers }}</div>
                <div class="stat-label">总用户数</div>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon">📝</div>
              <div class="stat-info">
                <div class="stat-value">{{ statistics.totalPosts }}</div>
                <div class="stat-label">总帖子数</div>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon">🏪</div>
              <div class="stat-info">
                <div class="stat-value">{{ statistics.totalShops }}</div>
                <div class="stat-label">总店铺数</div>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon">🎉</div>
              <div class="stat-info">
                <div class="stat-value">{{ statistics.totalActivities }}</div>
                <div class="stat-label">总活动数</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AdminDashboard',
  data() {
    return {
      activeTab: 'users',
      users: [],
      posts: [],
      shops: [],
      activities: [],
      statistics: {
        totalUsers: 0,
        totalPosts: 0,
        totalShops: 0,
        totalActivities: 0
      }
    }
  },
  mounted() {
    this.checkAuth()
    this.loadData()
  },
  methods: {
    checkAuth() {
      const user = JSON.parse(localStorage.getItem('user') || '{}')
      if (!user.userRole || user.userRole.id !== 3) {
        this.$router.push('/login')
      }
    },
    async loadData() {
      await this.loadUsers()
      await this.loadPosts()
      await this.loadShops()
      await this.loadActivities()
      this.updateStatistics()
    },
    async loadUsers() {
      try {
        const response = await fetch('http://localhost:8082/api/users')
        this.users = await response.json()
      } catch (error) {
        console.error('加载用户失败', error)
      }
    },
    async loadPosts() {
      try {
        const response = await fetch('http://localhost:8082/api/posts')
        this.posts = await response.json()
      } catch (error) {
        console.error('加载帖子失败', error)
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
    async loadActivities() {
      try {
        const response = await fetch('http://localhost:8082/api/activities')
        this.activities = await response.json()
      } catch (error) {
        console.error('加载活动失败', error)
      }
    },
    updateStatistics() {
      this.statistics = {
        totalUsers: this.users.length,
        totalPosts: this.posts.length,
        totalShops: this.shops.length,
        totalActivities: this.activities.length
      }
    },
    async deleteUser(id) {
      if (confirm('确定要删除这个用户吗？')) {
        try {
          await fetch(`http://localhost:8082/api/users/${id}`, {
            method: 'DELETE'
          })
          this.loadUsers()
        } catch (error) {
          console.error('删除用户失败', error)
        }
      }
    },
    async deletePost(id) {
      if (confirm('确定要删除这个帖子吗？')) {
        try {
          await fetch(`http://localhost:8082/api/posts/${id}`, {
            method: 'DELETE'
          })
          this.loadPosts()
        } catch (error) {
          console.error('删除帖子失败', error)
        }
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
    getGenderText(gender) {
      const map = {
        male: '男',
        female: '女',
        unknown: '未知'
      }
      return map[gender] || '未知'
    },
    getStatusText(status) {
      const map = {
        upcoming: '即将开始',
        ongoing: '进行中',
        completed: '已完成',
        cancelled: '已取消'
      }
      return map[status] || status
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString('zh-CN')
    },
    formatDateTime(datetime) {
      return new Date(datetime).toLocaleString('zh-CN')
    },
    logout() {
      localStorage.removeItem('user')
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.admin-dashboard {
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

.table-container {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

th {
  background: #f8f9fa;
  font-weight: 600;
  color: #333;
}

.btn-delete {
  padding: 6px 15px;
  background: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.statistics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 30px;
  border-radius: 12px;
  color: white;
  display: flex;
  align-items: center;
  gap: 20px;
}

.stat-card:nth-child(2) {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-card:nth-child(3) {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-card:nth-child(4) {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-icon {
  font-size: 48px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 36px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  opacity: 0.9;
}
</style>
