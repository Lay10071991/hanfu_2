<template>
  <div class="lecture-list-container">
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

        <!-- 页面标题 -->
        <h2 class="page-title">汉服讲座列表</h2>

        <!-- 讲座列表 -->
        <div class="lecture-grid">
          <div class="lecture-card" v-for="lecture in paginatedLectures" :key="lecture.id">
            <div class="lecture-image">
              <el-image :src="lecture.image" fit="cover" />
            </div>
            <div class="lecture-header">
              <h3>{{ lecture.title }}</h3>
              <div class="lecture-speaker">
                <el-icon><User /></el-icon>
                <span>{{ lecture.speaker }}</span>
              </div>
            </div>
            <div class="lecture-info">
              <div class="info-item">
                <el-icon><Calendar /></el-icon>
                <span>{{ lecture.date }}</span>
              </div>
              <div class="info-item">
                <el-icon><Clock /></el-icon>
                <span>{{ lecture.time }}</span>
              </div>
              <div class="info-item">
                <el-icon><Location /></el-icon>
                <span>{{ lecture.location }}</span>
              </div>
            </div>
            <p class="lecture-desc">{{ lecture.description }}</p>
            <div class="lecture-actions">
              <el-button type="primary" @click="viewDetail(lecture)">查看详情</el-button>
              <el-button
                :type="
                  isLectureExpired(lecture.date)
                    ? 'danger'
                    : lectureAppointments.has(lecture.id)
                      ? 'warning'
                      : 'primary'
                "
                :disabled="isLectureExpired(lecture.date)"
                @click="signUp(lecture)"
                class="signup-btn"
              >
                {{
                  isLectureExpired(lecture.date)
                    ? "讲座结束"
                    : lectureAppointments.has(lecture.id)
                      ? "取消报名"
                      : "立即报名"
                }}
              </el-button>
            </div>
          </div>
        </div>

        <!-- 分页组件 -->
        <div class="pagination-wrapper">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :total="total"
            :page-sizes="[6]"
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

    <!-- 讲座详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="selectedLecture?.title" width="700px" center>
      <div v-if="selectedLecture" class="lecture-detail-content">
        <div class="detail-image">
          <el-image :src="selectedLecture.image" fit="cover" />
        </div>
        <div class="detail-info-section">
          <div class="info-row">
            <div class="info-item">
              <el-icon><User /></el-icon>
              <div class="info-content">
                <div class="info-label">主讲人</div>
                <div class="info-value">{{ selectedLecture.speaker }}</div>
              </div>
            </div>
            <div class="info-item">
              <el-icon><Calendar /></el-icon>
              <div class="info-content">
                <div class="info-label">讲座日期</div>
                <div class="info-value">{{ selectedLecture.date }}</div>
              </div>
            </div>
          </div>
          <div class="info-row">
            <div class="info-item">
              <el-icon><Clock /></el-icon>
              <div class="info-content">
                <div class="info-label">讲座时间</div>
                <div class="info-value">{{ selectedLecture.time }}</div>
              </div>
            </div>
            <div class="info-item">
              <el-icon><Location /></el-icon>
              <div class="info-content">
                <div class="info-label">讲座地点</div>
                <div class="info-value">{{ selectedLecture.location }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="detail-section">
          <h4>讲座简介</h4>
          <p>{{ selectedLecture.description }}</p>
        </div>

        <div class="detail-section">
          <h4>主讲人简介</h4>
          <p>
            {{
              selectedLecture.speakerBio ||
              "资深汉服文化研究者，长期从事传统服饰文化的研究与推广工作。"
            }}
          </p>
        </div>

        <div class="detail-section">
          <h4>讲座内容</h4>
          <ul class="content-list">
            <template
              v-if="selectedLecture && selectedLecture.content && selectedLecture.content.trim()"
            >
              <li
                v-for="(contentItem, index) in selectedLecture.content
                  .split('\n')
                  .filter((item) => item && item.trim())"
                :key="index"
              >
                {{ contentItem.trim() }}
              </li>
            </template>
            <template v-else>
              <li>汉服的历史起源与发展脉络</li>
              <li>各朝代汉服的特点与区别</li>
              <li>汉服的基本构成与穿着方法</li>
              <li>现代汉服的传承与创新</li>
            </template>
          </ul>
        </div>

        <div class="detail-section">
          <h4>参与须知</h4>
          <ul class="notice-list">
            <template
              v-if="selectedLecture && selectedLecture.notice && selectedLecture.notice.trim()"
            >
              <li
                v-for="(noticeItem, index) in selectedLecture.notice
                  .split('\n')
                  .filter((item) => item && item.trim())"
                :key="index"
              >
                {{ noticeItem.trim() }}
              </li>
            </template>
            <template v-else>
              <li>请提前10分钟到场签到</li>
              <li>讲座期间请保持安静</li>
              <li>可携带笔记本记录</li>
              <li>讲座结束后设有互动问答环节</li>
            </template>
          </ul>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
          <el-button
            :type="
              isLectureExpired(selectedLecture.date)
                ? 'danger'
                : lectureAppointments.has(selectedLecture.id)
                  ? 'warning'
                  : 'primary'
            "
            :disabled="isLectureExpired(selectedLecture.date)"
            @click="signUpFromDialog"
            class="signup-btn"
          >
            {{
              isLectureExpired(selectedLecture.date)
                ? "讲座结束"
                : lectureAppointments.has(selectedLecture.id)
                  ? "取消报名"
                  : "立即报名"
            }}
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useRouter } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";
import { ArrowLeft, Calendar, Clock, Location, User } from "@element-plus/icons-vue";

const router = useRouter();
const username = ref("");
const detailDialogVisible = ref(false);
const selectedLecture = ref(null);

const lectures = ref([]);

// 报名状态管理
const lectureAppointments = ref(new Set());

// 初始化报名状态
const initAppointments = () => {
  const savedAppointments = localStorage.getItem("lectureAppointments");
  if (savedAppointments) {
    try {
      const appointments = JSON.parse(savedAppointments);
      lectureAppointments.value = new Set(appointments);
    } catch (error) {
      console.error("Failed to load lecture appointments:", error);
    }
  }
};

// 判断讲座是否已过期
const isLectureExpired = (dateStr) => {
  // 解析讲座日期
  const match = dateStr.match(/(\d{4})年(\d{1,2})月(\d{1,2})日/);
  if (match) {
    const lectureDate = new Date(parseInt(match[1]), parseInt(match[2]) - 1, parseInt(match[3]));
    const now = new Date();
    return lectureDate < now;
  }
  return false;
};

// 分页相关
const currentPage = ref(1);
const pageSize = ref(6);
const total = ref(0);

// 分页后的讲座数据
const paginatedLectures = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return lectures.value.slice(start, end);
});

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
};

// 图片URL处理函数
const getImageUrl = (url) => {
  if (!url) return "";
  if (url.startsWith("http://") || url.startsWith("https://")) {
    return url;
  }
  const path = url.startsWith("/") ? url : `/${url}`;
  return `http://localhost:8082${path}`;
};

const loadLectures = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/lectures");
    if (response.ok) {
      const data = await response.json();
      lectures.value = data.map((lecture) => ({
        id: lecture.id,
        title: lecture.title,
        speaker: lecture.speaker || "待定",
        speakerBio: lecture.speakerBio || "",
        date: lecture.startTime ? new Date(lecture.startTime).toLocaleDateString("zh-CN") : "待定",
        time:
          lecture.startTime && lecture.endTime
            ? `${new Date(lecture.startTime).toLocaleTimeString("zh-CN", { hour: "2-digit", minute: "2-digit" })}-${new Date(lecture.endTime).toLocaleTimeString("zh-CN", { hour: "2-digit", minute: "2-digit" })}`
            : "待定",
        location: lecture.location || "待定",
        description: lecture.description || "",
        content: lecture.content || "",
        notice:
          lecture.notice ||
          "请提前10分钟到场签到\n讲座期间请保持安静\n可携带笔记本记录\n讲座结束后设有互动问答环节",
        image: getImageUrl(lecture.image) || "http://localhost:8082/uploads/talk/1.jpg",
      }));
      total.value = lectures.value.length;
    }
  } catch (error) {
    console.error("加载讲座数据失败:", error);
  }
};

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }

  initAppointments();
  await loadLectures();

  // 检查用户的报名状态
  const savedUserId = localStorage.getItem("userId");
  if (savedUserId) {
    await checkUserAppointments();
  }
});

// 检查用户的报名状态
const checkUserAppointments = async () => {
  const userId = localStorage.getItem("userId");
  if (!userId) return;

  try {
    // 检查讲座报名状态
    for (const lecture of lectures.value) {
      const response = await fetch(
        `http://localhost:8082/api/lectures/${lecture.id}/registration/check?userId=${userId}`,
      );
      if (response.ok) {
        const data = await response.json();
        if (data.isRegistered) {
          lectureAppointments.value.add(lecture.id);
        }
      }
    }

    // 更新本地存储
    localStorage.setItem("lectureAppointments", JSON.stringify([...lectureAppointments.value]));
  } catch (error) {
    console.error("检查报名状态失败:", error);
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

const viewDetail = (lecture) => {
  selectedLecture.value = lecture;
  detailDialogVisible.value = true;
};

const getDefaultContents = () => {
  return [
    "汉服的历史起源与发展脉络",
    "各朝代汉服的特点与区别",
    "汉服的基本构成与穿着方法",
    "现代汉服的传承与创新",
  ];
};

const signUpFromDialog = async () => {
  if (!selectedLecture.value) return;

  const lectureId = selectedLecture.value.id;
  const isExpired = isLectureExpired(selectedLecture.value.date);
  const isAppointed = lectureAppointments.value.has(lectureId);
  const userId = localStorage.getItem("userId");

  if (!userId) {
    ElMessage.warning("请先登录后再报名！");
    return;
  }

  if (isExpired) {
    ElMessage.info("讲座已经结束，无法报名！");
    return;
  }

  if (isAppointed) {
    // 取消报名
    ElMessageBox.confirm(`确定要取消报名"${selectedLecture.value.title}"讲座吗？`, "取消报名", {
      confirmButtonText: "确定取消",
      cancelButtonText: "取消",
      type: "warning",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/lectures/${lectureId}/registration?userId=${userId}`,
            {
              method: "DELETE",
            },
          );

          if (response.ok) {
            const data = await response.json();
            if (data.success) {
              lectureAppointments.value.delete(lectureId);
              localStorage.setItem(
                "lectureAppointments",
                JSON.stringify([...lectureAppointments.value]),
              );
              ElMessage.success(`成功取消报名"${selectedLecture.value.title}"讲座！`);
            } else {
              ElMessage.error("取消报名失败！");
            }
          } else {
            ElMessage.error("网络错误，请稍后重试！");
          }
        } catch (error) {
          console.error("取消报名失败:", error);
          ElMessage.error("取消报名失败，请稍后重试！");
        }
      })
      .catch(() => {
        // 用户取消
      });
  } else {
    // 报名
    ElMessageBox.confirm(`确定要报名参加"${selectedLecture.value.title}"讲座吗？`, "报名确认", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "info",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/lectures/${lectureId}/registration`,
            {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
              },
              body: JSON.stringify({ userId: parseInt(userId) }),
            },
          );

          if (response.ok) {
            const data = await response.json();
            if (data.success) {
              lectureAppointments.value.add(lectureId);
              localStorage.setItem(
                "lectureAppointments",
                JSON.stringify([...lectureAppointments.value]),
              );
              ElMessage.success(`成功报名"${selectedLecture.value.title}"讲座！`);
            } else {
              ElMessage.error("报名失败！");
            }
          } else {
            ElMessage.error("网络错误，请稍后重试！");
          }
        } catch (error) {
          console.error("报名失败:", error);
          ElMessage.error("报名失败，请稍后重试！");
        }
      })
      .catch(() => {
        // 用户取消
      });
  }
};

const signUp = async (lecture) => {
  const lectureId = lecture.id;
  const isExpired = isLectureExpired(lecture.date);
  const isAppointed = lectureAppointments.value.has(lectureId);
  const userId = localStorage.getItem("userId");

  if (!userId) {
    ElMessage.warning("请先登录后再报名！");
    return;
  }

  if (isExpired) {
    ElMessage.info("讲座已经结束，无法报名！");
    return;
  }

  if (isAppointed) {
    // 取消报名
    ElMessageBox.confirm(`确定要取消报名"${lecture.title}"讲座吗？`, "取消报名", {
      confirmButtonText: "确定取消",
      cancelButtonText: "取消",
      type: "warning",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/lectures/${lectureId}/registration?userId=${userId}`,
            {
              method: "DELETE",
            },
          );

          if (response.ok) {
            const data = await response.json();
            if (data.success) {
              lectureAppointments.value.delete(lectureId);
              localStorage.setItem(
                "lectureAppointments",
                JSON.stringify([...lectureAppointments.value]),
              );
              ElMessage.success(`成功取消报名"${lecture.title}"讲座！`);
            } else {
              ElMessage.error("取消报名失败！");
            }
          } else {
            ElMessage.error("网络错误，请稍后重试！");
          }
        } catch (error) {
          console.error("取消报名失败:", error);
          ElMessage.error("取消报名失败，请稍后重试！");
        }
      })
      .catch(() => {
        // 用户取消
      });
  } else {
    // 报名
    ElMessageBox.confirm(`确定要报名参加"${lecture.title}"讲座吗？`, "报名确认", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "info",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/lectures/${lectureId}/registration`,
            {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
              },
              body: JSON.stringify({ userId: parseInt(userId) }),
            },
          );

          if (response.ok) {
            const data = await response.json();
            if (data.success) {
              lectureAppointments.value.add(lectureId);
              localStorage.setItem(
                "lectureAppointments",
                JSON.stringify([...lectureAppointments.value]),
              );
              ElMessage.success(`成功报名"${lecture.title}"讲座！`);
            } else {
              ElMessage.error("报名失败！");
            }
          } else {
            ElMessage.error("网络错误，请稍后重试！");
          }
        } catch (error) {
          console.error("报名失败:", error);
          ElMessage.error("报名失败，请稍后重试！");
        }
      })
      .catch(() => {
        // 用户取消
      });
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
.lecture-list-container {
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

.lecture-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
}

.lecture-card {
  background-color: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.lecture-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 30px rgba(139, 69, 19, 0.15);
}

.lecture-image {
  width: 100%;
  margin-bottom: 20px;
  overflow: hidden;
  border-radius: 8px;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f9f5f0;
}

.lecture-image img {
  width: 100%;
  height: auto;
  object-fit: cover;
  display: block;
}

.lecture-header {
  margin-bottom: 20px;
}

.lecture-header h3 {
  margin: 0 0 10px 0;
  color: #8b4513;
  font-size: 20px;
}

.lecture-speaker {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #666;
  font-size: 14px;
}

.lecture-speaker .el-icon {
  color: #8b4513;
}

.lecture-info {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
  margin-bottom: 20px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #666;
  font-size: 13px;
}

.info-item .el-icon {
  color: #8b4513;
  flex-shrink: 0;
}

.lecture-desc {
  color: #666;
  line-height: 1.6;
  margin-bottom: 25px;
  font-size: 14px;
}

.lecture-actions {
  display: flex;
  gap: 15px;
}

.lecture-actions .el-button {
  flex: 1;
}

.lecture-actions .el-button:first-child {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: #8b4513;
}

/* 修改立即报名按钮样式 */
.signup-btn {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%) !important;
  border-color: #8b4513 !important;
}

.signup-btn:hover {
  background: linear-gradient(135deg, #7a3c10 0%, #b85c1a 100%) !important;
  border-color: #7a3c10 !important;
}

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

/* 分页样式 */
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 30px;
  padding: 20px 0;
}

/* 讲座详情对话框样式 */
.lecture-detail-content {
  max-height: 70vh;
  overflow-y: auto;
  padding: 10px;
}

.detail-image {
  width: 100%;
  height: 250px;
  margin-bottom: 20px;
  overflow: hidden;
  border-radius: 8px;
}

.detail-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.detail-info-section {
  background-color: #f9f5f0;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
}

.info-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 15px;
}

.info-row:last-child {
  margin-bottom: 0;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 15px;
}

.info-item .el-icon {
  color: #8b4513;
  font-size: 24px;
  flex-shrink: 0;
}

.info-content {
  flex: 1;
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

.detail-section {
  margin-bottom: 25px;
}

.detail-section h4 {
  color: #8b4513;
  font-size: 18px;
  margin: 0 0 15px 0;
  padding-bottom: 8px;
  border-bottom: 2px solid #d4a76a;
}

.detail-section p {
  color: #666;
  line-height: 1.8;
  margin: 0;
}

.content-list,
.notice-list {
  padding-left: 20px;
  margin: 0;
}

.content-list li,
.notice-list li {
  color: #666;
  line-height: 1.8;
  margin-bottom: 8px;
}

.content-list li:last-child,
.notice-list li:last-child {
  margin-bottom: 0;
}

.content-list li {
  position: relative;
  padding-left: 10px;
}

.content-list li::before {
  content: "📚";
  position: absolute;
  left: -15px;
}

.notice-list li {
  position: relative;
  padding-left: 10px;
}

.notice-list li::before {
  content: "•";
  position: absolute;
  left: -10px;
  color: #8b4513;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

@media (max-width: 1200px) {
  .lecture-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .lecture-grid {
    grid-template-columns: 1fr;
  }

  .lecture-info {
    grid-template-columns: 1fr;
  }

  .lecture-actions {
    flex-direction: column;
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

  .info-row {
    grid-template-columns: 1fr;
  }

  .detail-image {
    height: 200px;
  }
}
</style>
