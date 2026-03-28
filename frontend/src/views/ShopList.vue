<template>
  <div class="shop-list-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/knowledge')">汉服知识库</li>
          <li class="nav-item" @click="$router.push('/culture')">传统文化学习</li>
          <li class="nav-item" @click="$router.push('/activity')">汉服活动召集</li>
          <li class="nav-item active">汉服店铺测评</li>
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
        <!-- 页面标题区域 - 上下排布 -->
        <div class="page-header-vertical">
          <!-- 返回按钮在上方 -->
          <el-button type="text" @click="$router.back()" class="back-btn-vertical">
            <el-icon><ArrowLeft /></el-icon> 返回
          </el-button>
          <!-- 页面标题在下方 -->
          <h2 class="page-title-vertical">所有店铺</h2>
        </div>

        <!-- 搜索和筛选区域 -->
        <div class="filter-section">
          <div class="search-box">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索店铺名称"
              clearable
              @input="handleSearch"
              @clear="handleSearch"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
          </div>

          <div class="filter-row">
            <div class="filter-item">
              <span class="filter-label">价格区间：</span>
              <el-select
                v-model="selectedPriceRange"
                placeholder="选择价格区间"
                clearable
                @change="handleFilter"
              >
                <el-option label="普通档（0-400）" value="普通档（0-400）" />
                <el-option label="中档（400-700）" value="中档（400-700）" />
                <el-option label="中高档（700-1000）" value="中高档（700-1000）" />
                <el-option label="高档（1000以上）" value="高档（1000以上）" />
              </el-select>
            </div>

            <div class="filter-item">
              <span class="filter-label">排序：</span>
              <el-select v-model="sortBy" placeholder="选择排序方式" @change="handleSort">
                <el-option label="评分从高到低" value="rating_desc" />
                <el-option label="评分从低到高" value="rating_asc" />
              </el-select>
            </div>
          </div>
        </div>

        <!-- 店铺总数 -->
        <div class="total-count">共 {{ filteredShops.length }} 家店铺</div>

        <!-- 店铺列表 -->
        <div class="shop-list">
          <div
            class="shop-item"
            v-for="shop in currentPageShops"
            :key="shop.id"
            @click="viewShopDetail(shop)"
          >
            <div class="shop-item-img">
              <el-image
                :src="shop.image"
                :alt="shop.name"
                fit="cover"
                :preview-src-list="[shop.image]"
              />
            </div>
            <div class="shop-item-info">
              <div class="shop-item-header">
                <h3 class="shop-item-name">{{ shop.name }}</h3>
                <div class="shop-item-rating">
                  <el-rate
                    v-model="shop.rating"
                    disabled
                    show-score
                    :score-template="`${shop.rating.toFixed(1)}`"
                    text-color="#ff9900"
                  />
                </div>
              </div>

              <p class="shop-item-desc">{{ shop.description.split("。")[0] + "。" }}</p>

              <div class="shop-item-meta">
                <div class="meta-item">
                  <el-icon><Location /></el-icon>
                  <span>{{ shop.location }}</span>
                </div>

                <div class="meta-item">
                  <el-icon><PriceTag /></el-icon>
                  <span>价格区间：{{ formatPriceRange(shop.priceRange) }}</span>
                </div>
              </div>

              <div class="shop-item-actions">
                <el-button type="primary" size="small" @click.stop="viewShopDetail(shop)">
                  查看详情
                </el-button>
                <el-button type="success" size="small" @click.stop="goToEvaluation(shop)">
                  我要评价
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-section" v-if="filteredShops.length > pageSize">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :page-sizes="[6, 12]"
            :total="filteredShops.length"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>

        <!-- 无结果提示 -->
        <div class="no-result" v-if="filteredShops.length === 0">
          <el-empty description="未找到相关店铺" />
          <el-button type="primary" @click="resetFilters">重置筛选条件</el-button>
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
import { ArrowLeft, Search, Location, ShoppingBag, PriceTag } from "@element-plus/icons-vue";
import { getImageUrl } from "../utils/imageHelper.js";

const router = useRouter();
const username = ref("");

// 搜索和筛选相关 - 确保初始值为空字符串而不是undefined
const searchKeyword = ref("");
const selectedPriceRange = ref(""); // 价格区间筛选
const sortBy = ref("rating_desc");

// 分页相关
const currentPage = ref(1);
const pageSize = ref(6);

// 店铺数据 - 从数据库加载
const allShops = ref([]);

// 计算属性：过滤后的店铺
const filteredShops = computed(() => {
  let result = [...allShops.value];

  // 关键词搜索
  if (searchKeyword.value) {
    const keyword = searchKeyword.value.toLowerCase();
    result = result.filter((shop) => shop.name.toLowerCase().includes(keyword));
  }

  // 价格区间筛选
  if (selectedPriceRange.value) {
    result = result.filter((shop) => shop.priceRange === selectedPriceRange.value);
  }

  // 排序
  if (sortBy.value) {
    switch (sortBy.value) {
      case "rating_desc":
        result.sort((a, b) => b.rating - a.rating);
        break;
      case "rating_asc":
        result.sort((a, b) => a.rating - b.rating);
        break;
      case "name":
        result.sort((a, b) => a.name.localeCompare(b.name, "zh-CN"));
        break;
    }
  }

  return result;
});

// 计算属性：当前页显示的店铺
const currentPageShops = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return filteredShops.value.slice(start, end);
});

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }

  // 加载店铺数据
  await loadShops();
});

// 加载店铺数据
const loadShops = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/shops");
    if (response.ok) {
      const data = await response.json();
      allShops.value = data.map((shop) => ({
        id: shop.id,
        name: shop.name,
        image: getImageUrl(shop.image),
        rating: shop.averageRating || 0,
        description: shop.description,
        tags: ["汉服店铺"], // 默认标签，可以后续扩展
        location: shop.address ? shop.address.split("市")[0] + "市" : "未知",
        mainBusiness: shop.mainBusiness || "汉服销售与定制",
        priceRange: shop.priceRange || "中档",
      }));
    }
  } catch (error) {
    console.error("加载店铺数据失败:", error);
    ElMessage.error("加载店铺数据失败");
  }
};

// 标签类型 - 简化，所有风格标签都使用primary类型
const getTagType = () => {
  return "primary";
};

// 格式化价格区间
const formatPriceRange = (priceRange) => {
  const priceMap = {
    普通档: "普通档（0-400）",
    中档: "中档（400-700）",
    中高档: "中高档（700-1000）",
    高档: "高档（1000以上）",
  };
  return priceMap[priceRange] || priceRange;
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
};

// 筛选处理
const handleFilter = () => {
  currentPage.value = 1;
};

// 排序处理
const handleSort = () => {
  currentPage.value = 1;
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  currentPage.value = 1;
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
};

// 重置筛选条件
const resetFilters = () => {
  searchKeyword.value = "";
  selectedPriceRange.value = "";
  sortBy.value = "rating_desc";
  currentPage.value = 1;
};

const viewShopDetail = (shop) => {
  router.push(`/shop-detail/${shop.id}`);
};

// 前往评价页面
const goToEvaluation = (shop) => {
  router.push(`/shop-evaluation-form/${shop.id}`);
};

// 个人中心跳转
const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

// 退出登录
const logout = () => {
  localStorage.removeItem("isLoggedIn");
  localStorage.removeItem("username");
  localStorage.removeItem("role");
  ElMessage.success("退出登录成功");
  router.push("/login");
};
</script>

<style scoped>
.shop-list-container {
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

/* 页面标题区域 - 上下排布 */
.page-header-vertical {
  display: flex;
  flex-direction: column;
  margin-bottom: 24px;
  gap: 12px;
}

.back-btn-vertical {
  color: #8b4513;
  padding: 0;
  font-size: 14px;
  display: flex;
  align-items: center;
  align-self: flex-start;
  margin-bottom: 8px;
}

.page-title-vertical {
  font-size: 28px;
  margin: 0;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
  width: 100%;
}

/* 筛选区域 */
.filter-section {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.search-box {
  margin-bottom: 20px;
}

.filter-row {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-label {
  color: #666;
  font-size: 14px;
  white-space: nowrap;
}

/* 确保选择框显示正常 */
:deep(.el-select__wrapper) {
  min-width: 140px;
}

:deep(.el-select .el-input__wrapper) {
  background-color: #fff;
}

/* 多选样式调整 */
:deep(.el-select__tags) {
  flex-wrap: nowrap;
  max-width: 200px;
}

/* 店铺总数 */
.total-count {
  color: #666;
  font-size: 14px;
  margin-bottom: 16px;
  padding-left: 4px;
}

/* 店铺列表 */
.shop-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.shop-item {
  display: flex;
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  cursor: pointer;
}

.shop-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
}

.shop-item-img {
  width: 250px;
  height: 180px;
  flex-shrink: 0;
  background-color: #f0f0f0;
}

.shop-item-info {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.shop-item-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.shop-item-name {
  margin: 0;
  color: #8b4513;
  font-size: 20px;
  font-weight: bold;
}

.shop-item-rating {
  display: flex;
  align-items: center;
  gap: 8px;
}

.review-count {
  font-size: 12px;
  color: #999;
}

.shop-item-desc {
  margin: 0 0 12px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.5;
  flex: 1;
}

.shop-item-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 12px;
}

.shop-item-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  margin-bottom: 16px;
  font-size: 13px;
  color: #666;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

.shop-item-actions {
  display: flex;
  gap: 10px;
}

/* 修改按钮颜色为渐变效果 */
.shop-item-actions .el-button--primary {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: transparent;
  color: white;
}

.shop-item-actions .el-button--primary:hover {
  background: linear-gradient(135deg, #d2691e 0%, #8b4513 100%);
  border-color: transparent;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

.shop-item-actions .el-button--primary:active {
  background: linear-gradient(135deg, #7a3d10 0%, #c15a18 100%);
  transform: translateY(0);
}

.shop-item-actions .el-button--success {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: transparent;
  color: white;
}

.shop-item-actions .el-button--success:hover {
  background: linear-gradient(135deg, #d2691e 0%, #8b4513 100%);
  border-color: transparent;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

.shop-item-actions .el-button--success:active {
  background: linear-gradient(135deg, #7a3d10 0%, #c15a18 100%);
  transform: translateY(0);
}

/* 分页 */
.pagination-section {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}

/* 无结果提示 */
.no-result {
  text-align: center;
  padding: 40px 0;
}

/* 无结果提示区域的按钮也保持相同风格 */
.no-result .el-button--primary {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: transparent;
  color: white;
}

.no-result .el-button--primary:hover {
  background: linear-gradient(135deg, #d2691e 0%, #8b4513 100%);
  border-color: transparent;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

/* 页脚 */
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
  .shop-item {
    flex-direction: column;
  }

  .shop-item-img {
    width: 100%;
    height: 200px;
  }

  .shop-item-header {
    flex-direction: column;
    gap: 8px;
  }

  .filter-row {
    flex-direction: column;
    gap: 12px;
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

  .shop-item-meta {
    flex-direction: column;
    gap: 8px;
  }

  /* 移动端调整标题区域 */
  .page-header-vertical {
    gap: 8px;
  }

  .page-title-vertical {
    font-size: 24px;
  }

  .back-btn-vertical {
    margin-bottom: 4px;
  }

  /* 移动端按钮样式微调 */
  .shop-item-actions {
    flex-direction: column;
  }

  .shop-item-actions .el-button {
    width: 100%;
    margin-bottom: 8px;
  }
}
</style>
