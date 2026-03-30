<template>
  <div class="history-evolution-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/knowledge')">汉服知识库</li>
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

        <h2 class="page-title">汉服历史演变</h2>

        <!-- 概述部分 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><Notebook /></el-icon>
            历史概述
          </h3>
          <div class="overview-content">
            <div class="overview-text">
              <p v-if="culturalContents.find((item) => item.type === 'overview')">
                {{ culturalContents.find((item) => item.type === "overview").content }}
              </p>
              <p v-else-if="culturalContents.length > 0">
                {{ culturalContents[0].content }}
              </p>
              <p v-else>
                汉服，全称是"汉民族传统服饰"，又称汉衣冠、汉装、华服，是从黄帝即位到公元17世纪中叶(明末清初)，
                在汉族的主要居住区，以"华夏-汉"文化为背景和主导思想，以华夏礼仪文化为中心，通过自然演化而形成的
                具有独特汉民族风貌性格，明显区别于其他民族的传统服装和配饰体系。
                汉服历史悠久，源远流长，承载着中华民族几千年的文化底蕴和审美理念。从黄帝"垂衣裳而天下治"开始，
                汉服就已经具备了基本形制，历经夏商周、秦汉、魏晋南北朝、隋唐、宋元明清各个朝代的发展演变，
                形成了丰富多彩的服饰文化体系。
              </p>
            </div>
          </div>
        </div>

        <!-- 详细时间线 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><Clock /></el-icon>
            历史发展时间线
          </h3>
          <div class="timeline">
            <div
              class="timeline-item"
              v-for="item in culturalContents.filter((item) => item.type === 'history')"
              :key="item.id"
            >
              <div class="timeline-period">
                <span class="era-name">{{ item.name }}</span>
                <span class="era-years">{{ item.years || "" }}</span>
              </div>
              <div class="timeline-content">
                <div class="era-details">
                  <h4>{{ item.title }}</h4>
                  <p>{{ item.content }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 文化影响 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><TrendCharts /></el-icon>
            文化影响与传承
          </h3>
          <div class="culture-impact">
            <div class="impact-item" v-for="item in cultureInfluences" :key="item.id">
              <h4>{{ item.title }}</h4>
              <div class="detail-content" v-if="item.description">
                <p
                  v-for="(paragraph, idx) in item.description.split('\n').filter((p) => p.trim())"
                  :key="idx"
                >
                  {{ paragraph }}
                </p>
              </div>
            </div>
          </div>
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
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { Notebook, ArrowLeft, Clock, TrendCharts } from "@element-plus/icons-vue";

const router = useRouter();
const username = ref("汉服爱好者");

// 文化影响与传承数据
const cultureInfluences = ref([]);

// 从数据库加载文化影响数据
const loadCultureInfluences = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/culture-influence");
    if (response.ok) {
      cultureInfluences.value = await response.json();
    }
  } catch (error) {
    console.error("加载文化影响数据失败:", error);
  }
};

// 历史时期数据
const historicalEras = ref([]);

const loadHistoricalEras = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/historical-era");
    if (response.ok) {
      historicalEras.value = await response.json();
    }
  } catch (error) {
    console.error("加载历史时期数据失败:", error);
  }
};

// 文化内容数据
const culturalContents = ref([]);

// 从后端加载文化内容数据
const loadCulturalContents = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/cultural-content");
    if (response.ok) {
      culturalContents.value = await response.json();
    }
  } catch (error) {
    console.error("加载文化内容数据失败:", error);
  }
};

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  loadCultureInfluences();
  loadHistoricalEras();
  loadCulturalContents();
  window.scrollTo(0, 0);
});

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

const logout = () => {
  localStorage.removeItem("isLoggedIn");
  localStorage.removeItem("username");
  localStorage.removeItem("gender");
  localStorage.removeItem("bio");
  localStorage.removeItem("role");
  ElMessage.success("退出登录成功");
  router.push("/login");
};
</script>

<style scoped>
.history-evolution-container {
  min-height: 100vh;
  background-color: #fef9f3; /* 修改为更柔和的米白色背景 */
}

/* 复用头部样式 */
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

/* 主内容区样式 */
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
}

.back-btn:hover {
  color: #d2691e;
}

.page-title {
  font-size: 28px;
  margin-bottom: 30px;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

.section {
  background-color: white;
  border-radius: 8px;
  padding: 25px;
  margin-bottom: 25px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.section-title {
  font-size: 22px;
  margin-bottom: 20px;
  color: #8b4513;
  display: flex;
  align-items: center;
}

.section-title i {
  margin-right: 8px;
}

/* 概述内容样式 */
.overview-content {
  display: block;
}

.overview-text p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 15px;
  text-align: justify;
}

/* 时间线样式 */
.timeline {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.timeline-item {
  display: grid;
  grid-template-columns: 200px 1fr;
  gap: 25px;
  align-items: start;
}

.timeline-period {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  padding: 15px;
  border-radius: 8px;
  text-align: center;
}

.era-name {
  display: block;
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 5px;
}

.era-years {
  display: block;
  font-size: 12px;
  opacity: 0.9;
}

.timeline-content {
  display: block;
}

.era-details h4 {
  margin: 0 0 10px 0;
  color: #8b4513;
  font-size: 18px;
}

.era-details p {
  line-height: 1.6;
  color: #666;
  margin-bottom: 0;
}

/* 文化影响样式 */
.culture-impact {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.impact-item {
  padding: 20px;
  background: linear-gradient(135deg, #f9f5f0 0%, #f0e6d6 100%);
  border-radius: 8px;
  border-left: 4px solid #d4a76a;
  transition: all 0.3s ease;
}

.impact-item h4 {
  margin: 0 0 10px 0;
  color: #8b4513;
}

.impact-item > p {
  margin: 0 0 15px 0;
  line-height: 1.6;
  color: #666;
}

.detail-content {
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px dashed #d4a76a;
}

.detail-content p {
  margin: 0 0 10px 0;
  line-height: 1.8;
  color: #555;
  text-align: justify;
}

.detail-content p:last-child {
  margin-bottom: 0;
}

/* 页脚样式 */
.footer {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  text-align: center;
  padding: 20px 0;
}

.footer-subtitle {
  font-size: 12px;
  opacity: 0.8;
  margin-top: 5px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .timeline-item {
    grid-template-columns: 1fr;
    gap: 15px;
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

  .culture-impact {
    grid-template-columns: 1fr;
  }

  .image-grid {
    grid-template-columns: 1fr;
  }

  .culture-dialog {
    width: 90% !important;
  }
}
</style>
