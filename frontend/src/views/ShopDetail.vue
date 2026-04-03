<!-- ShopDetail.vue -->
<template>
  <div class="shop-detail-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="goToHome">汉服知识库</li>
          <li class="nav-item" @click="goToCulture">传统文化学习</li>
          <li class="nav-item" @click="goToActivity">汉服活动召集</li>
          <li class="nav-item active" @click="goToShopList">汉服店铺测评</li>
          <li class="nav-item" @click="goToCommunity">社区互动</li>
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
    <div class="main-content" v-if="shop && shop.id">
      <div class="container">
        <!-- 页面标题区域 -->
        <div class="page-header">
          <el-button type="text" @click="goBack" class="back-btn">
            <el-icon><ArrowLeft /></el-icon> 返回
          </el-button>
          <h2 class="page-title">{{ shop.name }}</h2>
        </div>

        <!-- 店铺基本信息 -->
        <div class="shop-basic-info">
          <div class="shop-header">
            <div class="shop-image">
              <el-image
                :src="shop.image"
                :alt="shop.name"
                fit="cover"
                class="main-image"
                :preview-src-list="[shop.image]"
              />
            </div>
            <div class="shop-summary">
              <div class="summary-header">
                <h3 class="shop-name">{{ shop.name }}</h3>
                <div class="shop-rating">
                  <el-rate
                    v-model="calculatedRating"
                    disabled
                    show-score
                    :score-template="`${calculatedRating.toFixed(1)}`"
                    text-color="#ff9900"
                  />
                </div>
              </div>

              <div class="summary-meta">
                <div class="meta-item">
                  <el-icon><Location /></el-icon>
                  <span>{{ shop.location }}</span>
                </div>

                <div class="meta-item">
                  <el-icon><PriceTag /></el-icon>
                  <span>价格区间：{{ formatPriceRange(shop.priceRange) }}</span>
                </div>
              </div>

              <!-- 店铺介绍移动到这里 -->
              <div class="shop-description-section">
                <h3 class="description-title">店铺介绍</h3>
                <p class="description-content">{{ shop.description }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 店铺详细信息 -->
        <div class="shop-details">
          <!-- 汉服展示 -->
          <div class="detail-section">
            <h3>汉服展示</h3>
            <div class="hanfu-display">
              <div class="image-grid">
                <div
                  v-for="(image, index) in hanfuImages.slice(0, 9)"
                  :key="index"
                  class="image-item"
                  @click="previewImage(index)"
                >
                  <img :src="image" class="display-image" />
                </div>
              </div>
            </div>
          </div>

          <!-- 服务项目 -->
          <div class="detail-section">
            <h3>服务项目</h3>
            <div class="service-list">
              <el-tag v-for="service in services" :key="service" type="success" size="large">
                {{ service }}
              </el-tag>
            </div>
          </div>

          <!-- 店铺评价 -->
          <div class="detail-section">
            <div class="section-header">
              <h3>用户评价</h3>
              <div class="review-actions">
                <el-button
                  type="primary"
                  size="small"
                  @click="goToEvaluation"
                  class="add-review-btn"
                >
                  我要评价
                </el-button>
              </div>
            </div>

            <!-- 评价统计 -->
            <div class="rating-stats">
              <div class="overall-rating">
                <div class="rating-number">{{ calculatedRating.toFixed(1) }}</div>
                <div class="rating-text">综合评分</div>
              </div>
              <div class="rating-bars">
                <div v-for="rating in [5, 4, 3, 2, 1]" :key="rating" class="rating-bar-item">
                  <span class="rating-label">{{ rating }}星</span>
                  <div class="rating-progress">
                    <el-progress
                      :percentage="getRatingPercentage(rating)"
                      :show-text="false"
                      :stroke-width="12"
                      color="#d2691e"
                    />
                    <span class="rating-count">{{ getRatingCount(rating) }}人</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 评价列表 -->
            <div class="review-list">
              <div v-for="review in displayedReviews" :key="review.id" class="review-item">
                <div class="review-header">
                  <div class="reviewer-info">
                    <div class="reviewer-details">
                      <div class="reviewer-name">{{ review.name }}</div>
                    </div>
                  </div>
                  <div class="review-rating">
                    <el-rate v-model="review.rating" disabled size="small" />
                  </div>
                </div>
                <div class="review-content">
                  {{ review.content }}
                </div>
              </div>
            </div>

            <!-- 更多评价按钮 -->
            <div class="review-more-btn" v-if="displayedReviews.length > 0">
              <el-button
                type="text"
                size="small"
                @click="toggleShowAllReviews"
                class="more-review-btn"
              >
                {{ showAllReviews ? "收起" : "更多" }}
              </el-button>
            </div>
          </div>

          <!-- 联系信息 -->
          <div class="detail-section contact-info">
            <h3>联系信息</h3>
            <div class="contact-items">
              <div class="contact-item">
                <el-icon><Location /></el-icon>
                <span>地址：{{ contact.address }}</span>
              </div>
              <div class="contact-item">
                <el-icon><Phone /></el-icon>
                <span>电话：{{ contact.phone }}</span>
              </div>
              <div class="contact-item">
                <el-icon><Message /></el-icon>
                <span>微信：{{ contact.wechat }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 加载状态 -->
    <div class="loading" v-else>
      <el-empty description="加载中..." />
    </div>

    <!-- 图片预览 -->
    <el-image-viewer
      v-if="previewVisible"
      :url-list="hanfuImages"
      :initial-index="previewIndex"
      @close="previewVisible = false"
    />

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
import { ref, computed, onMounted, watch } from "vue";
import { useRouter, useRoute } from "vue-router";
import { ElMessage } from "element-plus";
import {
  ArrowLeft,
  Location,
  ShoppingBag,
  PriceTag,
  Phone,
  Message,
} from "@element-plus/icons-vue";
import { getImageUrl } from "../utils/imageHelper.js";

const router = useRouter();
const route = useRoute();
const username = ref("");
const shop = ref({});
const shopImages = ref([]);
const shopServices = ref([]);
const shopRatingDistribution = ref(null);
const previewVisible = ref(false);
console.log("初始shopServices:", shopServices.value);
const previewIndex = ref(0);
const showAllReviews = ref(false); // 控制是否显示所有评价

// 从后端加载店铺数据
const loadShop = async (shopId) => {
  try {
    const response = await fetch(`http://localhost:8082/api/shops/${shopId}`);
    if (response.ok) {
      const data = await response.json();
      shop.value = {
        id: data.id,
        name: data.name,
        image: getImageUrl(data.image),
        rating: data.averageRating || 0,
        description: data.description || "暂无店铺介绍",
        tags: data.tags ? data.tags.split(",") : ["汉服店铺"],
        location: data.address
          ? data.address.includes("市")
            ? data.address.split("市")[0] + "市"
            : data.address
          : "未知",
        mainBusiness: data.mainBusiness || "汉服销售与定制",
        priceRange: data.priceRange || "中档",
        address: data.address || "暂无地址信息",
        contact: data.contact || "暂无联系方式",
        hanfuImages: data.hanfuImages || [],
      };

      // 加载店铺图片
      await loadShopImages(shopId);

      // 加载店铺服务
      await loadShopServices(shopId);
    } else if (response.status === 404) {
      ElMessage.error("店铺不存在");
      router.push("/shop-list");
    } else {
      throw new Error("加载失败");
    }
  } catch (error) {
    console.error("加载店铺数据失败:", error);
    ElMessage.error("加载店铺数据失败");
    router.push("/shop-list");
  }
};

// 从后端加载店铺图片
const loadShopImages = async (shopId) => {
  try {
    console.log(`开始加载店铺${shopId}的图片...`);
    const response = await fetch(`http://localhost:8082/api/shop-shows/shop/${shopId}/images`);
    console.log(`API响应状态:`, response.status);
    if (response.ok) {
      const imageUrls = await response.json();
      console.log(`从API获取的图片URL (${imageUrls?.length || 0}张):`, imageUrls);
      if (imageUrls && imageUrls.length > 0) {
        // 添加时间戳防止缓存
        const timestamp = new Date().getTime();
        shopImages.value = imageUrls.map((imageUrl, index) => ({
          url: getImageUrl(imageUrl) + `?t=${timestamp}`,
          description: `汉服展示 ${index + 1}`,
        }));
        console.log("设置后的shopImages:", shopImages.value);
      } else {
        console.warn(`店铺${shopId}没有图片数据，使用默认图片`);
        setDefaultImages();
      }
    } else {
      console.error(`API请求失败，状态码: ${response.status}`);
      setDefaultImages();
    }
  } catch (error) {
    console.error("加载店铺图片失败:", error);
    setDefaultImages();
  }
};

const setDefaultImages = () => {
  shopImages.value = [
    { url: "/shop-hanfu/q (1).png", description: "传统礼服系列" },
    { url: "/shop-hanfu/q (2).png", description: "日常汉服系列" },
    { url: "/shop-hanfu/q (3).png", description: "婚庆特别款" },
    { url: "/shop-hanfu/q (4).png", description: "手工刺绣款" },
    { url: "/shop-hanfu/q (5).png", description: "改良设计款" },
  ];
};

// 从后端加载店铺服务
const loadShopServices = async (shopId) => {
  console.log("开始加载店铺服务，店铺ID:", shopId);
  try {
    const response = await fetch(`http://localhost:8082/api/shop-services/shop/${shopId}`);
    console.log("服务请求响应状态:", response.status);
    if (response.ok) {
      const data = await response.json();
      console.log("从后端获取的服务数据:", data);
      shopServices.value = data.map((service) => service.serviceName);
      console.log("设置后的shopServices:", shopServices.value);
    } else {
      console.log("后端服务不可用，使用默认服务");
      // 根据店铺ID设置不同的服务项目
      setShopServicesByShopId(shopId);
    }
  } catch (error) {
    console.error("加载店铺服务失败:", error);
    // 根据店铺ID设置不同的服务项目
    setShopServicesByShopId(shopId);
  }
};

// 从后端加载店铺评分分布
const loadShopRatingDistribution = async (shopId) => {
  console.log("开始加载店铺评分分布，店铺ID:", shopId);
  try {
    const response = await fetch(`http://localhost:8082/api/shop-ratings/shop/${shopId}`);
    console.log("评分分布请求响应状态:", response.status);
    if (response.ok) {
      const data = await response.json();
      console.log("从后端获取的评分分布数据:", data);
      // 转换数据格式，使其与前端期望的格式匹配
      shopRatingDistribution.value = {
        rating5: data.rating5 || 0,
        rating4: data.rating4 || 0,
        rating3: data.rating3 || 0,
        rating2: data.rating2 || 0,
        rating1: data.rating1 || 0,
        averageRating: data.averageRating || 0,
      };
      console.log("设置后的shopRatingDistribution:", shopRatingDistribution.value);
    }
  } catch (error) {
    console.error("加载店铺评分分布失败:", error);
  }
};

// 根据店铺ID设置不同的服务项目
const setShopServicesByShopId = (shopId) => {
  console.log("根据店铺ID设置服务项目，店铺ID:", shopId);
  const shopServicesMap = {
    1: ["汉服售卖", "汉服租赁", "汉服定制"],
    2: ["汉服售卖", "日常汉服", "汉服配饰"],
    3: ["传统汉服", "汉服租赁", "汉服妆造"],
    4: ["汉服售卖", "小众设计", "汉服定制"],
    5: ["汉服售卖", "传统工艺", "汉服租赁"],
    6: ["汉服售卖", "优雅设计", "汉服配饰"],
    7: ["汉服定制", "高端汉服", "汉服租赁"],
    8: ["绣花汉服", "汉服定制", "汉服售卖"],
    9: ["古风设计", "汉服定制", "汉服租赁"],
    10: ["传统工艺", "汉服定制", "高端汉服"],
    11: ["高端定制", "设计独特", "汉服租赁"],
    12: ["礼仪汉服", "高端定制", "汉服租赁"],
    13: ["盛世风格", "高端定制", "汉服售卖"],
    14: ["古典风格", "高端定制", "汉服租赁"],
    15: ["顶级定制", "手工制作", "汉服婚礼"],
    16: ["皇室风格", "高端汉服", "汉服定制"],
    17: ["顶级定制", "手工制作", "汉服婚礼"],
  };

  shopServices.value = shopServicesMap[shopId] || ["汉服售卖", "汉服租赁"];
};

// 计算属性
const services = computed(() => {
  return shopServices.value;
});

// 评价列表数据
const reviews = ref([]);

// 从后端加载店铺评价
const loadShopReviews = async (shopId) => {
  try {
    const response = await fetch(`http://localhost:8082/api/evaluations/shop/${shopId}`);
    if (response.ok) {
      const data = await response.json();
      // 为每个评价获取用户信息
      const reviewsWithUserInfo = await Promise.all(
        data.map(async (item) => {
          let username = `用户${item.userId}`;
          try {
            // 尝试获取用户真实姓名
            const userResponse = await fetch(`http://localhost:8082/api/users/${item.userId}`);
            if (userResponse.ok) {
              const userData = await userResponse.json();
              username = userData.username || username;
            }
          } catch (userError) {
            console.error("加载用户信息失败:", userError);
          }
          return {
            id: item.id,
            name: username,
            avatar: `https://placehold.co/40/8b4513/FFFFFF?text=用户`,
            rating: item.rating || 0,
            time: item.createTime ? new Date(item.createTime).toLocaleDateString() : "",
            content: item.content || "无评价内容",
          };
        }),
      );
      reviews.value = reviewsWithUserInfo;
    }
  } catch (error) {
    console.error("加载店铺评价失败:", error);
  }
};

// 完整的评价列表
const allReviews = computed(() => {
  return reviews.value.length > 0
    ? reviews.value
    : [
        {
          id: 1,
          name: "汉服爱好者",
          avatar: "https://placehold.co/40/8b4513/FFFFFF?text=用户",
          rating: calculatedRating.value > 4 ? 5 : 4,
          time: "2024-01-15",
          content: `这家店铺的${shop.value.tags[0]}汉服真的太美了！做工精细，面料舒适，还原度很高。下次还会再来！`,
        },
        {
          id: 2,
          name: "传统文化研究者",
          avatar: "https://placehold.co/40/d2691e/FFFFFF?text=用户",
          rating: Math.floor(calculatedRating.value) || 4,
          time: "2024-01-10",
          content: `对于${shop.value.tags[0]}汉服的历史细节还原非常到位，看得出来是下了功夫研究的。推荐给喜欢传统服饰的朋友。`,
        },
        {
          id: 3,
          name: "汉服新手",
          avatar: "https://placehold.co/40/8b4513/FFFFFF?text=用户",
          rating: 5,
          time: "2024-01-05",
          content: `第一次购买汉服，店家服务很耐心，推荐的款式很适合我。质量也很不错，准备再入手一套。`,
        },
      ];
});

// 显示的评价列表（根据showAllReviews控制）
const displayedReviews = computed(() => {
  if (showAllReviews.value) {
    return allReviews.value;
  } else {
    return allReviews.value.slice(0, 3); // 默认只显示前3条
  }
});

const contact = computed(() => {
  // 使用从后端加载的店铺数据
  if (shop.value && shop.value.address) {
    return {
      address: shop.value.address,
      phone: shop.value.contact || "暂无联系电话",
      wechat: "请联系店铺获取",
    };
  }
  // 默认值
  return {
    address: "暂无地址信息",
    phone: "暂无联系电话",
    wechat: "请联系店铺获取",
  };
});

// 汉服展示图片
const hanfuImages = computed(() => {
  // 使用从后端加载的图片
  console.log("hanfuImages computed, shopImages.length:", shopImages.value.length);
  if (shopImages.value.length > 0) {
    const urls = shopImages.value.map((img) => img.url);
    console.log("hanfuImages返回的URL列表:", urls);
    return urls;
  }
  // 默认图片（最少1张）
  console.log("使用默认图片");
  return ["/shop-hanfu/q (1).png"];
});

// 获取图片描述文字
const getImageText = (index) => {
  // 使用从后端加载的图片描述
  if (shopImages.value.length > 0 && shopImages.value[index]) {
    return shopImages.value[index].description;
  }
  // 默认描述
  const texts = ["传统礼服系列", "日常汉服系列", "婚庆特别款", "手工刺绣款", "改良设计款"];
  return texts[index] || "汉服展示";
};

// 获取各星级评价人数分布
const getRatingDistribution = computed(() => {
  // 优先使用从后端获取的评分分布数据
  if (shopRatingDistribution.value) {
    return {
      5: shopRatingDistribution.value.rating5 || 0,
      4: shopRatingDistribution.value.rating4 || 0,
      3: shopRatingDistribution.value.rating3 || 0,
      2: shopRatingDistribution.value.rating2 || 0,
      1: shopRatingDistribution.value.rating1 || 0,
    };
  }

  // 如果后端数据不可用，根据实际评价数据计算评分分布
  const distribution = {
    5: 0,
    4: 0,
    3: 0,
    2: 0,
    1: 0,
  };

  allReviews.value.forEach((review) => {
    const rating = Math.round(review.rating);
    if (rating >= 1 && rating <= 5) {
      distribution[rating]++;
    }
  });

  return distribution;
});

// 根据评分分布计算综合评分
const calculatedRating = computed(() => {
  // 优先使用从后端获取的平均评分
  if (shopRatingDistribution.value && shopRatingDistribution.value.averageRating) {
    return shopRatingDistribution.value.averageRating;
  }

  // 如果后端数据不可用，使用前端计算的评分
  const distribution = getRatingDistribution.value;
  const totalCount = Object.values(distribution).reduce((sum, count) => sum + count, 0);

  if (totalCount === 0) {
    return shop.value.rating || 0;
  }

  const weightedSum =
    5 * (distribution[5] || 0) +
    4 * (distribution[4] || 0) +
    3 * (distribution[3] || 0) +
    2 * (distribution[2] || 0) +
    1 * (distribution[1] || 0);

  return parseFloat((weightedSum / totalCount).toFixed(1));
});

// 监听 shopImages 变化
watch(
  shopImages,
  (newVal, oldVal) => {
    console.log(`shopImages 变化: ${oldVal?.length || 0} -> ${newVal?.length || 0}`, newVal);
  },
  { deep: true },
);

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }

  // 从路由参数获取店铺ID并加载数据
  const shopId = parseInt(route.params.id);
  if (shopId) {
    console.log(`页面加载，开始加载店铺${shopId}的数据...`);
    loadShop(shopId);
    loadShopRatingDistribution(shopId);
    loadShopReviews(shopId);
  } else {
    ElMessage.error("店铺ID无效");
    router.push("/shop-list");
  }
});

// 格式化价格区间
const formatPriceRange = (priceRange) => {
  const priceMap = {
    亲民: "亲民（0-400）",
    中档: "中档（400-700）",
    中高档: "中高档（700-1000）",
    高档: "高档（1000以上）",
  };
  return priceMap[priceRange] || priceRange;
};

// 获取评价百分比
const getRatingPercentage = (rating) => {
  const distribution = getRatingDistribution.value;
  const count = distribution[rating] || 0;
  const total = 100; // 固定总数为100
  return Math.round((count / total) * 100);
};

// 获取评价人数
const getRatingCount = (rating) => {
  const distribution = getRatingDistribution.value;
  return distribution[rating] || 0;
};

// 预览图片
const previewImage = (index) => {
  previewIndex.value = index;
  previewVisible.value = true;
};

// 切换显示所有评价
const toggleShowAllReviews = () => {
  showAllReviews.value = !showAllReviews.value;
};

// 跳转到评价表单页面
const goToEvaluation = () => {
  router.push(`/shop-evaluation-form/${shop.value.id}`);
};

// 导航方法
const goToHome = () => router.push("/");
const goToCulture = () => router.push("/culture");
const goToActivity = () => router.push("/activity");
const goToCommunity = () => router.push("/community");
const goToShopList = () => router.push("/shop-list");

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

// 返回方法
const goBack = () => {
  router.push("/shop-list");
};
</script>

<style scoped>
.shop-detail-container {
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

/* 页面标题区域 */
.page-header {
  display: flex;
  align-items: center;
  margin-bottom: 24px;
  gap: 16px;
}

.back-btn {
  color: #8b4513;
  padding: 0;
  font-size: 14px;
  display: flex;
  align-items: center;
}

.page-title {
  font-size: 28px;
  margin: 0;
  color: #8b4513;
}

/* 店铺基本信息 */
.shop-basic-info {
  background-color: white;
  border-radius: 8px;
  padding: 30px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.shop-header {
  display: flex;
  gap: 30px;
  margin-bottom: 30px;
}

.shop-image {
  width: 300px;
  height: 200px;
  flex-shrink: 0;
}

.main-image {
  width: 100%;
  height: 100%;
  border-radius: 8px;
}

.shop-summary {
  flex: 1;
}

.summary-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.shop-name {
  margin: 0;
  color: #8b4513;
  font-size: 24px;
  font-weight: bold;
}

.shop-rating {
  display: flex;
  align-items: center;
  gap: 8px;
}

.review-count {
  font-size: 14px;
  color: #999;
}

.summary-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 16px;
  font-size: 14px;
  color: #666;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.shop-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 24px;
}

/* 店铺介绍部分（移动到原来按钮位置） */
.shop-description-section {
  margin-top: 20px;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
  border-left: 4px solid #d4a76a;
}

.description-title {
  margin: 0 0 12px 0;
  color: #8b4513;
  font-size: 18px;
  font-weight: bold;
}

.description-content {
  margin: 0;
  color: #666;
  line-height: 1.6;
  font-size: 14px;
}

/* 删除shop-actions样式 */

/* 店铺详细信息 */
.shop-details {
  background-color: white;
  border-radius: 8px;
  padding: 30px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.detail-section {
  margin-bottom: 30px;
}

.detail-section h3 {
  margin: 0 0 20px 0;
  color: #333;
  font-size: 18px;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

/* 汉服展示 */
.hanfu-display {
  margin-top: 10px;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.image-item {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: transform 0.3s;
  background-color: #f5f5f5;
}

.image-item:hover {
  transform: translateY(-5px);
}

.display-image {
  width: 100%;
  height: auto;
  display: block;
  object-fit: contain;
}

.image-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  padding: 15px;
  color: white;
}

.image-text {
  font-size: 14px;
  font-weight: bold;
}

/* 服务项目 */
.service-list {
  display: flex;
  gap: 15px;
}

.service-list .el-tag {
  padding: 8px 20px;
  font-size: 14px;
}

/* 评价区域 */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

/* 评价操作按钮组 */
.review-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}

.add-review-btn {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: transparent;
  color: white;
  font-size: 14px;
  padding: 8px 16px;
}

.add-review-btn:hover {
  background: linear-gradient(135deg, #d2691e 0%, #8b4513 100%);
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.2);
}

.more-review-btn {
  color: #8b4513;
  font-size: 14px;
  padding: 8px 16px;
}

.more-review-btn:hover {
  color: #d2691e;
}

.rating-stats {
  display: flex;
  gap: 40px;
  margin-bottom: 30px;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
}

.overall-rating {
  text-align: center;
  min-width: 100px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.rating-number {
  font-size: 36px;
  font-weight: bold;
  color: #8b4513;
  margin-bottom: 5px;
}

.rating-text {
  font-size: 14px;
  color: #999;
}

.rating-bars {
  flex: 1;
}

.rating-bar-item {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}

.rating-label {
  width: 40px;
  font-size: 14px;
  color: #666;
  text-align: right;
  margin-right: 10px;
}

.rating-progress {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 10px;
}

.rating-progress .el-progress {
  flex: 1;
}

.rating-count {
  width: 60px;
  font-size: 12px;
  color: #666;
  text-align: left;
}

/* 评价列表 */
.review-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.review-item {
  padding: 20px;
  border: 1px solid #eee;
  border-radius: 8px;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.reviewer-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.reviewer-details {
  display: flex;
  flex-direction: column;
}

.reviewer-name {
  font-weight: bold;
  color: #333;
}

.review-time {
  font-size: 12px;
  color: #999;
}

.review-content {
  color: #666;
  line-height: 1.6;
  margin-bottom: 12px;
}

/* 更多评价按钮 */
.review-more-btn {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.review-more-btn .more-review-btn {
  color: #8b4513;
  font-size: 14px;
  padding: 8px 16px;
  border: 1px solid #d4a76a;
  border-radius: 4px;
}

.review-more-btn .more-review-btn:hover {
  color: #d2691e;
  border-color: #d2691e;
}

/* 联系信息 */
.contact-items {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #666;
  font-size: 14px;
}

.contact-item .el-icon {
  color: #8b4513;
}

/* 加载状态 */
.loading {
  padding: 100px 0;
  text-align: center;
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
  .shop-header {
    flex-direction: column;
  }

  .shop-image {
    width: 100%;
    height: 200px;
  }

  .summary-header {
    flex-direction: column;
    gap: 8px;
  }

  .rating-stats {
    flex-direction: column;
    gap: 20px;
  }

  .image-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
  }

  .image-item {
    height: 200px;
  }

  .service-list {
    flex-direction: column;
    align-items: flex-start;
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

  .review-actions {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .shop-description-section {
    padding: 15px;
  }
}

@media (max-width: 480px) {
  .image-grid {
    grid-template-columns: 1fr;
  }

  .rating-progress {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }

  .rating-count {
    text-align: left;
    width: auto;
  }
}
</style>
