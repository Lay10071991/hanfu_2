<template>
  <div class="pattern-symbolism-container">
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
          <el-button type="text" @click="goBack" class="back-btn">
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
        </div>

        <h2 class="page-title">图案象征</h2>

        <!-- 图案列表 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><PictureFilled /></el-icon>
            图案列表
          </h3>
          <div class="patterns-grid">
            <div
              class="pattern-card"
              v-for="pattern in patterns"
              :key="pattern.id"
              :data-pattern-id="pattern.id"
              @click="viewPatternDetail(pattern)"
            >
              <div class="pattern-image">
                <el-image :src="pattern.img" :alt="pattern.name" fit="cover" class="pattern-img">
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
              </div>
              <div class="pattern-content">
                <div class="pattern-header">
                  <h4 class="pattern-name">{{ pattern.name }}</h4>
                </div>
                <p class="pattern-meaning">{{ pattern.meaning }}</p>
                <div class="pattern-details">
                  <div class="detail-item">
                    <span class="detail-label">象征意义：</span>
                    <span class="detail-value">{{ pattern.symbolism }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">常见应用：</span>
                    <span class="detail-value">{{ pattern.application }}</span>
                  </div>
                </div>
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
import { ref, computed, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { ElMessage } from "element-plus";
import { ArrowLeft, PictureFilled, Picture } from "@element-plus/icons-vue";
import { getImageUrl } from "../utils/imageHelper.js";

const router = useRouter();
const route = useRoute();
const username = ref("汉服爱好者");

// 图案数据
const patterns = ref([]);

// 从后端加载图案数据
const loadPatterns = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/pattern-symbol");
    if (response.ok) {
      const data = await response.json();
      patterns.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        meaning: item.meaning,
        symbolism: item.meaning, // 使用meaning作为symbolism
        application: "衣缘、裙摆、配饰", // 默认应用场景
        img: getImageUrl(item.image),
        description: item.description,
      }));
    }
  } catch (error) {
    console.error("加载图案数据失败:", error);
    ElMessage.error("加载图案数据失败");
  }
};

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  await loadPatterns();
  // 检查是否有 query 参数 patternId，如果有则滚动到对应图案
  const patternId = route.query.patternId;
  if (patternId) {
    scrollToPattern(Number(patternId));
  }
  window.scrollTo(0, 0);
});

// 滚动到指定图案
const scrollToPattern = (patternId) => {
  // 等待 DOM 更新
  setTimeout(() => {
    const patternElement = document.querySelector(`[data-pattern-id="${patternId}"]`);
    if (patternElement) {
      patternElement.scrollIntoView({ behavior: "smooth", block: "center" });
      // 高亮显示
      patternElement.classList.add("highlight-pattern");
      setTimeout(() => {
        patternElement.classList.remove("highlight-pattern");
      }, 1000);
    }
  }, 100);
};

// 查看图案详情
const viewPatternDetail = (pattern) => {
  router.push({
    name: "PatternSymbolismDetail",
    params: { id: pattern.id },
  });
};

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

const goBack = () => {
  router.push("/knowledge");
  // 滚动到图案象征部分
  setTimeout(() => {
    const patternSymbolSection = document.querySelector(".pattern-symbolism-section");
    if (patternSymbolSection) {
      patternSymbolSection.scrollIntoView({ behavior: "smooth" });
    } else {
      // 如果找不到图案象征部分，滚动到页面顶部
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }, 100);
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
.pattern-symbolism-container {
  min-height: 100vh;
  background-color: #fef9f3; /* 修改为柔和的米白色背景 */
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
.overview-content p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 15px;
  text-align: justify;
}

/* 图案列表样式 */
.patterns-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
}

.pattern-card {
  display: flex;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  overflow: hidden;
  background-color: white;
  cursor: pointer;
  transition: all 0.3s ease;
}

.pattern-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 15px rgba(139, 69, 19, 0.15);
  border-color: #d4a76a;
}

.pattern-image {
  flex: 0 0 120px;
  height: 120px;
  background-color: #f5f5f5;
}

.pattern-img {
  width: 100%;
  height: 100%;
  display: block;
}

.pattern-content {
  flex: 1;
  padding: 15px;
  display: flex;
  flex-direction: column;
}

.pattern-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
}

.pattern-name {
  margin: 0;
  color: #8b4513;
  font-size: 16px;
}

.pattern-meaning {
  margin: 0 0 10px 0;
  color: #d2691e;
  font-weight: 500;
  font-size: 14px;
}

.pattern-details {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-top: auto;
}

.detail-item {
  display: flex;
  align-items: flex-start;
}

.detail-label {
  font-size: 11px;
  color: #999;
  min-width: 60px;
}

.detail-value {
  font-size: 11px;
  color: #666;
  flex: 1;
  line-height: 1.4;
}

/* 文化内涵样式 */
.culture-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.culture-item {
  padding: 15px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  background: linear-gradient(135deg, #f9f5f0 0%, #f0e6d6 100%);
}

.culture-item h4 {
  margin: 0 0 10px 0;
  color: #8b4513;
  font-size: 16px;
  border-bottom: 1px solid #d4a76a;
  padding-bottom: 5px;
}

.culture-item p {
  margin: 0;
  color: #666;
  line-height: 1.6;
  font-size: 14px;
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

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .patterns-grid {
    grid-template-columns: 1fr;
  }

  .pattern-categories {
    grid-template-columns: repeat(2, 1fr);
  }

  .culture-content {
    grid-template-columns: 1fr;
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

  .pattern-card {
    flex-direction: column;
  }

  .pattern-image {
    flex: none;
    width: 100%;
    height: 150px;
  }
}

@media (max-width: 480px) {
  .pattern-categories {
    grid-template-columns: 1fr;
  }
}

/* 高亮样式 */
.highlight-pattern {
  animation: highlight-pulse 3s ease-in-out;
  border: 2px solid #d4a76a !important;
  box-shadow: 0 0 20px rgba(212, 167, 106, 0.6) !important;
}

@keyframes highlight-pulse {
  0% {
    transform: scale(1);
    box-shadow: 0 0 20px rgba(212, 167, 106, 0.6);
  }
  50% {
    transform: scale(1.02);
    box-shadow: 0 0 30px rgba(212, 167, 106, 0.8);
  }
  100% {
    transform: scale(1);
    box-shadow: 0 0 20px rgba(212, 167, 106, 0.6);
  }
}
</style>
