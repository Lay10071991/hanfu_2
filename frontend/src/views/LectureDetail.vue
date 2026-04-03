<template>
  <div class="lecture-detail-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/')">汉服知识库</li>
          <li class="nav-item" @click="$router.push('/culture')">传统文化学习</li>
          <li class="nav-item" @click="$router.push('/activity')">汉服活动召集</li>
          <li class="nav-item" @click="$router.push('/shop-evaluation')">汉服店铺测评</li>
          <li class="nav-item" @click="$router.push('/community')">社区互动</li>
          <li class="nav-item" @click="$router.push('/ai-chat')">AI问答</li>
          <li class="nav-item" @click="goToProfile">个人中心</li>
        </ul>
        <div class="user-info-vertical">
          <div class="user-name">欢迎，{{ username }}</div>
          <el-button type="text" @click="logout" class="logout-btn">退出</el-button>
        </div>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="container">
        <!-- 返回按钮 -->
        <div class="back-section">
          <el-button type="text" @click="$router.back()" class="back-btn">
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
        </div>

        <!-- 讲座详情 -->
        <div v-if="lecture" class="lecture-detail">
          <div class="detail-header">
            <div class="lecture-image">
              <el-image
                :src="lecture.detailImage || lecture.image"
                fit="cover"
                class="main-image"
              />
            </div>

            <div class="lecture-basic-info">
              <h2 class="lecture-title">{{ lecture.title }}</h2>

              <div class="speaker-section">
                <div class="speaker-avatar">
                  <el-avatar :size="60" :src="lecture.speakerAvatar" />
                </div>
                <div class="speaker-info">
                  <h3>{{ lecture.speaker }}</h3>
                  <p class="speaker-title">{{ lecture.speakerTitle }}</p>
                </div>
              </div>

              <div class="info-grid">
                <div class="info-item">
                  <el-icon><Calendar /></el-icon>
                  <div class="info-content">
                    <div class="info-label">讲座日期</div>
                    <div class="info-value">{{ lecture.date }}</div>
                  </div>
                </div>
                <div class="info-item">
                  <el-icon><Clock /></el-icon>
                  <div class="info-content">
                    <div class="info-label">讲座时间</div>
                    <div class="info-value">{{ lecture.time }}</div>
                  </div>
                </div>
                <div class="info-item">
                  <el-icon><Location /></el-icon>
                  <div class="info-content">
                    <div class="info-label">讲座地点</div>
                    <div class="info-value">{{ lecture.location }}</div>
                  </div>
                </div>
                <div class="info-item">
                  <el-icon><UserFilled /></el-icon>
                  <div class="info-content">
                    <div class="info-label">参加人数</div>
                    <div class="info-value">{{ lecture.participants }}人</div>
                  </div>
                </div>
              </div>

              <div class="action-buttons">
                <el-button type="primary" size="large" @click="handleSignUp" :disabled="isSignedUp">
                  <el-icon><Check /></el-icon>
                  {{ isSignedUp ? '已报名' : '立即报名' }}
                </el-button>
              </div>
            </div>
          </div>

          <div class="detail-content">
            <div class="content-section">
              <h3 class="section-title">
                <el-icon><Document /></el-icon>
                讲座简介
              </h3>
              <div class="section-content">
                <p>{{ lecture.detailDescription || lecture.description }}</p>
              </div>
            </div>

            <div class="content-section">
              <h3 class="section-title">
                <el-icon><Warning /></el-icon>
                注意事项
              </h3>
              <div class="section-content">
                <ul class="notice-list">
                  <li>请提前15分钟到达会场</li>
                  <li>讲座期间请将手机调至静音</li>
                  <li>欢迎提问，请有序举手发言</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="no-lecture">
          <el-empty description="未找到讲座信息" />
        </div>
      </div>
    </div>

    <!-- 页脚 -->
    <div class="footer">
      <div class="container">
        <p>汉服文化交流平台</p>
        <p class="footer-subtitle">传承华夏衣冠，弘扬汉服文化</p>
      </div>
    </div>

    <!-- 报名成功提示 -->
    <el-dialog
      v-model="signUpDialogVisible"
      title="报名成功"
      width="400px"
      :show-close="false"
      center
    >
      <div class="dialog-content">
        <el-icon color="#67C23A" size="60px"><CircleCheck /></el-icon>
        <p style="margin-top: 20px; text-align: center;">恭喜您成功报名参加讲座！</p>
        <p style="color: #666; font-size: 14px; text-align: center; margin-top: 10px;">
          讲座开始前会通过短信/邮箱提醒您
        </p>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="signUpDialogVisible = false">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted} from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  ArrowLeft,
  Calendar,
  Clock,
  Location,
  UserFilled,
  Check,
  Document,
  Warning,
  CircleCheck
} from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const username = ref('')

// 讲座数据
const lecture = ref(null)
const isSignedUp = ref(false)
const signUpDialogVisible = ref(false)

// 图片URL处理函数
const getImageUrl = (url) => {
  if (!url) return ''
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }
  const path = url.startsWith('/') ? url : `/${url}`
  return `http://localhost:8082${path}`
}

onMounted(() => {
  const savedUsername = localStorage.getItem('username')
  if (savedUsername) {
    username.value = savedUsername
  }

  // 根据路由参数加载讲座数据
  const lectureId = parseInt(route.params.id) || 1
  loadLectureData(lectureId)
})

const loadLectureData = async (id) => {
  try {
    const response = await fetch(`http://localhost:8082/api/lectures/${id}`)
    if (response.ok) {
      const data = await response.json()
      lecture.value = {
        id: data.id,
        title: data.title,
        speaker: data.speaker || '待定',
        speakerTitle: data.speakerBio || '资深汉服文化研究者',
        speakerAvatar: `https://placehold.co/60/8B4513/ffffff?text=${data.speaker?.charAt(0) || '讲'}`,
        date: data.startTime ? new Date(data.startTime).toLocaleDateString('zh-CN') : '待定',
        time: data.startTime && data.endTime
          ? `${new Date(data.startTime).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })}-${new Date(data.endTime).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })}`
          : '待定',
        location: data.location || '待定',
        image: getImageUrl(data.image) || 'http://localhost:8082/uploads/talk/1.jpg',
        detailImage: getImageUrl(data.image) || 'http://localhost:8082/uploads/talk/1.jpg',
        description: data.description || '',
        detailDescription: data.content || data.description || '',
        participants: data.currentParticipants || 0
      }
    }
  } catch (error) {
    console.error('加载讲座数据失败:', error)
  }
}

const goToProfile = () => {
  const role = localStorage.getItem('role')
  if (role === 'shop') {
    router.push('/shop-profile')
  } else {
    router.push('/profile')
  }
}

const handleSignUp = () => {
  if (isSignedUp.value) return

  ElMessageBox.confirm(
    '确定要报名参加此讲座吗？',
    '报名确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'info'
    }
  ).then(() => {
    isSignedUp.value = true
    if (lecture.value) {
      lecture.value.participants++
    }
    signUpDialogVisible.value = true
  }).catch(() => {
    // 用户取消
  })
}

const logout = () => {
  localStorage.removeItem('isLoggedIn')
  localStorage.removeItem('username')
  localStorage.removeItem('role')
  ElMessage.success('退出登录成功')
  router.push('/login')
}
</script>

<style scoped>
.lecture-detail-container {
  min-height: 100vh;
  background-color: #f5f5f5;
}

/* 复用头部和页脚样式 */
.header {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.nav-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.logo {
  font-size: 20px;
  font-weight: bold;
  white-space: nowrap;
}

.nav-menu {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  white-space: nowrap;
  flex-wrap: nowrap;
}

.nav-item {
  margin: 0 15px;
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 4px;
  transition: background-color 0.3s;
  font-size: 14px;
  white-space: nowrap;
}

.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.2);
}

.user-info-vertical {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  white-space: nowrap;
}

.user-name {
  font-size: 14px;
  margin-bottom: 4px;
  color: white;
}

.logout-btn {
  color: white;
  padding: 0;
  font-size: 12px;
  height: auto;
}

.logout-btn:hover {
  color: #ffd04b;
  background-color: transparent;
}

.main-content {
  padding: 30px 0;
  min-height: calc(100vh - 160px);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.back-section {
  margin-bottom: 20px;
}

.back-btn {
  color: #8b4513;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.back-btn:hover {
  color: #d2691e;
}

/* 讲座详情样式 */
.lecture-detail {
  background-color: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.detail-header {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  margin-bottom: 30px;
}

.lecture-image {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  height: 300px;
}

.main-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.lecture-basic-info {
  display: flex;
  flex-direction: column;
}

.lecture-title {
  font-size: 28px;
  color: #8b4513;
  margin: 0 0 20px 0;
  border-bottom: 2px solid #d4a76a;
  padding-bottom: 15px;
}

.speaker-section {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 25px;
  padding: 15px;
  background-color: #f9f5f0;
  border-radius: 8px;
}

.speaker-info h3 {
  margin: 0 0 5px 0;
  color: #8b4513;
  font-size: 20px;
}

.speaker-title {
  margin: 0;
  color: #666;
  font-size: 14px;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 25px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 8px;
  border-left: 4px solid #d4a76a;
}

.info-item .el-icon {
  color: #8b4513;
  font-size: 24px;
}

.info-content {
  display: flex;
  flex-direction: column;
}

.info-label {
  font-size: 12px;
  color: #999;
  margin-bottom: 4px;
}

.info-value {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.action-buttons {
  display: flex;
  gap: 15px;
  margin-top: 20px;
}

.action-buttons .el-button {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 16px;
  padding: 12px 0;
}

.action-buttons .el-button:first-child {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: #8b4513;
}

/* 详情内容 */
.detail-content {
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.content-section {
  margin-bottom: 30px;
}

.content-section:last-child {
  margin-bottom: 0;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 0 0 20px 0;
  color: #8b4513;
  font-size: 20px;
}

.section-title .el-icon {
  color: #d2691e;
}

.section-content {
  padding-left: 10px;
}

.section-content p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 15px;
}

/* 注意事项 */
.notice-list {
  padding-left: 20px;
  margin: 0;
}

.notice-list li {
  margin-bottom: 10px;
  color: #666;
  line-height: 1.6;
}

.notice-list li:last-child {
  margin-bottom: 0;
}

.no-lecture {
  background-color: white;
  border-radius: 12px;
  padding: 50px 0;
}

.footer {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  text-align: center;
  padding: 20px 0;
  margin-top: 30px;
}

.footer-subtitle {
  font-size: 12px;
  opacity: 0.8;
  margin-top: 5px;
}

/* 响应式设计 */
@media (max-width: 992px) {
  .detail-header {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .lecture-image {
    height: 250px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .action-buttons {
    flex-direction: column;
  }

  .nav-container {
    flex-direction: column;
    gap: 10px;
  }

  .nav-menu {
    flex-wrap: wrap;
    justify-content: center;
  }

  .nav-item {
    margin: 5px;
    font-size: 12px;
  }
}
</style>
