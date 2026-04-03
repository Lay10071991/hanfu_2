<template>
  <div class="shop-evaluation-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li
            class="nav-item"
            :class="{ active: $route.name === 'Home' }"
            @click="$router.push('/knowledge')"
          >
            汉服知识库
          </li>
          <li
            class="nav-item"
            :class="{ active: $route.name === 'Culture' }"
            @click="$router.push('/culture')"
          >
            传统文化学习
          </li>
          <li
            class="nav-item"
            :class="{ active: $route.name === 'Activity' }"
            @click="$router.push('/activity')"
          >
            汉服活动召集
          </li>
          <li
            class="nav-item"
            :class="{ active: $route.name === 'ShopEvaluation' }"
            @click="$router.push('/shop-evaluation')"
          >
            汉服店铺测评
          </li>
          <li
            class="nav-item"
            :class="{ active: $route.name === 'Community' }"
            @click="$router.push('/community')"
          >
            社区互动
          </li>
          <li
            class="nav-item"
            :class="{ active: $route.name === 'AiChat' }"
            @click="$router.push('/ai-chat')"
          >
            AI问答
          </li>
          <li
            class="nav-item"
            :class="{ active: $route.name === 'Profile' || $route.name === 'ShopProfile' }"
            @click="goToProfile"
          >
            个人中心
          </li>
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
        <h2 class="page-title">汉服店铺测评</h2>

        <!-- 提示信息 -->
        <div class="tip-section">
          <el-alert
            title="小tips: 请使用恰当的语言，恶意评价会被封号哦！"
            type="warning"
            :closable="false"
            show-icon
          />
        </div>

        <!-- 店铺列表 -->
        <div class="section">
          <div class="section-header">
            <h3 class="section-title">热门店铺</h3>
            <el-button type="primary" class="btn-top-right" @click="viewMoreShops">更多</el-button>
          </div>
          <div class="shop-grid">
            <div
              class="shop-card"
              v-for="shop in displayedShops"
              :key="shop.id"
              @click="viewShopDetail(shop)"
            >
              <div class="shop-img">
                <el-image :src="shop.image" :alt="shop.name" />
              </div>
              <div class="shop-info">
                <div class="shop-header-info">
                  <h4 class="shop-name">{{ shop.name }}</h4>
                  <div class="shop-rating">
                    <el-rate
                      v-model="shop.rating"
                      disabled
                      show-score
                      :score-template="`${shop.rating.toFixed(1)}`"
                      text-color="#ff9900"
                    />
                  </div>
                </div>
                <div class="shop-description-section">
                  <p class="description-content">{{ shop.description }}</p>
                </div>
              </div>
            </div>
            <!-- 当没有店铺数据时显示 -->
            <div v-if="displayedShops.length === 0" class="no-shops">
              <p>暂无店铺数据</p>
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
import { ref, onMounted, computed } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { getImageUrl } from "../utils/imageHelper.js";

const router = useRouter();
const username = ref("");

// 店铺数据 - 从数据库加载
const allShops = ref([]);

// 只显示前6个评分高的店铺
const displayedShops = computed(() => {
  return allShops.value.slice(0, 6);
});

// 加载店铺数据
const loadShops = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/shops");
    if (response.ok) {
      const data = await response.json();
      allShops.value = data
        .map((shop) => ({
          id: shop.id,
          name: shop.name,
          image: getImageUrl(shop.image),
          rating: shop.averageRating || 0,
          description: shop.description,
          address: shop.address,
          mainBusiness: shop.mainBusiness,
          priceRange: shop.priceRange,
          tags: ["汉服店铺"],
        }))
        .sort((a, b) => b.rating - a.rating); // 按评分从高到低排序
    }
  } catch (error) {
    console.error("加载店铺数据失败:", error);
    ElMessage.error("加载店铺数据失败");
  }
};

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  // 加载店铺数据
  loadShops();
});

// 跳转到店铺详情
const viewShopDetail = (shop) => {
  router.push({
    path: `/shop-detail/${shop.id}`,
    query: {
      from: "shop-evaluation",
    },
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

// 点击"更多"按钮跳转到店铺列表页面
const viewMoreShops = () => {
  router.push("/shop-list");
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
.shop-evaluation-container {
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
  overflow-x: auto;
}

.nav-item {
  margin: 0 15px;
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 4px;
  transition: background-color 0.3s;
  font-size: 14px;
  white-space: nowrap;
  flex-shrink: 0;
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

.tip-section {
  margin-bottom: 20px;
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

.btn-top-right:hover {
  background: linear-gradient(135deg, #d2691e 0%, #8b4513 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

/* 店铺网格布局 - 3列，每行3个 */
.shop-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.shop-card {
  border: none;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  background-color: white;
  display: flex;
  flex-direction: column;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  min-height: 420px;
}

.shop-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 30px rgba(139, 69, 19, 0.2);
}

.shop-img {
  width: 100%;
  height: 240px;
  background: linear-gradient(135deg, #f5f0e4 0%, #e8e0d0 100%);
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
}

.shop-img::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, transparent 60%, rgba(0, 0, 0, 0.1) 100%);
  z-index: 1;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.shop-card:hover .shop-img::before {
  opacity: 1;
}

.shop-img :deep(.el-image) {
  width: 100%;
  height: 100%;
  transition: transform 0.5s ease;
}

.shop-img :deep(.el-image__inner) {
  object-fit: cover;
  width: 100%;
  height: 100%;
}

.shop-card:hover .shop-img :deep(.el-image) {
  transform: scale(1.05);
}

.shop-info {
  padding: 16px;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  background: linear-gradient(to bottom, #ffffff 0%, #fdfcfa 100%);
}

.shop-header-info {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 10px;
  gap: 8px;
}

.shop-name {
  margin: 0;
  color: #5c3a1e;
  font-size: 17px;
  font-weight: 600;
  word-wrap: break-word;
  line-height: 1.4;
  flex: 1;
  letter-spacing: 0.5px;
}

.shop-rating {
  display: flex;
  align-items: center;
  gap: 4px;
  white-space: nowrap;
  flex-shrink: 0;
  transform: scale(0.85);
  transform-origin: right top;
  background: rgba(255, 193, 7, 0.15);
  padding: 2px 8px;
  border-radius: 12px;
}

.review-count {
  font-size: 12px;
  color: #999;
}

/* 店铺介绍部分 */
.shop-description-section {
  margin-top: 8px;
  flex-grow: 1;
  position: relative;
}

.description-title {
  margin: 0 0 8px 0;
  color: #8b4513;
  font-size: 14px;
  font-weight: bold;
}

.description-content {
  margin: 0;
  color: #666;
  line-height: 1.6;
  font-size: 13px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  text-align: justify;
}

.no-shops {
  grid-column: 1 / -1;
  text-align: center;
  padding: 40px 0;
  color: #999;
  font-size: 16px;
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

@media (max-width: 1024px) {
  .shop-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
  }
}

@media (max-width: 768px) {
  .shop-grid {
    grid-template-columns: 1fr;
    gap: 16px;
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

  .shop-img {
    height: 200px;
  }

  .shop-info {
    padding: 14px;
  }

  .shop-name {
    font-size: 16px;
  }

  .description-content {
    -webkit-line-clamp: 2;
    line-clamp: 2;
  }
}

@media (max-width: 480px) {
  .container {
    padding: 0 15px;
  }

  .section {
    padding: 15px;
  }

  .page-title {
    font-size: 24px;
  }

  .section-title {
    font-size: 18px;
  }
}
</style>
