<template>
  <div class="culture-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo" @click="$router.push('/')">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/knowledge')">汉服知识库</li>
          <li class="nav-item active">传统文化学习</li>
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
        <h2 class="page-title">传统文化学习</h2>

        <!-- 古代礼容仪态 -->
        <div class="section">
          <div class="section-header">
            <h3 class="section-title">古代礼容仪态</h3>
            <el-button type="primary" class="btn-top-right" @click="viewMore('etiquette')"
              >更多</el-button
            >
          </div>
          <div class="etiquette-grid">
            <div
              class="etiquette-item"
              v-for="item in displayedEtiquette"
              :key="item.id"
              @click="viewEtiquette(item)"
            >
              <div class="etiquette-image">
                <el-image :src="item.image" :alt="item.name" fit="cover">
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
              </div>
              <div class="etiquette-content">
                <h3 class="etiquette-name">{{ item.name }}</h3>
              </div>
            </div>
          </div>
        </div>

        <!-- 古代节俗礼仪 -->
        <div class="section">
          <div class="section-header">
            <h3 class="section-title">古代节俗礼仪</h3>
            <el-button type="primary" class="btn-top-right" @click="viewMore('festival')"
              >更多</el-button
            >
          </div>
          <div class="festival-grid">
            <div
              class="festival-card"
              v-for="item in displayedFestival"
              :key="item.id"
              @click="viewFestival(item)"
            >
              <div class="festival-image">
                <el-image :src="item.image" :alt="item.name" fit="cover">
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
              </div>
              <div class="festival-content">
                <h3 class="festival-name">{{ item.name }}</h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 礼仪详情对话框 -->
  <el-dialog
    v-model="showEtiquetteDialog"
    :title="currentEtiquette.name"
    width="60%"
    class="etiquette-dialog"
  >
    <div class="dialog-content">
      <div class="detail-header">
        <div class="detail-image">
          <el-image :src="currentEtiquette.image" :alt="currentEtiquette.name" fit="cover">
            <template #error>
              <div class="image-slot">
                <el-icon><Picture /></el-icon>
              </div>
            </template>
          </el-image>
        </div>
        <div class="detail-basic">
          <div class="detail-period">{{ currentEtiquette.period }}</div>
          <div class="detail-category">
            <el-tag :type="getCategoryType(currentEtiquette.category)" size="small">
              {{ getCategoryText(currentEtiquette.category) }}
            </el-tag>
          </div>
        </div>
      </div>

      <div class="detail-body">
        <h3 class="detail-title">礼仪介绍</h3>
        <p class="detail-description">{{ currentEtiquette.description }}</p>

        <div class="detail-steps" v-if="currentEtiquette.steps && currentEtiquette.steps.length">
          <h4>行礼步骤</h4>
          <div class="steps-list">
            <div class="step-item" v-for="(step, index) in currentEtiquette.steps" :key="index">
              <div class="step-number">{{ index + 1 }}</div>
              <div class="step-content">{{ step }}</div>
            </div>
          </div>
        </div>

        <div class="detail-note" v-if="currentEtiquette.note">
          <h4>注意事项</h4>
          <p>{{ currentEtiquette.note }}</p>
        </div>
      </div>
    </div>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showEtiquetteDialog = false">关闭</el-button>
      </span>
    </template>
  </el-dialog>

  <!-- 节日详情对话框 -->
  <el-dialog
    v-model="showFestivalDialog"
    :title="currentFestival.name"
    width="70%"
    class="festival-dialog"
  >
    <div class="dialog-content">
      <div class="detail-header">
        <div class="detail-image">
          <el-image :src="currentFestival.image" :alt="currentFestival.name" fit="cover">
            <template #error>
              <div class="image-slot">
                <el-icon><Picture /></el-icon>
              </div>
            </template>
          </el-image>
        </div>
        <div class="detail-basic">
          <div class="detail-date">{{ currentFestival.date }}</div>
          <div class="detail-season">
            <el-tag :type="getSeasonType(currentFestival.season)" size="small">
              {{ getSeasonText(currentFestival.season) }}
            </el-tag>
          </div>
        </div>
      </div>

      <div class="detail-body">
        <h3 class="detail-title">节俗介绍</h3>
        <p class="detail-description">{{ currentFestival.description }}</p>

        <div
          class="detail-customs"
          v-if="currentFestival.customs && currentFestival.customs.length"
        >
          <h4>传统习俗</h4>
          <div class="customs-list">
            <div
              class="custom-item"
              v-for="(custom, index) in currentFestival.customs"
              :key="index"
            >
              <div class="custom-icon">
                <el-icon><Star /></el-icon>
              </div>
              <div class="custom-content">
                <h5>{{ custom.title }}</h5>
                <p>{{ custom.description }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showFestivalDialog = false">关闭</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { Star, Picture } from "@element-plus/icons-vue";
import { getImageUrl } from "../utils/imageHelper.js";

const router = useRouter();
const username = ref("");
const etiquetteList = ref([]);
const festivalList = ref([]);
const maxDisplayCount = ref(6);
const showEtiquetteDialog = ref(false);
const showFestivalDialog = ref(false);
const selectedEtiquette = ref(null);
const selectedFestival = ref(null);

const currentEtiquette = reactive({
  id: null,
  name: "",
  period: "",
  category: "",
  image: "",
  description: "",
  features: [],
  steps: [],
  note: "",
});

const currentFestival = reactive({
  id: null,
  name: "",
  date: "",
  season: "",
  image: "",
  description: "",
  customs: [],
});

// 从后端加载礼仪数据
const loadEtiquette = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/etiquette");
    if (response.ok) {
      const data = await response.json();
      etiquetteList.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        period: item.period,
        img: getImageUrl(item.image),
        image: getImageUrl(item.image),
        category: item.category,
        description: item.description,
        steps: item.steps ? item.steps.split("|") : [],
        features: item.features ? item.features.split("|") : [],
        note: item.note,
      }));
    }
  } catch (error) {
    console.error("加载礼仪数据失败:", error);
  }
};

// 从后端加载节日数据
const loadFestival = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/festival");
    if (response.ok) {
      const data = await response.json();
      festivalList.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        description: item.description,
        img: getImageUrl(item.image),
        image: getImageUrl(item.image),
        date: item.date,
        season: item.season,
        customs: item.customs
          ? item.customs.split("|").map((custom) => {
              const [title, ...descParts] = custom.split(":");
              return {
                title: title.trim(),
                description: descParts.join(":").trim(),
              };
            })
          : [],
      }));
    }
  } catch (error) {
    console.error("加载节日数据失败:", error);
  }
};

// 计算显示的礼容仪态数据（固定显示6个）
const displayedEtiquette = computed(() => {
  return etiquetteList.value.slice(0, maxDisplayCount.value);
});

// 计算显示的节俗礼仪数据（固定显示6个）
const displayedFestival = computed(() => {
  return festivalList.value.slice(0, 6);
});

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  // 加载数据
  loadEtiquette();
  loadFestival();
});

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

const getCategoryType = (category) => {
  const typeMap = {
    worship: "primary",
    standing: "success",
  };
  return typeMap[category] || "";
};

const getCategoryText = (category) => {
  const textMap = {
    worship: "跪拜礼",
    standing: "站立礼",
  };
  return textMap[category] || "";
};

const getSeasonType = (season) => {
  const typeMap = {
    spring: "success",
    summer: "warning",
    autumn: "danger",
    winter: "info",
  };
  return typeMap[season] || "";
};

const getSeasonText = (season) => {
  const textMap = {
    spring: "春季",
    summer: "夏季",
    autumn: "秋季",
    winter: "冬季",
  };
  return textMap[season] || "";
};

const logout = () => {
  localStorage.removeItem("isLoggedIn");
  localStorage.removeItem("username");
  localStorage.removeItem("role");
  ElMessage.success("退出登录成功");
  router.push("/login");
};

// 查看礼仪详情
const viewEtiquette = (item) => {
  selectedEtiquette.value = item;
  Object.assign(currentEtiquette, {
    id: item.id,
    name: item.name,
    period: item.period,
    category: item.category,
    image: item.image,
    description: item.description,
    features: item.features || [],
    steps: item.steps || [],
    note: item.note || "",
  });
  showEtiquetteDialog.value = true;
};

// 查看节日详情
const viewFestival = (item) => {
  selectedFestival.value = item;
  Object.assign(currentFestival, {
    id: item.id,
    name: item.name,
    date: item.date,
    season: item.season,
    image: item.image,
    description: item.description,
    customs: item.customs || [],
  });
  showFestivalDialog.value = true;
};

// 查看更多
const viewMore = (type) => {
  if (type === "etiquette") {
    router.push("/etiquette-detail");
  } else if (type === "festival") {
    router.push("/festival-detail");
  }
};
</script>

<style scoped>
.culture-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f3e9 0%, #f5f0e4 100%);
}

/* 复用之前的头部和页脚样式 */
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
  cursor: pointer;
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

.page-title {
  font-size: 28px;
  margin-bottom: 20px;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

.section {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-title {
  font-size: 20px;
  color: #8b4513;
  margin: 0;
}

.btn-top-right {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border: none;
}

/* 修改网格布局为3列，显示两行共6个 */
.etiquette-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-top: 15px;
}

.festival-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-top: 15px;
}

/* 礼仪卡片样式 */
.etiquette-item {
  background: #fafafa;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #e8e8e8;
  text-align: center;
}

.etiquette-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
  background: white;
  border-color: #d4a76a;
}

.etiquette-image {
  width: 100%;
  height: 180px;
  overflow: hidden;
}

.etiquette-content {
  padding: 15px;
}

.etiquette-name {
  font-size: 16px;
  font-weight: 600;
  color: #8b4513;
  margin: 0;
}

/* 节日卡片样式 */
.festival-card {
  background: #fafafa;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #e8e8e8;
  text-align: center;
}

.festival-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
  background: white;
  border-color: #d4a76a;
}

.festival-image {
  width: 100%;
  height: 180px;
  overflow: hidden;
}

.festival-content {
  padding: 15px;
}

.festival-name {
  font-size: 16px;
  font-weight: 600;
  color: #8b4513;
  margin: 0;
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
@media (max-width: 1200px) {
  .etiquette-grid,
  .festival-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
  }
}

@media (max-width: 768px) {
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

  .etiquette-grid,
  .festival-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }
}

/* 弹窗样式 */
.etiquette-dialog,
.festival-dialog {
  border-radius: 12px;
}

.dialog-content {
  max-height: 70vh;
  overflow-y: auto;
  padding-right: 10px;
}

.detail-header {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  align-items: flex-start;
}

.detail-image {
  width: 200px;
  height: 150px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.detail-basic {
  flex: 1;
}

.detail-period,
.detail-date {
  font-size: 16px;
  color: #8b4513;
  font-weight: 500;
  margin-bottom: 10px;
}

.detail-category,
.detail-season {
  margin-bottom: 10px;
}

.detail-body {
  border-top: 1px solid #e8e8e8;
  padding-top: 20px;
}

.detail-title {
  font-size: 18px;
  color: #8b4513;
  margin-bottom: 15px;
}

.detail-description {
  line-height: 1.8;
  color: #666;
  margin-bottom: 20px;
}

.detail-steps,
.detail-note,
.detail-customs {
  margin-bottom: 20px;
}

.detail-steps h4,
.detail-note h4,
.detail-customs h4 {
  font-size: 16px;
  color: #8b4513;
  margin-bottom: 10px;
}

.steps-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.step-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px;
  background: #f9f5f0;
  border-radius: 6px;
  border-left: 3px solid #d4a76a;
}

.step-number {
  width: 24px;
  height: 24px;
  background: #8b4513;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: bold;
  flex-shrink: 0;
}

.step-content {
  flex: 1;
  color: #666;
  line-height: 1.6;
}

.customs-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.custom-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px;
  background: #f9f5f0;
  border-radius: 6px;
  border-left: 3px solid #d4a76a;
}

.custom-icon {
  width: 24px;
  height: 24px;
  background: #8b4513;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  flex-shrink: 0;
}

.custom-content {
  flex: 1;
}

.custom-content h5 {
  font-size: 14px;
  color: #8b4513;
  margin: 0 0 4px 0;
}

.custom-content p {
  font-size: 13px;
  color: #666;
  line-height: 1.5;
  margin: 0;
}

.detail-note p {
  padding: 12px;
  background: #f0f7ff;
  border-radius: 6px;
  border-left: 3px solid #409eff;
  color: #666;
  line-height: 1.6;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}

@media (max-width: 768px) {
  .detail-header {
    flex-direction: column;
  }

  .detail-image {
    width: 100%;
    height: 200px;
  }

  .etiquette-dialog,
  .festival-dialog {
    width: 90% !important;
  }
}
</style>
