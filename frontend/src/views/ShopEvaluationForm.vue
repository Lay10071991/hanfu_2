<template>
  <div class="evaluation-form-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/')">汉服知识库</li>
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
        <!-- 页面标题区域 -->
        <div class="page-header-vertical">
          <el-button type="text" @click="$router.back()" class="back-btn-vertical">
            <el-icon><ArrowLeft /></el-icon> 返回
          </el-button>
          <h2 class="page-title-vertical">店铺评价</h2>
          <p class="page-subtitle">请分享您对店铺的真实感受</p>
        </div>

        <!-- 店铺信息卡片 -->
        <div class="shop-info-card" v-if="shopInfo">
          <div class="shop-basic-info">
            <el-image :src="shopInfo.image" :alt="shopInfo.name" class="shop-image" fit="cover" />
            <div class="shop-details">
              <h3 class="shop-name">{{ shopInfo.name }}</h3>
              <div class="shop-rating">
                <el-rate v-model="shopInfo.rating" disabled />
                <span class="rating-text">{{ shopInfo.rating }}分</span>
              </div>
              <p class="shop-description">{{ shopInfo.description }}</p>
              <div class="shop-tags">
                <el-tag v-for="tag in shopInfo.tags" :key="tag" size="small" type="primary">
                  {{ tag }}
                </el-tag>
              </div>
            </div>
          </div>
        </div>

        <!-- 评价表单 -->
        <div class="form-container">
          <el-form
            ref="evaluationFormRef"
            :model="evaluationForm"
            :rules="evaluationRules"
            label-position="top"
            class="evaluation-form"
          >
            <!-- 总体评分 -->
            <el-form-item label="总体评分" prop="overallRating" class="form-item">
              <div class="rating-section">
                <el-rate
                  v-model="evaluationForm.overallRating"
                  :colors="['#99A9BF', '#F7BA2A', '#FF9900']"
                  size="large"
                  show-score
                  text-color="#ff9900"
                  score-template="{value} 分"
                />
                <span class="rating-hint">请点击星星进行评分</span>
              </div>
            </el-form-item>

            <!-- 详细评价 -->
            <el-form-item label="详细评价" prop="content" class="form-item">
              <el-input
                v-model="evaluationForm.content"
                type="textarea"
                :rows="5"
                placeholder="请详细描述您的购物体验、商品质量、服务态度等..."
                maxlength="500"
                show-word-limit
              />
            </el-form-item>

            <!-- 提交按钮 -->
            <div class="form-actions">
              <el-button type="info" @click="$router.back()">取消</el-button>
              <el-button type="primary" @click="submitEvaluation" :loading="submitting">
                提交评价
              </el-button>
            </div>
          </el-form>
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
import { useRouter, useRoute } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";
import { ArrowLeft } from "@element-plus/icons-vue";

const router = useRouter();
const route = useRoute();
const shopId = route.params.id;
const username = ref("");

const shopInfo = ref(null);

// 评价表单数据（简化版）
const evaluationForm = ref({
  overallRating: 0,
  content: "",
});

// 表单验证规则
const evaluationRules = {
  overallRating: [{ required: true, message: "请选择总体评分", trigger: "change" }],
  content: [{ max: 500, message: "评价内容最多500个字符", trigger: "blur" }],
};

const submitting = ref(false);
const evaluationFormRef = ref();

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  fetchShopInfo();
});

const fetchShopInfo = async () => {
  try {
    const response = await fetch(`http://localhost:8082/api/shops/${shopId}`);
    if (response.ok) {
      const shop = await response.json();
      shopInfo.value = {
        id: shop.id,
        name: shop.name,
        image: shop.image
          ? shop.image.startsWith("http")
            ? shop.image
            : `http://localhost:8082${shop.image}`
          : "",
        rating: shop.averageRating || 0,
        reviewCount: shop.reviewCount || 0,
        description: shop.description || "",
        tags: [],
      };
    } else {
      ElMessage.error("获取店铺信息失败");
    }
  } catch (error) {
    console.error("获取店铺信息失败", error);
    ElMessage.error("网络异常，请稍后重试");
  }
};

// 提交评价
const submitEvaluation = async () => {
  if (!evaluationFormRef.value) return;

  try {
    await evaluationFormRef.value.validate();

    submitting.value = true;

    // 获取当前用户ID
    let userId = null;
    const userStr = localStorage.getItem("user");
    if (userStr) {
      try {
        const user = JSON.parse(userStr);
        userId = user.id;
      } catch (e) {
        console.error("解析用户信息失败", e);
      }
    }

    if (!userId) {
      ElMessage.warning("请先登录后再提交评价");
      submitting.value = false;
      return;
    }

    const submitData = {
      shopId: Number(shopId),
      userId: userId,
      rating: evaluationForm.value.overallRating,
      content: evaluationForm.value.content,
    };

    const response = await fetch("http://localhost:8082/api/evaluations", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(submitData),
    });

    if (response.ok) {
      ElMessage.success("评价提交成功！");
      ElMessageBox.alert("感谢您的评价！您的反馈将帮助其他用户做出更好的选择。", "提交成功", {
        confirmButtonText: "确定",
        callback: () => {
          router.push(`/shop-detail/${shopId}`);
        },
      });
    } else {
      ElMessage.error("提交失败，请稍后重试");
    }
  } catch (error) {
    if (error !== "cancel") {
      console.error("提交评价失败", error);
      ElMessage.error("提交失败，请稍后重试");
    }
  } finally {
    submitting.value = false;
  }
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
.evaluation-form-container {
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
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 页面标题区域 */
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
}

.page-subtitle {
  margin: 0;
  color: #666;
  font-size: 14px;
  padding-left: 16px;
}

/* 店铺信息卡片 */
.shop-info-card {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.shop-basic-info {
  display: flex;
  gap: 20px;
}

.shop-image {
  width: 120px;
  height: 90px;
  border-radius: 6px;
  flex-shrink: 0;
}

.shop-details {
  flex: 1;
}

.shop-name {
  margin: 0 0 8px 0;
  color: #8b4513;
  font-size: 18px;
  font-weight: bold;
}

.shop-rating {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.rating-text {
  color: #ff9900;
  font-weight: bold;
}

.shop-description {
  margin: 0 0 12px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.4;
}

.shop-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

/* 表单容器 */
.form-container {
  background-color: white;
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.evaluation-form {
  max-width: 600px;
  margin: 0 auto;
}

.form-item {
  margin-bottom: 24px;
}

/* 评分区域 */
.rating-section {
  display: flex;
  align-items: center;
  gap: 20px;
}

.rating-hint {
  color: #999;
  font-size: 12px;
}

/* 表单操作按钮 */
.form-actions {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.form-actions .el-button {
  min-width: 120px;
}

.form-actions .el-button--primary {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: transparent;
  color: white;
}

.form-actions .el-button--primary:hover {
  background: linear-gradient(135deg, #d2691e 0%, #8b4513 100%);
  border-color: transparent;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

.form-actions .el-button--primary:active {
  background: linear-gradient(135deg, #7a3d10 0%, #c15a18 100%);
  transform: translateY(0);
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
  .container {
    padding: 0 15px;
  }

  .form-container {
    padding: 20px;
  }

  .shop-basic-info {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .shop-image {
    width: 100%;
    max-width: 200px;
    height: 150px;
  }

  .rating-section {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .form-actions {
    flex-direction: column;
    gap: 10px;
  }

  .form-actions .el-button {
    width: 100%;
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

  .page-title-vertical {
    font-size: 24px;
  }
}
</style>
