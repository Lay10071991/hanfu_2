<template>
  <div class="festival-gathering-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/')">汉服知识库</li>
          <li class="nav-item" @click="$router.push('/culture')">传统文化学习</li>
          <li class="nav-item active">汉服活动召集</li>
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

        <!-- 页面标题 -->
        <h2 class="page-title">节庆雅集活动</h2>

        <!-- 搜索和筛选 -->
        <div class="filter-section">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索活动名称或内容"
            class="search-input"
            @keyup.enter="searchActivities"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>

          <el-select v-model="selectedSeason" placeholder="选择季节" @change="filterActivities">
            <el-option label="全部" value=""></el-option>
            <el-option label="春季" value="spring"></el-option>
            <el-option label="夏季" value="summer"></el-option>
            <el-option label="秋季" value="autumn"></el-option>
            <el-option label="冬季" value="winter"></el-option>
          </el-select>
        </div>

        <!-- 节庆雅集列表 -->
        <div class="festival-list">
          <div class="festival-card" v-for="festival in paginatedFestivals" :key="festival.id">
            <div class="festival-image">
              <el-image :src="festival.image" fit="cover" />
              <div class="festival-tag">
                <el-tag :type="getSeasonTagType(festival.season)" size="small">
                  {{ getSeasonName(festival.season) }}
                </el-tag>
              </div>
            </div>

            <div class="festival-content">
              <div class="festival-header">
                <h3>{{ festival.title }}</h3>
                <div class="festival-meta">
                  <span class="date">
                    <el-icon><Calendar /></el-icon>
                    {{ festival.date }}
                  </span>
                  <span class="location">
                    <el-icon><Location /></el-icon>
                    {{ festival.location }}
                  </span>
                </div>
              </div>

              <p class="festival-description">{{ festival.description }}</p>

              <div class="festival-actions">
                <el-button type="primary" size="small" @click="viewFestivalDetail(festival.id)">
                  <el-icon><View /></el-icon>
                  查看详情
                </el-button>
                <el-button
                  :type="
                    isActivityExpired(festival.date)
                      ? 'danger'
                      : isActivitySignedUp(festival.id)
                        ? 'warning'
                        : 'success'
                  "
                  :disabled="isActivityExpired(festival.date)"
                  size="small"
                  @click="
                    isActivitySignedUp(festival.id)
                      ? cancelSignUp(festival.id)
                      : signUpFestival(festival.id)
                  "
                >
                  <el-icon><Check /></el-icon>
                  {{
                    isActivityExpired(festival.date)
                      ? "活动结束"
                      : isActivitySignedUp(festival.id)
                        ? "取消报名"
                        : "立即报名"
                  }}
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-section" v-if="filteredFestivals.length > 0">
          <el-pagination
            v-model:current-page="currentPage"
            :page-size="6"
            layout="total, prev, pager, next, jumper"
            :total="filteredFestivals.length"
            @current-change="handleCurrentChange"
          />
        </div>

        <!-- 无数据提示 -->
        <div class="empty-state" v-if="paginatedFestivals.length === 0">
          <el-icon size="60px" color="#d4a76a"><DataAnalysis /></el-icon>
          <p>暂无相关活动</p>
          <el-button type="primary" @click="resetFilters"> 重置筛选条件 </el-button>
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
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import {
  ArrowLeft,
  Search,
  Calendar,
  Location,
  User,
  View,
  Check,
  DataAnalysis,
} from "@element-plus/icons-vue";

const router = useRouter();
const username = ref("");

// 搜索和筛选
const searchKeyword = ref("");
const selectedSeason = ref("");
const currentPage = ref(1);

// 节庆数据
const festivals = ref([]);

// 加载节庆活动数据
const loadFestivals = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/festival-activity");
    if (response.ok) {
      const data = await response.json();
      festivals.value = data;
    } else {
      console.error("加载节庆活动数据失败:", response.status);
    }
  } catch (error) {
    console.error("加载节庆活动数据出错:", error);
  }
};

// 计算属性：筛选后的节日（不分页，用于统计总数）
const filteredFestivals = computed(() => {
  let result = festivals.value;

  // 根据季节筛选
  if (selectedSeason.value) {
    result = result.filter((festival) => festival.season === selectedSeason.value);
  }

  // 根据关键词搜索
  if (searchKeyword.value) {
    const keyword = searchKeyword.value.toLowerCase();
    result = result.filter(
      (festival) =>
        festival.title.toLowerCase().includes(keyword) ||
        festival.description.toLowerCase().includes(keyword) ||
        festival.location.toLowerCase().includes(keyword),
    );
  }

  return result;
});

// 计算属性：分页后的节日（用于显示）
const paginatedFestivals = computed(() => {
  const start = (currentPage.value - 1) * 6;
  const end = start + 6;
  return filteredFestivals.value.slice(start, end);
});

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  // 加载节庆活动数据
  await loadFestivals();
});

// 方法
const getSeasonName = (season) => {
  const seasonMap = {
    spring: "春季",
    summer: "夏季",
    autumn: "秋季",
    winter: "冬季",
  };
  return seasonMap[season] || season;
};

const getSeasonTagType = (season) => {
  const typeMap = {
    spring: "success",
    summer: "warning",
    autumn: "info",
    winter: "",
  };
  return typeMap[season] || "";
};

// 检查活动是否已过期
const isActivityExpired = (dateStr) => {
  // 提取日期部分
  let dateStrClean = dateStr;
  // 处理"2024-02-24（农历正月十五）"格式
  if (dateStr.includes("（")) {
    dateStrClean = dateStr.split("（")[0];
  }
  // 处理"2026年2月12日"格式
  if (dateStr.includes("年")) {
    dateStrClean = dateStr.replace("年", "-").replace("月", "-").replace("日", "");
  }

  // 解析日期
  const activityDate = new Date(dateStrClean);
  const now = new Date();

  // 比较日期（只比较年月日，不比较时间）
  const activityDateOnly = new Date(
    activityDate.getFullYear(),
    activityDate.getMonth(),
    activityDate.getDate(),
  );
  const nowDateOnly = new Date(now.getFullYear(), now.getMonth(), now.getDate());

  return activityDateOnly < nowDateOnly;
};

// 已报名活动列表（响应式）
const signedUpActivities = ref(JSON.parse(localStorage.getItem("signedUpActivities") || "[]"));

// 检查活动是否已报名
const isActivitySignedUp = (id) => {
  return signedUpActivities.value.includes(id);
};

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

const searchActivities = () => {
  currentPage.value = 1;
};

const filterActivities = () => {
  currentPage.value = 1;
};

const viewFestivalDetail = (id) => {
  // 跳转到节庆活动详情页（对应图二的页面）
  router.push(`/festival-activity/${id}`);
  // 滚动到顶部
  setTimeout(() => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  }, 100);
};

const signUpFestival = (id) => {
  const festival = festivals.value.find((f) => f.id === id);
  if (festival) {
    // 检查活动是否已过期
    if (isActivityExpired(festival.date)) {
      ElMessage.info("活动已经结束，无法报名！");
      return;
    }

    // 检查用户是否已报名
    if (signedUpActivities.value.includes(id)) {
      ElMessage.info("您已经报名过此活动！");
      return;
    }

    // 保存到本地存储
    signedUpActivities.value.push(id);
    localStorage.setItem("signedUpActivities", JSON.stringify(signedUpActivities.value));

    ElMessage.success(`成功报名参加"${festival.title}"活动！`);
  }
};

// 取消报名
const cancelSignUp = (id) => {
  const festival = festivals.value.find((f) => f.id === id);
  if (festival) {
    // 检查活动是否已过期
    if (isActivityExpired(festival.date)) {
      ElMessage.info("活动已经结束，无法取消报名！");
      return;
    }

    // 从本地存储中移除
    const index = signedUpActivities.value.indexOf(id);
    if (index > -1) {
      signedUpActivities.value.splice(index, 1);
      localStorage.setItem("signedUpActivities", JSON.stringify(signedUpActivities.value));
      ElMessage.success(`成功取消报名"${festival.title}"活动！`);
    }
  }
};

const resetFilters = () => {
  searchKeyword.value = "";
  selectedSeason.value = "";
  currentPage.value = 1;
};

const handleCurrentChange = (page) => {
  currentPage.value = page;
};

const goBack = () => {
  router.back();
  // 滚动到顶部
  setTimeout(() => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  }, 100);
};

const logout = () => {
  localStorage.removeItem("isLoggedIn");
  localStorage.removeItem("username");
  localStorage.removeItem("role");
  ElMessage.success("退出登录成功");
  router.push("/login");
};
</script>

<style scoped>
.festival-gathering-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f3e9 0%, #f5f0e4 100%);
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

.nav-item:hover,
.nav-item.active {
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

.page-title {
  font-size: 28px;
  margin-bottom: 30px;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

.back-btn .el-icon,
.stat-item .el-icon,
.festival-meta .el-icon {
  vertical-align: middle;
}

.filter-section {
  display: flex;
  gap: 15px;
  margin-bottom: 30px;
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.search-input {
  flex: 1;
}

.search-input :deep(.el-input__prefix) {
  margin-right: 6px;
  padding: 0;
  border: none !important;
  box-shadow: none !important;
}

.search-input :deep(.el-input__prefix .el-icon) {
  color: #8b4513;
}

.filter-section .el-select {
  margin-left: 10px;
  min-width: 120px;
}
.festival-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.festival-card {
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  display: flex;
}

.festival-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
}

.festival-image {
  width: 200px;
  height: 250px;
  position: relative;
  flex-shrink: 0;
}

.festival-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.festival-tag {
  position: absolute;
  top: 10px;
  right: 10px;
}

.festival-content {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.festival-header {
  margin-bottom: 10px;
}

.festival-header h3 {
  margin: 0 0 10px 0;
  color: #8b4513;
  font-size: 20px;
}

.festival-meta {
  display: flex;
  gap: 15px;
  font-size: 12px;
  color: #666;
}

.festival-meta span {
  display: flex;
  align-items: center;
  gap: 5px;
}

.festival-description {
  flex: 1;
  margin: 10px 0;
  color: #555;
  font-size: 14px;
  line-height: 1.5;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  line-clamp: 3;
  box-orient: vertical;
}

.festival-stats {
  display: flex;
  gap: 20px;
  margin: 15px 0;
  font-size: 12px;
  color: #999;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 5px;
}

.festival-actions {
  display: flex;
  gap: 10px;
}

.festival-actions .el-button {
  display: flex;
  align-items: center;
  gap: 5px;
}

.festival-actions .el-button--primary,
.festival-actions .el-button--success {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%) !important;
  border: none !important;
}

.festival-actions .el-button--primary:hover,
.festival-actions .el-button--success:hover {
  opacity: 0.9 !important;
}

.festival-actions .el-button--info {
  background: #999999 !important;
  border: 1px solid #999999 !important;
  color: white !important;
}

.festival-actions .el-button--info:hover {
  background: #888888 !important;
  border-color: #888888 !important;
}

.pagination-section {
  display: flex;
  justify-content: center;
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.empty-state {
  background-color: white;
  border-radius: 8px;
  padding: 60px 20px;
  text-align: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.empty-state .el-icon {
  margin-bottom: 20px;
}

.empty-state p {
  color: #666;
  margin-bottom: 20px;
}

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

@media (max-width: 768px) {
  .festival-list {
    grid-template-columns: 1fr;
  }

  .festival-card {
    flex-direction: column;
  }

  .festival-image {
    width: 100%;
    height: 200px;
  }

  .filter-section {
    flex-direction: column;
  }
}
</style>
