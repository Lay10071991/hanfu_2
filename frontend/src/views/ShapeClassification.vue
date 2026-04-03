<template>
  <div class="shape-classification-container">
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

        <h2 class="page-title">汉服形制分类</h2>

        <!-- 基本形制介绍 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><Grid /></el-icon>
            四大基本形制
          </h3>
          <div class="shape-types">
            <div
              class="shape-type-card"
              v-for="shape in shapeTypes"
              :key="shape.name"
              @click="showDetail('shape', shape)"
            >
              <div class="shape-type-header">
                <h4>{{ shape.name }}</h4>
              </div>
              <div class="shape-type-content">
                <p>{{ shape.description }}</p>
                <div class="shape-details">
                  <div class="detail-item">
                    <span class="detail-label">流行时期：</span>
                    <span class="detail-value">{{ shape.period }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">主要特征：</span>
                    <span class="detail-value">{{ shape.characteristics }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 服饰部件介绍 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><SetUp /></el-icon>
            服饰部件详解
          </h3>
          <div class="components-grid">
            <div
              class="component-card"
              v-for="component in components"
              :key="component.name"
              @click="showDetail('component', component)"
            >
              <div class="component-icon">
                <el-icon><Goods /></el-icon>
              </div>
              <div class="component-info">
                <h4>{{ component.name }}</h4>
                <p>{{ component.description }}</p>
                <span class="component-type">{{ component.type }}</span>
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

    <!-- 弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentDetail.title"
      width="80%"
      :before-close="handleClose"
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
              <el-image :src="image.url" :alt="image.alt" fit="contain" class="detail-image">
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                    <div>{{ image.alt }}</div>
                  </div>
                </template>
              </el-image>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false" type="primary">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import {
  ArrowLeft,
  Histogram,
  Grid,
  SetUp,
  Goods,
  Picture,
  InfoFilled,
  Collection,
  Clock,
  Document,
} from "@element-plus/icons-vue";

const router = useRouter();
const username = ref("汉服爱好者");
const dialogVisible = ref(false);

// 当前显示的详情内容
const currentDetail = reactive({
  title: "",
  content: [],
  images: [],
});

// 基本形制数据 - 从后端加载
const shapeTypes = ref([]);

// 加载形制分类数据
const loadShapeTypes = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/shape-type/top4");
    if (response.ok) {
      const data = await response.json();
      shapeTypes.value = data;
    } else {
      console.error("加载形制分类数据失败，响应状态:", response.status);
      // 使用默认数据
      setDefaultShapeTypes();
    }
  } catch (error) {
    console.error("加载形制分类数据失败:", error);
    // 使用默认数据
    setDefaultShapeTypes();
  }
};

// 设置默认形制分类数据
const setDefaultShapeTypes = () => {
  shapeTypes.value = [
    {
      name: "衣裳制",
      description: "上衣下裳的基本形制，最古老的汉服形式，象征天地秩序。",
      period: "先秦至明清",
      characteristics: "上下分裁、庄严正统、礼仪性强",
    },
    {
      name: "深衣制",
      description: "上下连属的服饰，将上衣下裳连为一体，体现深意。",
      period: "战国至明代",
      characteristics: "上下连属、端庄大方、适用广泛",
    },
    {
      name: "袍服制",
      description: "一体裁剪的长衣，便于活动，逐渐成为日常服饰。",
      period: "汉代以后",
      characteristics: "一体裁剪、便于活动、日常实用",
    },
    {
      name: "襦裙制",
      description: "上衣下裙的女装组合，历代款式变化丰富多样。",
      period: "历代流行",
      characteristics: "上衣下裙、款式多样、女性特色",
    },
  ];
};

// 服饰部件数据 - 从后端加载
const components = ref([]);

// 加载服饰部件数据
const loadComponents = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/component");
    if (response.ok) {
      const data = await response.json();
      components.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        type: item.type,
        description: item.description,
      }));
    } else {
      console.error("加载服饰部件数据失败，响应状态:", response.status);
      // 使用默认数据
      setDefaultComponents();
    }
  } catch (error) {
    console.error("加载服饰部件数据失败:", error);
    // 使用默认数据
    setDefaultComponents();
  }
};

// 设置默认服饰部件数据
const setDefaultComponents = () => {
  components.value = [
    {
      id: 1,
      name: "衣",
      type: "上身服饰",
      description: "汉服的上身部分，包括各种款式的上衣。",
    },
    {
      id: 2,
      name: "裳",
      type: "下身服饰",
      description: "汉服的下身部分，主要指裙装。",
    },
    {
      id: 3,
      name: "袍",
      type: "一体服饰",
      description: "上下连属的长衣，有衬里的称袍。",
    },
    {
      id: 4,
      name: "衫",
      type: "一体服饰",
      description: "单层的长衣，无衬里的称衫。",
    },
    {
      id: 5,
      name: "襦",
      type: "上衣",
      description: "短上衣，通常与裙搭配穿着。",
    },
    {
      id: 6,
      name: "裙",
      type: "下裳",
      description: "下身穿着的裙装，款式多样。",
    },
    {
      id: 7,
      name: "裤",
      type: "下裳",
      description: "下身穿着的裤装，便于活动。",
    },
    {
      id: 8,
      name: "冠",
      type: "首服",
      description: "头上戴的冠帽，体现身份等级。",
    },
  ];
};

// 显示详情弹窗
const showDetail = async (type, item) => {
  try {
    if (type === "shape") {
      // 从后端获取形制详细信息
      const response = await fetch(`http://localhost:8082/api/shape-type/${item.id}`);
      if (response.ok) {
        const data = await response.json();
        // 解析特点（顿号分隔）
        const features = data.characteristics ? data.characteristics.split("、") : [];
        // 构建图片数组
        const images = [];
        if (data.image) {
          // 从后端获取的图片
          images.push({
            url: data.image,
            alt: data.name,
            caption: data.name,
          });
        } else {
          // 如果没有图片，使用默认图片
          images.push({
            url: `https://placehold.co/400x300/8B4513/FFFFFF?text=${encodeURIComponent(data.name)}`,
            alt: data.name,
            caption: data.name,
          });
        }
        // 构建详细内容
        Object.assign(currentDetail, {
          title: data.name,
          description: data.description,
          period: data.period,
          features: features,
          content: data.content || "",
          images: images,
        });
        dialogVisible.value = true;
      } else {
        ElMessage.error("获取详细信息失败");
      }
    } else if (type === "component") {
      // 从后端获取服饰部件详细信息
      const response = await fetch(`http://localhost:8082/api/component/${item.id}`);
      if (response.ok) {
        const data = await response.json();
        // 构建图片数组（1-2张）
        const images = [];
        if (data.image) {
          images.push({
            url: data.image,
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
        Object.assign(currentDetail, {
          title: `${data.name} - ${data.type}`,
          description: data.description,
          period: "",
          features: data.type ? [data.type] : [],
          content: data.content || "",
          images: images,
        });
        dialogVisible.value = true;
      } else {
        ElMessage.error("获取详细信息失败");
      }
    }
  } catch (error) {
    console.error("获取详细信息失败:", error);
    // 如果后端接口不可用，显示提示信息
    ElMessage.info("详细内容正在完善中...");
  }
};

// 关闭弹窗
const handleClose = (done) => {
  done();
};

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  window.scrollTo(0, 0);

  // 加载形制分类数据
  await loadShapeTypes();

  // 加载服饰部件数据
  await loadComponents();
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
.shape-classification-container {
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
.overview-content {
  display: block;
}

.overview-text p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 15px;
  text-align: justify;
}

/* 朝代网格样式 */
.dynasty-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.dynasty-card {
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  padding: 20px;
  background: linear-gradient(135deg, #f9f5f0 0%, #f0e6d6 100%);
  cursor: pointer;
  transition: all 0.3s ease;
}

.dynasty-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 15px rgba(139, 69, 19, 0.15);
  border-color: #d4a76a;
}

.dynasty-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.dynasty-name {
  margin: 0;
  color: #8b4513;
  font-size: 18px;
}

.dynasty-period {
  font-size: 12px;
  color: #999;
  background-color: white;
  padding: 4px 8px;
  border-radius: 4px;
}

.dynasty-desc {
  margin: 0 0 12px 0;
  color: #666;
  line-height: 1.5;
  font-size: 14px;
}

.shape-features {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.feature-tag {
  background-color: #8b4513;
  color: white;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 11px;
}

/* 基本形制样式 */
.shape-types {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.shape-type-card {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 20px;
  background-color: #fafafa;
  cursor: pointer;
  transition: all 0.3s ease;
}

.shape-type-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 15px rgba(139, 69, 19, 0.15);
  border-color: #d4a76a;
}

.shape-type-header {
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.shape-type-header h4 {
  margin: 0;
  color: #8b4513;
  font-size: 16px;
}

.shape-type-content p {
  margin: 0 0 12px 0;
  color: #666;
  line-height: 1.5;
  font-size: 14px;
}

.shape-details {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.detail-item {
  display: flex;
  align-items: flex-start;
}

.detail-label {
  font-size: 12px;
  color: #999;
  min-width: 70px;
}

.detail-value {
  font-size: 12px;
  color: #666;
  flex: 1;
}

/* 服饰部件样式 */
.components-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.component-card {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 15px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  background-color: white;
  transition: all 0.3s ease;
  cursor: pointer;
}

.component-card:hover {
  border-color: #d4a76a;
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.1);
  transform: translateY(-2px);
}

.component-icon {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.component-info {
  flex: 1;
}

.component-info h4 {
  margin: 0 0 6px 0;
  color: #8b4513;
  font-size: 14px;
}

.component-info p {
  margin: 0 0 6px 0;
  color: #666;
  font-size: 12px;
  line-height: 1.4;
}

.component-type {
  font-size: 11px;
  color: #999;
  background-color: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
}

/* 弹窗样式 */
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
  font-size: 22px;
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
  font-size: 16px;
  font-weight: 600;
  color: #8b4513;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid #f0e6dc;
}

.section-label .el-icon {
  font-size: 18px;
}

/* 简介区域 */
.description-section {
  margin-bottom: 20px;
}

.description-text {
  font-size: 16px;
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
  font-size: 15px;
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
  font-size: 14px;
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
  font-size: 16px;
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
  height: 300px;
  object-fit: contain;
  cursor: pointer;
  transition: all 0.3s ease;
  background-color: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
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
  height: 120px;
  background: #f5f7fa;
  color: #909399;
  flex-direction: column;
  border-radius: 8px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
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
  .dynasty-grid {
    grid-template-columns: 1fr;
  }

  .shape-types {
    grid-template-columns: 1fr;
  }

  .components-grid {
    grid-template-columns: repeat(2, 1fr);
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

  .image-grid {
    grid-template-columns: 1fr;
  }

  .detail-dialog {
    width: 90% !important;
  }
}

@media (max-width: 480px) {
  .components-grid {
    grid-template-columns: 1fr;
  }
}

/* 弹窗样式优化 */
:deep(.detail-dialog .el-dialog__header) {
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f8f5f0;
  border-bottom: 1px solid #d4a76a;
}

:deep(.detail-dialog .el-dialog__title) {
  color: #8b4513;
  font-size: 18px;
  font-weight: 600;
  text-align: center;
}

:deep(.detail-dialog .el-dialog__body) {
  padding: 20px;
  background-color: #fff;
  font-size: 16px;
  line-height: 1.6;
  color: #333;
}

:deep(.detail-dialog .el-dialog__footer) {
  background-color: #f8f5f0;
  border-top: 1px solid #d4a76a;
  padding: 15px 20px;
}

.content-section {
  margin-bottom: 20px;
}

.content-text {
  line-height: 1.6;
  color: #333;
  font-size: 18px;
}

.content-text p {
  margin: 0;
}

.image-gallery {
  margin-top: 20px;
}

.image-grid {
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 解决图片放大闪烁问题 */
:deep(.el-image-viewer__img) {
  transition: none !important;
  animation: none !important;
}

:deep(.el-image-viewer__mask) {
  transition: none !important;
  animation: none !important;
}

:deep(.el-image-viewer__close) {
  transition: none !important;
  animation: none !important;
}

:deep(.el-image-viewer__actions) {
  transition: none !important;
  animation: none !important;
}

:deep(.el-image-viewer) {
  transition: none !important;
  animation: none !important;
}

:deep(.el-image-viewer__canvas) {
  transition: none !important;
  animation: none !important;
}
</style>
