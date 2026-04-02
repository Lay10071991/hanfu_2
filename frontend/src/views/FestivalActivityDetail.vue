<template>
  <div class="festival-activity-detail-container">
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
          <el-button type="text" @click="goBack" class="back-btn">
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
        </div>

        <!-- 页面标题 -->
        <h2 class="page-title">{{ festivalData.title }}</h2>

        <!-- 活动信息概览 -->
        <div class="festival-overview">
          <div class="overview-header">
            <div class="festival-image">
              <el-image :src="festivalData.image" fit="cover" class="main-image" />
              <div class="image-overlay">
                <el-tag type="success" size="large" class="festival-tag">
                  {{ getSeasonName(festivalData.season) }}
                </el-tag>
              </div>
            </div>

            <div class="overview-info">
              <div class="info-section">
                <h3>活动基本信息</h3>
                <div class="info-grid">
                  <div class="info-item">
                    <el-icon><Calendar /></el-icon>
                    <div class="info-content">
                      <div class="info-label">活动日期</div>
                      <div class="info-value">{{ festivalData.date }}</div>
                    </div>
                  </div>
                  <div class="info-item">
                    <el-icon><Location /></el-icon>
                    <div class="info-content">
                      <div class="info-label">活动地点</div>
                      <div class="info-value">{{ festivalData.location }}</div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="action-buttons">
                <el-button
                  :type="
                    isActivityExpired(festivalData.date)
                      ? 'danger'
                      : isSignedUp
                        ? 'warning'
                        : 'primary'
                  "
                  size="large"
                  @click="handleSignUp"
                  :disabled="isActivityExpired(festivalData.date)"
                >
                  <el-icon><Check /></el-icon>
                  {{
                    isActivityExpired(festivalData.date)
                      ? "活动结束"
                      : isSignedUp
                        ? "取消报名"
                        : "立即报名"
                  }}
                </el-button>
                <div class="registration-count">
                  <el-icon><User /></el-icon>
                  <span>已报名: {{ registrationCount }} 人</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 活动详细介绍 -->
        <div class="festival-details">
          <div class="details-section">
            <h3 class="section-title">
              <el-icon><Document /></el-icon>
              活动介绍
            </h3>
            <div class="section-content">
              <p>{{ festivalData.description }}</p>
              <div class="detailed-content" v-if="festivalData.detailedDescription">
                <p v-for="(paragraph, index) in festivalData.detailedDescription" :key="index">
                  {{ paragraph }}
                </p>
              </div>
            </div>
          </div>

          <div class="details-section" v-if="festivalData.traditionExperience">
            <h3 class="section-title">
              <el-icon><MagicStick /></el-icon>
              传统习俗体验
            </h3>
            <div class="section-content">
              <div class="tradition-content">
                <p
                  v-for="(line, index) in formatTraditionExperience(
                    festivalData.traditionExperience,
                  )"
                  :key="index"
                  class="tradition-line"
                >
                  {{ line }}
                </p>
              </div>
            </div>
          </div>

          <div class="details-section" v-if="festivalData.precautions">
            <h3 class="section-title">
              <el-icon><Warning /></el-icon>
              注意事项
            </h3>
            <div class="section-content">
              <ul class="notice-list">
                <li
                  v-for="(notice, index) in formatPrecautions(festivalData.precautions)"
                  :key="index"
                >
                  {{ notice }}
                </li>
              </ul>
            </div>
          </div>
        </div>

        <!-- 评论区 -->
        <div class="comments-section">
          <h3 class="section-title">
            <el-icon><ChatDotRound /></el-icon>
            活动评论
          </h3>
          <div class="comment-input">
            <el-input
              v-model="commentText"
              type="textarea"
              :rows="3"
              placeholder="写下您的评论..."
              maxlength="200"
              show-word-limit
            />
            <div class="comment-actions">
              <el-button type="primary" @click="submitComment" :disabled="!commentText.trim()">
                发表评论
              </el-button>
            </div>
          </div>

          <div class="comments-list" v-if="comments.length > 0">
            <div class="comment-item" v-for="comment in comments" :key="comment.id">
              <div class="comment-header">
                <div class="user-info">
                  <div class="user-name">{{ comment.username }}</div>
                </div>
              </div>
              <div class="comment-content">
                {{ comment.content }}
              </div>
            </div>
          </div>

          <div class="no-comments" v-else>
            <el-empty description="暂无评论，快来发表第一条评论吧！" />
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

    <!-- 报名成功提示 -->
    <el-dialog
      v-model="signUpDialogVisible"
      title="报名成功"
      width="400px"
      :show-close="false"
      center
    >
      <div class="dialog-content">
        <el-icon color="#67C23A" size="60px"><CircleCheck /></el-icon>
        <p style="margin-top: 20px; text-align: center">恭喜您成功报名参加活动！</p>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="signUpDialogVisible = false">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  ArrowLeft,
  Calendar,
  Location,
  User,
  Check,
  Document,
  MagicStick,
  Warning,
  ChatDotRound,
  CircleCheck,
} from "@element-plus/icons-vue";

const router = useRouter();
const route = useRoute();
const username = ref("");

// 活动数据
const festivalData = ref({
  id: null,
  title: "",
  season: "",
  date: "",
  location: "",
  image: "",
  description: "",
  traditionExperience: "",
  precautions: "",
});

// 用户状态
const isSignedUp = ref(false);
const commentText = ref("");
const signUpDialogVisible = ref(false);
const userId = ref(null);
const registrationCount = ref(0);

// 评论数据
const comments = ref([]);

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }

  const savedUserId = localStorage.getItem("userId");
  if (savedUserId) {
    userId.value = parseInt(savedUserId);
  }

  // 根据路由参数加载活动数据
  const festivalId = route.params.id;
  loadFestivalData(festivalId);

  // 检查用户是否已报名
  setTimeout(() => {
    checkUserStatus();
    loadRegistrationCount();
  }, 100);
});

// 根据季节获取季节名称
const getSeasonName = (season) => {
  const seasonMap = {
    spring: "春季",
    summer: "夏季",
    autumn: "秋季",
    winter: "冬季",
  };
  return seasonMap[season] || season;
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

// 加载活动数据
const loadFestivalData = async (id) => {
  try {
    // 从后端获取活动数据
    const response = await fetch(`http://localhost:8082/api/festival-activity/${id}`);
    if (response.ok) {
      const data = await response.json();
      // 确保数据字段映射正确
      festivalData.value = {
        id: data.id,
        title: data.title,
        season: data.season,
        date: data.date,
        location: data.location,
        image: data.image,
        description: data.description,
        traditionExperience: data.traditionExperience,
        precautions: data.precautions,
      };
    } else {
      console.error("获取活动数据失败，状态码:", response.status);
      // 加载失败，使用空数据
      festivalData.value = {
        id: null,
        title: "活动加载失败",
        season: "",
        date: "",
        location: "",
        image: "",
        description: "无法加载活动数据，请稍后再试",
        traditionExperience: "",
        precautions: "",
      };
    }
  } catch (error) {
    console.error("加载活动数据失败:", error);
    // 加载失败，使用空数据
    console.warn("加载活动数据失败，使用空数据");
    festivalData.value = {
      id: null,
      title: "活动加载失败",
      season: "",
      date: "",
      location: "",
      image: "",
      description: "无法加载活动数据，请稍后再试",
      traditionExperience: "",
      precautions: "",
    };
  }

  // 加载评论数据
  await loadComments(id);
};

// 加载评论数据
const loadComments = async (activityId) => {
  try {
    const response = await fetch(
      `http://localhost:8082/api/festival-activity/${activityId}/comments`,
    );
    if (response.ok) {
      const data = await response.json();
      comments.value = data.map((comment) => ({
        id: comment.id,
        username: comment.userName,
        content: comment.content,
        createdAt: comment.createTime,
      }));
    } else {
      console.error("加载评论数据失败:", response.status);
      // 加载失败，使用空数据
      comments.value = [];
    }
  } catch (error) {
    console.error("加载评论数据失败:", error);
    // 加载失败，使用空数据
    comments.value = [];
  }
};

// 加载报名人数
const loadRegistrationCount = async () => {
  try {
    const response = await fetch(
      `http://localhost:8082/api/festival-activity/${festivalData.value.id}/registration/count`,
    );
    if (response.ok) {
      const data = await response.json();
      registrationCount.value = data.count;
    }
  } catch (error) {
    console.error("加载报名人数失败:", error);
  }
};

// 检查用户状态
const checkUserStatus = async () => {
  if (!userId.value) {
    isSignedUp.value = false;
    return;
  }

  try {
    const response = await fetch(
      `http://localhost:8082/api/festival-activity/${festivalData.value.id}/registration/check?userId=${userId.value}`,
    );
    if (response.ok) {
      const data = await response.json();
      isSignedUp.value = data.isRegistered;
    }
  } catch (error) {
    console.error("检查报名状态失败:", error);
    isSignedUp.value = false;
  }
};

// 处理报名/取消报名
const handleSignUp = async () => {
  if (isActivityExpired(festivalData.value.date)) {
    ElMessage.info("活动已经结束，无法操作！");
    return;
  }

  if (!userId.value) {
    ElMessage.error("请先登录后再进行操作！");
    return;
  }

  if (isSignedUp.value) {
    ElMessageBox.confirm("确定要取消报名此活动吗？", "取消报名", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/festival-activity/${festivalData.value.id}/registration?userId=${userId.value}`,
            {
              method: "DELETE",
            },
          );
          if (response.ok) {
            isSignedUp.value = false;
            registrationCount.value = Math.max(0, registrationCount.value - 1);
            ElMessage.success("成功取消报名！");
          } else {
            ElMessage.error("取消报名失败");
          }
        } catch (error) {
          console.error("取消报名失败:", error);
          ElMessage.error("取消报名失败");
        }
      })
      .catch(() => {});
  } else {
    ElMessageBox.confirm("确定要报名参加此活动吗？", "报名确认", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "info",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/festival-activity/${festivalData.value.id}/registration`,
            {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({
                userId: userId.value,
              }),
            },
          );
          if (response.ok) {
            isSignedUp.value = true;
            registrationCount.value += 1;
            signUpDialogVisible.value = true;
          } else {
            ElMessage.error("报名失败");
          }
        } catch (error) {
          console.error("报名失败:", error);
          ElMessage.error("报名失败");
        }
      })
      .catch(() => {});
  }
};

// 提交评论
const submitComment = async () => {
  if (!commentText.value.trim()) return;

  if (!userId.value) {
    ElMessage.error("请先登录后再发表评论！");
    return;
  }

  try {
    const response = await fetch(
      `http://localhost:8082/api/festival-activity/${festivalData.value.id}/comments`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          userName: username.value,
          content: commentText.value.trim(),
        }),
      },
    );

    if (response.ok) {
      const newComment = await response.json();
      comments.value.push({
        id: newComment.id,
        username: newComment.userName,
        content: newComment.content,
        createdAt: newComment.createTime,
      });
      commentText.value = "";
      ElMessage.success("评论发表成功");
    } else {
      ElMessage.error("评论发表失败");
    }
  } catch (error) {
    console.error("提交评论失败:", error);
    ElMessage.error("评论发表失败");
  }
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
  // 检查是否从/profile页面跳转过来
  const fromProfile = router.options.history.state.back;
  if (fromProfile && fromProfile.includes("/profile")) {
    // 如果是从/profile页面跳转过来的，返回到/profile页面的节庆雅集标签页
    router.push("/profile?menu=activity-registrations");
  } else {
    // 否则，使用默认的返回方法
    router.back();
  }
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

// 格式化传统习俗体验数据
const formatTraditionExperience = (traditionExperience) => {
  if (!traditionExperience) return [];
  return traditionExperience.split("\\n").filter((line) => line.trim() !== "");
};

// 格式化注意事项数据
const formatPrecautions = (precautions) => {
  if (!precautions) return [];
  return precautions.split("\\n").filter((line) => line.trim() !== "");
};
</script>

<style scoped>
.festival-activity-detail-container {
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

.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.2);
}

.user-info-vertical {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  white-space: nowrap;
}

.user-info-vertical .user-name {
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

/* 主内容区 */
.main-content {
  padding: 30px 0;
  min-height: calc(100vh - 160px);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 返回按钮和标题 */
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

/* 活动概览 */
.festival-overview {
  background-color: white;
  border-radius: 12px;
  padding: 30px;
  margin-bottom: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.overview-header {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
}

.festival-image {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  height: 350px;
}

.main-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-overlay {
  position: absolute;
  bottom: 20px;
  right: 20px;
}

.festival-tag {
  font-size: 16px;
  padding: 8px 16px;
}

/* 基本信息 */
.overview-info {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.info-section h3 {
  margin: 0 0 20px 0;
  color: #8b4513;
  font-size: 22px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
  background-color: #f9f5f0;
  border-radius: 8px;
  border-left: 4px solid #d4a76a;
}

.info-item .el-icon {
  color: #8b4513;
  font-size: 24px;
}

.info-content {
  display: flex;
  flex-direction: column;
}

.info-label {
  font-size: 12px;
  color: #999;
  margin-bottom: 4px;
}

.info-value {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

/* 操作按钮 */
.action-buttons {
  display: flex;
  gap: 15px;
  margin-top: 20px;
}

.action-buttons .el-button {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 16px;
  padding: 12px 0;
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%) !important;
  border-color: #8b4513 !important;
  color: white !important;
}

.action-buttons .el-button:hover {
  background: linear-gradient(135deg, #d2691e 0%, #f0a830 100%) !important;
  border-color: #d2691e !important;
}

.action-buttons .el-button:disabled {
  background: #a9a9a9 !important;
  border-color: #a9a9a9 !important;
  cursor: not-allowed;
}

.registration-count {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: linear-gradient(135deg, #f5f5f5 0%, #e8e8e8 100%);
  border-radius: 8px;
  color: #666;
  font-size: 14px;
}

.registration-count .el-icon {
  color: #8b4513;
  font-size: 18px;
}

/* 活动详情 */
.festival-details {
  background-color: white;
  border-radius: 12px;
  padding: 30px;
  margin-bottom: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.details-section {
  margin-bottom: 30px;
}

.details-section:last-child {
  margin-bottom: 0;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 0 0 20px 0;
  color: #8b4513;
  font-size: 20px;
}

.section-title .el-icon {
  color: #d2691e;
}

.section-content {
  padding-left: 10px;
}

.section-content p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 15px;
}

/* 传统习俗体验 */
.tradition-content {
  padding: 15px;
  background: linear-gradient(135deg, #f9f5f0 0%, #f0e6d6 100%);
  border-radius: 10px;
  border: 1px solid #f0e6d6;
}

.tradition-line {
  margin: 0 0 12px 0;
  padding: 10px 15px;
  background-color: white;
  border-radius: 8px;
  border-left: 4px solid #d2691e;
  color: #555;
  line-height: 1.6;
  font-size: 15px;
  transition: all 0.3s ease;
}

.tradition-line:hover {
  transform: translateX(5px);
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.1);
}

.tradition-line:last-child {
  margin-bottom: 0;
}

/* 习俗体验（旧样式，保留兼容） */
.customs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.custom-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 20px;
  background: linear-gradient(135deg, #f9f5f0 0%, #f0e6d6 100%);
  border-radius: 10px;
  border: 1px solid #f0e6d6;
  transition: all 0.3s ease;
}

.custom-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
  background: linear-gradient(135deg, #f0e6d6 0%, #e8d8c4 100%);
}

.custom-icon {
  font-size: 32px;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: white;
  border-radius: 50%;
  flex-shrink: 0;
}

.custom-info h4 {
  margin: 0 0 8px 0;
  color: #8b4513;
  font-size: 18px;
}

.custom-info p {
  margin: 0;
  color: #666;
  font-size: 14px;
  line-height: 1.5;
}

/* 注意事项 */
.notice-list {
  padding-left: 20px;
  margin: 0;
}

.notice-list li {
  margin-bottom: 10px;
  color: #666;
  line-height: 1.6;
}

.notice-list li:last-child {
  margin-bottom: 0;
}

/* 评论区 */
.comments-section {
  background-color: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.comment-input {
  margin-bottom: 30px;
}

.comment-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 15px;
}

.comments-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.comment-item {
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
  border: 1px solid #eee;
}

.comment-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.user-info {
  display: flex;
  flex-direction: column;
}

.user-name {
  font-weight: bold;
  color: #333;
}

.comment-content {
  color: #666;
  line-height: 1.6;
}

.no-comments {
  text-align: center;
  padding: 40px 0;
}

/* 页脚 */
.footer {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  text-align: center;
  padding: 20px 0;
  margin-top: 30px;
}

.footer-subtitle {
  font-size: 12px;
  opacity: 0.8;
  margin-top: 5px;
}

/* 响应式设计 */
@media (max-width: 992px) {
  .overview-header {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .festival-image {
    height: 250px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .action-buttons {
    flex-direction: column;
  }

  .customs-grid {
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
}
</style>
