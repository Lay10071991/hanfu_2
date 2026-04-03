<template>
  <div class="etiquette-detail-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo" @click="$router.push('/knowledge')">汉服文化交流平台</div>
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
        <div class="page-header">
          <el-button type="text" @click="$router.push('/culture')" class="back-btn">
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
          <h2 class="page-title">古代礼容仪态</h2>
        </div>

        <!-- 礼容仪态分类 -->
        <div class="category-section">
          <div class="category-tabs">
            <el-tabs v-model="activeCategory" @tab-click="handleCategoryChange">
              <el-tab-pane label="全部礼仪" name="all"></el-tab-pane>
              <el-tab-pane label="站立礼仪" name="standing"></el-tab-pane>
              <el-tab-pane label="行走礼仪" name="walking"></el-tab-pane>
              <el-tab-pane label="坐姿礼仪" name="sitting"></el-tab-pane>
              <el-tab-pane label="拜礼" name="worship"></el-tab-pane>
            </el-tabs>
          </div>

          <!-- 礼仪列表 -->
          <div class="etiquette-list">
            <div class="etiquette-item" v-for="item in paginatedEtiquettes" :key="item.id">
              <div class="etiquette-image">
                <el-image :src="item.image" :alt="item.name" fit="cover">
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
                <div class="etiquette-period">{{ item.period }}</div>
              </div>
              <div class="etiquette-content">
                <h3 class="etiquette-name">{{ item.name }}</h3>
                <p class="etiquette-description">{{ item.description }}</p>
                <div class="etiquette-actions">
                  <el-button
                    type="primary"
                    size="small"
                    @click.stop="viewEtiquetteDetail(item)"
                    class="detail-btn"
                  >
                    学习详细
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-container">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :page-sizes="[6, 12]"
            :total="totalItems"
            layout="total, prev, pager, next, jumper"
            @current-change="handleCurrentChange"
          />
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

    <!-- 礼仪详情弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentEtiquette.name"
      width="60%"
      :before-close="handleClose"
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
          <el-button @click="dialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, reactive } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { ArrowLeft, Picture } from "@element-plus/icons-vue";
import { getImageUrl } from "../utils/imageHelper.js";

const router = useRouter();
const username = ref("");
const dialogVisible = ref(false);

// 分类和分页
const activeCategory = ref("all");
const currentPage = ref(1);
const pageSize = ref(6);
const totalItems = ref(0);

// 当前选中的礼仪
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

// 礼仪数据
const etiquettes = ref([]);

const loadEtiquettes = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/etiquette");
    if (response.ok) {
      const data = await response.json();
      etiquettes.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        period: item.period,
        category: item.category,
        image: item.image
          ? getImageUrl(item.image)
          : `https://placehold.co/300x200/FFE4E1/000000?text=${item.name}`,
        description: item.description,
        features: item.features ? item.features.split("|") : [],
        steps: item.steps ? item.steps.split("|") : [],
        note: item.note || "",
      }));
    }
  } catch (error) {
    console.error("加载礼仪数据失败:", error);
  }
};

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  loadEtiquettes();
});

// 计算过滤后的礼仪（无副作用）
const filteredEtiquettes = computed(() => {
  let filtered = etiquettes.value;

  // 按分类过滤
  if (activeCategory.value !== "all") {
    filtered = filtered.filter((item) => item.category === activeCategory.value);
  }

  return filtered;
});

// 计算分页后的礼仪
const paginatedEtiquettes = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return filteredEtiquettes.value.slice(start, end);
});

// 监听过滤后的数据变化，更新总数
watch(
  filteredEtiquettes,
  (newFiltered) => {
    totalItems.value = newFiltered.length;
  },
  { immediate: true },
);

// 分类类型和文本
const getCategoryType = (category) => {
  const typeMap = {
    standing: "success",
    walking: "warning",
    sitting: "danger",
    worship: "info",
  };
  return typeMap[category] || "";
};

const getCategoryText = (category) => {
  const textMap = {
    standing: "站立礼仪",
    walking: "行走礼仪",
    sitting: "坐姿礼仪",
    worship: "拜礼",
  };
  return textMap[category] || "";
};

// 查看礼仪详情
const viewEtiquetteDetail = (item) => {
  Object.assign(currentEtiquette, item);
  dialogVisible.value = true;
};

// 关闭弹窗
const handleClose = (done) => {
  done();
};

const handleCategoryChange = () => {
  currentPage.value = 1;
};

const handleSizeChange = (size) => {
  pageSize.value = size;
  currentPage.value = 1;
};

const handleCurrentChange = (page) => {
  currentPage.value = page;
};

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
  localStorage.removeItem("role");
  ElMessage.success("退出登录成功");
  router.push("/login");
};
</script>

<style scoped>
.etiquette-detail-container {
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

.page-header {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
}

.back-btn {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  color: #8b4513;
}

.page-title {
  font-size: 32px;
  margin-bottom: 10px;
  color: #8b4513;
}

.page-subtitle {
  color: #666;
  font-size: 16px;
}

.category-section {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.category-tabs {
  margin-bottom: 30px;
}

:deep(.el-tabs__header) {
  margin-bottom: 0;
}

:deep(.el-tabs__nav-wrap::after) {
  background-color: #e8e8e8;
}

:deep(.el-tabs__active-bar) {
  background-color: #8b4513;
}

:deep(.el-tabs__item) {
  font-size: 16px;
  color: #666;
}

:deep(.el-tabs__item.is-active) {
  color: #8b4513;
  font-weight: 600;
}

:deep(.el-tabs__item:hover) {
  color: #8b4513;
}

.etiquette-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 24px;
}

.etiquette-item {
  background: #fafafa;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #e8e8e8;
}

.etiquette-item:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 30px rgba(139, 69, 19, 0.15);
  background: white;
}

.etiquette-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.etiquette-period {
  position: absolute;
  top: 12px;
  right: 12px;
  background: rgba(139, 69, 19, 0.9);
  color: white;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.etiquette-content {
  padding: 20px;
}

.etiquette-name {
  font-size: 18px;
  font-weight: 600;
  color: #8b4513;
  margin-bottom: 10px;
}

.etiquette-description {
  color: #666;
  line-height: 1.6;
  margin-bottom: 15px;
  font-size: 14px;
  /* 修复 line-clamp 兼容性问题 */
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  /* 标准属性 */
  display: -moz-box;
  -moz-line-clamp: 2;
  -moz-box-orient: vertical;
  display: box;
  line-clamp: 2;
  box-orient: vertical;
}

/* 修改：按钮容器样式 */
.etiquette-actions {
  display: flex;
  justify-content: center;
  margin-top: 15px;
}

.detail-btn {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border: none;
  border-radius: 8px;
  color: white;
  font-weight: 500;
  transition: all 0.3s ease;
  width: 100%;
  height: 22px;
  font-size: 14px;
  letter-spacing: 1px;
}

.detail-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(139, 69, 19, 0.4);
  background: linear-gradient(135deg, #7a3c10 0%, #b85c17 100%);
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}

.footer {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  text-align: center;
  padding: 20px 0;
  margin-top: 40px;
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

/* 弹窗样式 */
.etiquette-dialog {
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

.detail-period {
  font-size: 14px;
  color: #8b4513;
  font-weight: 500;
  margin-bottom: 10px;
}

.detail-category {
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
.detail-note {
  margin-bottom: 20px;
}

.detail-steps h4,
.detail-note h4 {
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

  .page-header {
    text-align: center;
  }

  .back-btn {
    position: relative;
    margin-bottom: 15px;
    left: auto;
    transform: none;
  }

  .etiquette-list {
    grid-template-columns: 1fr;
    gap: 16px;
  }

  .category-section {
    padding: 20px;
  }

  .detail-header {
    flex-direction: column;
  }

  .detail-image {
    width: 100%;
    height: 200px;
  }

  .etiquette-dialog {
    width: 90% !important;
  }

  /* 移动端按钮样式调整 */
  .detail-btn {
    height: 44px;
    font-size: 17px;
  }
}
</style>
