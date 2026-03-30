<template>
  <div class="home-container">
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
          <el-button type="text" @click="logout" class="logout-btn"> 退出 </el-button>
        </div>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="container">
        <!-- 汉服知识库页面 -->
        <div>
          <h2 class="page-title">汉服知识库</h2>

          <!-- 历史演变部分 - 修改为图片+文字形式 -->
          <div class="section">
            <div class="section-header">
              <h3 class="section-title">
                <el-icon><Notebook /></el-icon>
                历史演变
              </h3>
              <el-button type="primary" class="btn-top-right" @click="viewDetail('history')"
                >查看详细</el-button
              >
            </div>
            <div class="history-content-wrapper">
              <div class="history-image">
                <el-image
                  src="/history.png"
                  alt="汉服历史演变图"
                  fit="cover"
                  class="history-main-img"
                >
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                      <div>汉服历史演变图</div>
                    </div>
                  </template>
                </el-image>
              </div>
              <div class="history-text">
                <h4 class="history-subtitle">汉服的历史源流</h4>
                <p class="history-description">
                  {{
                    culturalContents.find((item) => item.type === "overview")?.content ||
                    '汉服，全称是"汉民族传统服饰"，又称汉衣冠、汉装、华服，是从黄帝即位到公元17世纪中叶(明末清初)，在汉族的主要居住区，以"华夏-汉"文化为背景和主导思想，以华夏礼仪文化为中心，通过自然演化而形成的具有独特汉民族风貌性格，明显区别于其他民族的传统服装和配饰体系。'
                  }}
                </p>
                <div class="history-timeline">
                  <div
                    v-for="item in culturalContents.filter((item) => item.type === 'history')"
                    :key="item.id"
                    class="timeline-item"
                  >
                    <span class="timeline-period">{{ item.name }}</span>
                    <span class="timeline-desc">{{ item.title }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 形制分类部分 -->
          <div class="section">
            <div class="section-header">
              <h3 class="section-title">
                <el-icon><CollectionTag /></el-icon>
                形制分类
              </h3>
              <el-button type="primary" class="btn-top-right" @click="viewMore('shape-types')">
                更多
              </el-button>
            </div>
            <div class="shape-type-grid">
              <div
                class="shape-type-card"
                v-for="shape in displayedShapeTypes"
                :key="shape.id"
                @click="viewShapeType(shape)"
              >
                <div class="shape-type-img">
                  <el-image :src="shape.img" :alt="shape.name" fit="cover">
                    <template #error>
                      <div class="image-slot">
                        <el-icon><Picture /></el-icon>
                      </div>
                    </template>
                  </el-image>
                </div>
                <div class="shape-type-name">{{ shape.name }}</div>
                <div class="shape-type-desc">{{ shape.description }}</div>
              </div>
            </div>
          </div>

          <!-- 图案象征部分 -->
          <div class="section pattern-symbolism-section">
            <div class="section-header">
              <h3 class="section-title">
                <el-icon><PictureFilled /></el-icon>
                图案象征
              </h3>
              <el-button type="primary" class="btn-top-right" @click="viewMore('patterns')">
                更多
              </el-button>
            </div>
            <div class="dynasty-grid">
              <div
                class="dynasty-card"
                v-for="pattern in displayedPatterns"
                :key="pattern.id"
                @click="viewPattern(pattern)"
              >
                <div class="dynasty-img">
                  <el-image :src="pattern.img" :alt="pattern.name" fit="cover">
                    <template #error>
                      <div class="image-slot">
                        <el-icon><Picture /></el-icon>
                      </div>
                    </template>
                  </el-image>
                </div>
                <div class="dynasty-name">{{ pattern.name }}</div>
                <div class="pattern-meaning">{{ pattern.meaning }}</div>
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

    <!-- 形制详情对话框 -->
    <el-dialog v-model="showDynastyDialog" :title="selectedDynasty?.name" width="600px" center>
      <div v-if="selectedDynasty" class="dynasty-detail">
        <div class="detail-image">
          <el-image
            :src="selectedDynasty.img"
            :alt="selectedDynasty.name"
            fit="cover"
            style="width: 100%; height: 300px; border-radius: 8px"
          >
            <template #error>
              <div class="image-slot">
                <el-icon><Picture /></el-icon>
                <div>{{ selectedDynasty.name }}</div>
              </div>
            </template>
          </el-image>
        </div>
        <div class="detail-info">
          <div class="info-item">
            <span class="info-label">朝代时期：</span>
            <span class="info-value">{{ selectedDynasty.period }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">形制描述：</span>
            <p class="info-description">{{ selectedDynasty.description }}</p>
          </div>
          <div class="info-item" v-if="selectedDynasty.features">
            <span class="info-label">形制特点：</span>
            <ul class="features-list">
              <li v-for="(feature, index) in selectedDynasty.features.split('|')" :key="index">
                {{ feature }}
              </li>
            </ul>
          </div>
        </div>
      </div>
      <template #footer>
        <el-button @click="showDynastyDialog = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 形制分类详情弹窗 -->
    <el-dialog
      v-model="shapeDialogVisible"
      :title="currentDetail.title"
      width="65%"
      class="detail-dialog"
      destroy-on-close
    >
      <div class="dialog-content">
        <!-- 详细简介 -->
        <div v-if="currentDetail.content" class="content-section">
          <div class="content-text">
            <p>{{ currentDetail.content }}</p>
          </div>
        </div>

        <!-- 图片展示区域 -->
        <div class="image-gallery" v-if="currentDetail.images && currentDetail.images.length > 0">
          <div class="image-grid">
            <div class="image-item" v-for="(image, index) in currentDetail.images" :key="index">
              <el-image
                :src="image.url"
                :alt="image.alt"
                fit="cover"
                class="detail-image"
                :preview-src-list="currentDetail.images.map((img) => img.url)"
                :initial-index="index"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                    <div>{{ image.alt }}</div>
                  </div>
                </template>
              </el-image>
              <div class="image-caption">{{ image.caption }}</div>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="shapeDialogVisible = false" type="primary">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import {
  Notebook,
  CollectionTag,
  PictureFilled,
  Picture,
  InfoFilled,
  Collection,
  Clock,
  Document,
} from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { getImageUrl } from "../utils/imageHelper.js";

defineOptions({
  name: "Knowledge",
});

const router = useRouter();
// eslint-disable-next-line no-unused-vars
const route = useRoute();
// TODO: 后续会使用这个 route 变量
const username = ref("汉服爱好者");

// 最大显示数量
const maxDisplayCount = ref(6);

const dynasties = ref([]);
const patterns = ref([]);
const shapeTypes = ref([]);
const culturalContents = ref([]);

// 形制详情对话框状态
const showDynastyDialog = ref(false);
const selectedDynasty = ref(null);

// 形制分类详情弹窗状态
const shapeDialogVisible = ref(false);
const currentDetail = ref({
  title: "",
  description: "",
  period: "",
  features: [],
  content: "",
  images: [],
});

// 从后端加载形制分类数据（4种基本形制）
const loadShapeTypes = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/shape-type/top4");
    if (response.ok) {
      const data = await response.json();
      shapeTypes.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        period: item.period,
        img: getImageUrl(
          item.image || `https://placehold.co/300x200/8B4513/FFFFFF?text=${item.name}`,
        ),
        description: item.description,
        characteristics: item.characteristics,
      }));
    }
  } catch (error) {
    console.error("加载形制分类数据失败:", error);
    // 如果后端接口不可用，使用默认数据
    shapeTypes.value = [
      {
        id: 1,
        name: "深衣制",
        period: "战国至明代",
        img: "https://placehold.co/300x200/8B4513/FFFFFF?text=深衣制",
        description: "上下连属的服饰，将上衣下裳连为一体",
        characteristics: "上下连属、端庄大方、适用广泛",
      },
      {
        id: 2,
        name: "衣裳制",
        period: "先秦至明清",
        img: "https://placehold.co/300x200/8B4513/FFFFFF?text=衣裳制",
        description: "上衣下裳的基本形制，最古老的汉服形式",
        characteristics: "上下分裁、庄严正统、礼仪性强",
      },
      {
        id: 3,
        name: "襦裙制",
        period: "历代流行",
        img: "https://placehold.co/300x200/8B4513/FFFFFF?text=襦裙制",
        description: "上衣下裙的女装组合，款式变化丰富",
        characteristics: "上衣下裙、款式多样、女性特色",
      },
      {
        id: 4,
        name: "袍服制",
        period: "汉代以后",
        img: "https://placehold.co/300x200/8B4513/FFFFFF?text=袍服制",
        description: "一体裁剪的长衣，便于活动",
        characteristics: "一体裁剪、便于活动、日常实用",
      },
    ];
  }
};

// 从后端加载朝代形制数据
const loadDynasties = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/historical-era");
    if (response.ok) {
      const data = await response.json();
      dynasties.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        period: item.years,
        img: getImageUrl(
          item.image || `https://placehold.co/150x120/FFE4E1/000000?text=${item.name}`,
        ),
        description: item.description,
        features: item.title,
      }));
    }
  } catch (error) {
    console.error("加载朝代形制数据失败:", error);
  }
};

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
        img: getImageUrl(item.image), // 使用工具函数处理图片URL
        category: item.category,
        description: item.description,
      }));
    }
  } catch (error) {
    console.error("加载图案数据失败:", error);
  }
};

// 从后端加载文化内容数据
const loadCulturalContents = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/cultural-content");
    if (response.ok) {
      const data = await response.json();
      culturalContents.value = data;
    }
  } catch (error) {
    console.error("加载文化内容数据失败:", error);
  }
};

// 计算显示的形制分类数据（固定显示4个）
const displayedShapeTypes = computed(() => {
  return shapeTypes.value.slice(0, 4);
});

// 计算显示的朝代数据（固定显示6个）
const displayedDynasties = computed(() => {
  return dynasties.value.slice(0, maxDisplayCount.value);
});

// 计算显示的图案数据（固定显示6个）
const displayedPatterns = computed(() => {
  return patterns.value.slice(0, maxDisplayCount.value);
});

onMounted(() => {
  // 从localStorage获取用户信息
  // 加载数据
  loadShapeTypes();
  loadDynasties();
  loadPatterns();
  loadCulturalContents();
  const savedUsername = localStorage.getItem("username");

  if (savedUsername) {
    username.value = savedUsername;
  }
});

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

const viewDynasty = (dynasty) => {
  selectedDynasty.value = dynasty;
  showDynastyDialog.value = true;
};

const viewShapeType = async (shape) => {
  // 从后端获取形制详细信息
  try {
    const response = await fetch(`http://localhost:8082/api/shape-type/${shape.id}`);
    if (response.ok) {
      const data = await response.json();
      // 解析特点（顿号分隔）
      const features = data.characteristics ? data.characteristics.split("、") : [];
      // 构建图片数组（1-2张）
      const images = [];
      if (data.image) {
        images.push({
          url: getImageUrl(data.image),
          alt: data.name,
          caption: data.name,
        });
      }
      // 添加第二张图片
      images.push({
        url: `https://placehold.co/400x300/8B4513/FFFFFF?text=${encodeURIComponent(data.name + "展示")}`,
        alt: data.name + "展示",
        caption: data.name + "展示效果",
      });
      // 构建详细内容
      currentDetail.value = {
        title: data.name,
        description: data.description,
        period: data.period,
        features: features,
        content: data.content || "",
        images: images,
      };
      shapeDialogVisible.value = true;
    } else {
      ElMessage.error("获取形制详细信息失败");
    }
  } catch (error) {
    console.error("获取形制详细信息失败:", error);
    ElMessage.error("获取形制详细信息失败");
  }
};

const viewPattern = (pattern) => {
  // 点击单个图案时跳转到图案象征页面，并带上 patternId 参数定位到该图案
  router.push({
    path: "/pattern",
    query: { patternId: pattern.id },
  });
};

// 查看详细内容
const viewDetail = (type) => {
  if (type === "history") {
    // 跳转到历史演变详细页面
    router.push("/history-evolution").then(() => {
      // 确保页面跳转后滚动到顶部
      window.scrollTo(0, 0);
    });
  } else {
    ElMessageBox.alert(`即将跳转到详细内容页面`, "页面跳转", {
      confirmButtonText: "确定",
      callback: () => {
        ElMessage.info("页面跳转功能开发中...");
      },
    });
  }
};

// 查看更多内容
const viewMore = (type) => {
  console.log("点击了查看更多，类型：", type);

  if (type === "shape-types") {
    // 跳转到形制分类详细页面
    console.log("准备跳转到形制分类页面");
    router
      .push("/shape-classification")
      .then(() => {
        console.log("跳转成功");
        // 确保页面跳转后滚动到顶部
        window.scrollTo(0, 0);
      })
      .catch((error) => {
        console.error("跳转失败：", error);
        ElMessage.error("页面跳转失败：" + error.message);
      });
  } else if (type === "dynasties") {
    // 跳转到形制分类详细页面（朝代部分）
    console.log("准备跳转到形制分类页面-朝代部分");
    router
      .push("/shape-classification")
      .then(() => {
        console.log("跳转成功");
        // 确保页面跳转后滚动到顶部
        window.scrollTo(0, 0);
      })
      .catch((error) => {
        console.error("跳转失败：", error);
        ElMessage.error("页面跳转失败：" + error.message);
      });
  } else if (type === "patterns") {
    // 跳转到图案象征列表页面或第一个图案的详细页面
    console.log("准备跳转到图案象征页面");

    // 方案1：跳转到第一个图案的详细页面
    if (patterns.value.length > 0) {
      const firstPattern = patterns.value[0];
      router
        .push({
          name: "PatternSymbolismDetail",
          params: { id: firstPattern.id },
        })
        .then(() => {
          console.log("跳转到图案详细页面成功");
          // 确保页面跳转后滚动到顶部
          window.scrollTo(0, 0);
        })
        .catch((error) => {
          console.error("跳转失败：", error);
          ElMessage.error("页面跳转失败：" + error.message);
        });
    } else {
      ElMessage.warning("暂无图案数据");
    }
  } else {
    ElMessage.info("页面跳转功能开发中...");
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
/* 样式保持不变，与之前相同 */
.home-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f3e9 0%, #f5f0e4 100%);
}

/* 顶部导航栏样式 */
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
  position: relative;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 15px;
}

.section-title {
  font-size: 20px;
  margin-bottom: 0;
  color: #8b4513;
  display: flex;
  align-items: center;
}

.section-title i {
  margin-right: 8px;
}

.btn-top-right {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: #8b4513;
  color: white;
  margin-top: 0;
}

.btn-top-right:hover {
  background: linear-gradient(135deg, #a0522d 0%, #da7b2d 100%);
  border-color: #a0522d;
  color: white;
}

.btn-top-right:active {
  background: linear-gradient(135deg, #654321 0%, #b8860b 100%);
  border-color: #654321;
  color: white;
}

.history-content-wrapper {
  display: flex;
  gap: 30px;
  align-items: flex-start;
}

.history-image {
  flex: 0 0 45%;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.history-main-img {
  width: 100%;
  height: 300px;
  display: block;
}

.history-text {
  flex: 1;
}

.history-subtitle {
  font-size: 18px;
  color: #8b4513;
  margin-bottom: 15px;
  border-bottom: 2px solid #d4a76a;
  padding-bottom: 8px;
}

.history-description {
  color: #666;
  line-height: 1.6;
  margin-bottom: 20px;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.history-timeline {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.timeline-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  background-color: #f9f5f0;
  border-radius: 6px;
  border-left: 4px solid #d4a76a;
  transition: all 0.3s ease;
}

.timeline-item:hover {
  background-color: #f0e6d6;
  transform: translateX(5px);
}

.timeline-period {
  font-weight: bold;
  color: #8b4513;
  min-width: 100px;
}

.timeline-desc {
  color: #666;
  flex: 1;
  text-align: right;
}

/* 形制分类网格 - 4等分 */
.shape-type-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-top: 15px;
}

.shape-type-card {
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
  padding: 15px 10px;
  background: #fafafa;
  border: 1px solid #f0f0f0;
}

.shape-type-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
  background: white;
  border-color: #d4a76a;
}

.shape-type-img {
  width: 100%;
  height: 150px;
  border-radius: 6px;
  background-color: #f0f0f0;
  margin-bottom: 12px;
  overflow: hidden;
  border: 1px solid #e8e8e8;
}

.shape-type-name {
  font-weight: 600;
  font-size: 18px;
  color: #8b4513;
  margin-bottom: 8px;
}

.shape-type-desc {
  font-size: 13px;
  color: #666;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 形制分类网格 - 3等分 */
.dynasty-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-top: 15px;
}

.dynasty-card {
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
  padding: 15px 10px;
  background: #fafafa;
  border: 1px solid #f0f0f0;
}

.dynasty-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
  background: white;
  border-color: #d4a76a;
}

.dynasty-img {
  width: 100%;
  height: 120px;
  border-radius: 6px;
  background-color: #f0f0f0;
  margin-bottom: 12px;
  overflow: hidden;
  border: 1px solid #e8e8e8;
}

.dynasty-name {
  font-weight: 600;
  font-size: 16px;
  color: #8b4513;
  margin-bottom: 5px;
}

.dynasty-period {
  font-size: 12px;
  color: #666;
  margin-bottom: 5px;
}

.pattern-meaning {
  font-size: 12px;
  color: #666;
  font-style: italic;
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
  flex-direction: column;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .dynasty-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
  }
}

@media (max-width: 768px) {
  .nav-container {
    flex-direction: column;
    align-items: stretch;
  }

  .logo {
    text-align: center;
    margin-bottom: 10px;
  }

  .nav-menu {
    margin-top: 10px;
    margin-bottom: 10px;
    justify-content: center;
    flex-wrap: wrap;
  }

  .nav-item {
    margin: 5px;
    font-size: 12px;
  }

  .user-info-vertical {
    margin-top: 10px;
    align-items: center;
  }

  .dynasty-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .logo {
    font-size: 18px;
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .btn-top-right {
    align-self: flex-end;
  }

  .dynasty-img {
    height: 100px;
  }

  .dynasty-name {
    font-size: 14px;
  }

  /* 历史演变部分响应式 */
  .history-content-wrapper {
    flex-direction: column;
    gap: 20px;
  }

  .history-image {
    flex: none;
    width: 100%;
  }

  .history-main-img {
    height: 200px;
  }

  .timeline-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }

  .timeline-desc {
    text-align: left;
  }
}

@media (max-width: 480px) {
  .dynasty-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }

  .dynasty-img {
    height: 80px;
  }

  .dynasty-name {
    font-size: 13px;
  }

  .dynasty-period,
  .pattern-meaning {
    font-size: 11px;
  }
}

/* 形制详情对话框样式 */
.dynasty-detail {
  padding: 10px 0;
}

.detail-image {
  margin-bottom: 20px;
}

.detail-info {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.info-label {
  font-weight: 600;
  color: #8b4513;
  font-size: 15px;
}

.info-value {
  color: #666;
  font-size: 14px;
}

.info-description {
  color: #666;
  line-height: 1.6;
  margin: 0;
  text-align: justify;
}

.features-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.features-list li {
  padding: 8px 12px;
  background-color: #f9f5f0;
  border-radius: 4px;
  color: #666;
  border-left: 3px solid #d4a76a;
  font-size: 14px;
}

.features-list li:hover {
  background-color: #f0e6d6;
}

/* 形制分类详情弹窗样式 */
.detail-dialog {
  border-radius: 16px;
}

.detail-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
  padding: 20px;
  margin-right: 0;
}

.detail-dialog :deep(.el-dialog__title) {
  color: white;
  font-size: 18px;
  font-weight: 600;
}

.detail-dialog :deep(.el-dialog__headerbtn .el-dialog__close) {
  color: white;
}

.detail-dialog :deep(.el-dialog__headerbtn:hover .el-dialog__close) {
  color: #f0e6dc;
}

.dialog-content {
  max-height: 65vh;
  overflow-y: auto;
  padding: 10px 5px;
}

/* 区块标签样式 */
.section-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #8b4513;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid #f0e6dc;
}

.section-label .el-icon {
  font-size: 16px;
}

/* 简介区域 */
.description-section {
  margin-bottom: 20px;
}

.description-text {
  font-size: 15px;
  line-height: 1.8;
  color: #555;
  text-align: justify;
  padding: 15px;
  background: #faf7f4;
  border-radius: 8px;
  border-left: 4px solid #d4a76a;
}

/* 流行时期 */
.period-section {
  margin-bottom: 20px;
}

.period-text {
  font-size: 14px;
  color: #666;
  padding: 10px 15px;
  background: #f5f5f5;
  border-radius: 6px;
  display: inline-block;
}

/* 特点区域 */
.features-section {
  margin-bottom: 20px;
}

.features-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.feature-tag {
  font-size: 13px;
  padding: 6px 12px;
  border-radius: 20px;
}

/* 详细内容区域 */
.content-section {
  margin-bottom: 20px;
}

.content-text {
  padding: 0 5px;
}

.content-text p {
  line-height: 1.9;
  color: #555;
  margin-bottom: 12px;
  text-align: justify;
  font-size: 14px;
}

/* 图片展示区域 */
.image-gallery {
  margin-top: 20px;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 15px;
}

.image-item {
  text-align: center;
}

.detail-image {
  width: 100%;
  height: 160px;
  border-radius: 8px;
  object-fit: cover;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.detail-image:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 16px rgba(139, 69, 19, 0.2);
}

.image-caption {
  margin-top: 10px;
  font-size: 13px;
  color: #666;
  text-align: center;
  font-weight: 500;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 160px;
  background: #f5f7fa;
  color: #909399;
  flex-direction: column;
  border-radius: 8px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>
