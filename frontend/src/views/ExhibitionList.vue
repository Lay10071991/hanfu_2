<template>
  <div class="exhibition-list-container">
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
        <h2 class="page-title">汉服展览列表</h2>

        <!-- 展览列表 -->
        <div class="exhibition-grid">
          <div
            class="exhibition-card"
            v-for="exhibition in paginatedExhibitions"
            :key="exhibition.id"
          >
            <div class="exhibition-img">
              <el-image :src="exhibition.image" fit="cover" />
            </div>
            <div class="exhibition-content">
              <h3>{{ exhibition.title }}</h3>
              <div class="exhibition-info">
                <div class="info-item">
                  <el-icon><Calendar /></el-icon>
                  <span>{{ exhibition.date }}</span>
                </div>
                <div class="info-item">
                  <el-icon><Location /></el-icon>
                  <span>{{ exhibition.location }}</span>
                </div>
              </div>
              <p class="exhibition-desc">{{ exhibition.description }}</p>
              <div class="exhibition-actions">
                <el-button type="primary" @click="viewDetail(exhibition)">查看详情</el-button>
              </div>
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

    <!-- 展览详情弹窗 -->
    <el-dialog
      v-model="detailDialogVisible"
      :title="selectedExhibition?.title"
      width="800px"
      :show-close="true"
    >
      <div v-if="selectedExhibition" class="exhibition-detail-dialog">
        <div class="detail-header">
          <el-image
            :src="selectedExhibition.detailImage || selectedExhibition.image"
            fit="cover"
            class="detail-image"
          />
        </div>
        <div class="detail-content">
          <div class="detail-info">
            <div class="info-row">
              <div class="info-item">
                <el-icon><Calendar /></el-icon>
                <div class="info-content">
                  <div class="info-label">展览时间</div>
                  <div class="info-value">{{ selectedExhibition.date }}</div>
                </div>
              </div>
              <div class="info-item">
                <el-icon><Location /></el-icon>
                <div class="info-content">
                  <div class="info-label">展览地点</div>
                  <div class="info-value">{{ selectedExhibition.location }}</div>
                </div>
              </div>
            </div>
            <div class="info-row">
              <div class="info-item">
                <el-icon><Ticket /></el-icon>
                <div class="info-content">
                  <div class="info-label">门票信息</div>
                  <div class="info-value">{{ selectedExhibition.ticket || "免费" }}</div>
                </div>
              </div>
              <div class="info-item">
                <el-icon><User /></el-icon>
                <div class="info-content">
                  <div class="info-label">主办单位</div>
                  <div class="info-value">{{ selectedExhibition.organizer }}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="detail-section">
            <h4>展览介绍</h4>
            <p>{{ selectedExhibition.detailDescription || selectedExhibition.description }}</p>
          </div>

          <div
            class="detail-section"
            v-if="selectedExhibition.highlights && selectedExhibition.highlights.length > 0"
          >
            <h4>展览亮点</h4>
            <ul class="highlight-list">
              <li v-for="(highlight, index) in selectedExhibition.highlights" :key="index">
                {{ highlight }}
              </li>
            </ul>
          </div>

          <div class="detail-section">
            <h4>参观须知</h4>
            <ul class="notice-list">
              <template
                v-if="
                  selectedExhibition &&
                  selectedExhibition.notice &&
                  selectedExhibition.notice.trim()
                "
              >
                <li
                  v-for="(noticeItem, index) in selectedExhibition.notice
                    .split('\n')
                    .filter((item) => item && item.trim())"
                  :key="index"
                >
                  {{ noticeItem.trim() }}
                </li>
              </template>
              <template v-else>
                <li>请提前预约参观时间</li>
                <li>保持安静，勿触摸展品</li>
                <li>禁止使用闪光灯拍照</li>
                <li>遵守展馆各项规定</li>
              </template>
            </ul>
          </div>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
          <el-button
            :type="
              selectedExhibition && isExhibitionExpired(selectedExhibition.date)
                ? 'danger'
                : selectedExhibition && exhibitionAppointments.has(selectedExhibition.id)
                  ? 'warning'
                  : 'primary'
            "
            :disabled="selectedExhibition && isExhibitionExpired(selectedExhibition.date)"
            @click="signUpExhibition"
            class="signup-btn"
          >
            {{
              selectedExhibition && isExhibitionExpired(selectedExhibition.date)
                ? "展览结束"
                : selectedExhibition && exhibitionAppointments.has(selectedExhibition.id)
                  ? "取消预约"
                  : "预约参观"
            }}
          </el-button>
        </span>
      </template>
    </el-dialog>

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
import { ElMessage, ElMessageBox } from "element-plus";
import { ArrowLeft, Calendar, Location, Ticket, User } from "@element-plus/icons-vue";

const router = useRouter();
const username = ref("");
const detailDialogVisible = ref(false);
const selectedExhibition = ref(null);

const exhibitions = ref([]);

// 预约状态管理
const exhibitionAppointments = ref(new Set());

// 初始化预约状态
const initAppointments = () => {
  const savedAppointments = localStorage.getItem("exhibitionAppointments");
  if (savedAppointments) {
    try {
      const appointments = JSON.parse(savedAppointments);
      exhibitionAppointments.value = new Set(appointments);
    } catch (error) {
      console.error("Failed to load appointments:", error);
    }
  }
};

// 解析展览结束日期
const parseExhibitionEndDate = (dateStr) => {
  // 处理 "2024年12月1日 至 2024年12月31日" 格式
  const match = dateStr.match(/至\s*(\d{4})年(\d{1,2})月(\d{1,2})日/);
  if (match) {
    return new Date(parseInt(match[1]), parseInt(match[2]) - 1, parseInt(match[3]));
  }
  // 处理单个日期格式
  const singleMatch = dateStr.match(/(\d{4})年(\d{1,2})月(\d{1,2})日/);
  if (singleMatch) {
    return new Date(
      parseInt(singleMatch[1]),
      parseInt(singleMatch[2]) - 1,
      parseInt(singleMatch[3]),
    );
  }
  return new Date(dateStr);
};

// 判断展览是否已过期
const isExhibitionExpired = (dateStr) => {
  const endDate = parseExhibitionEndDate(dateStr);
  const now = new Date();
  return endDate < now;
};

// 分页相关
const currentPage = ref(1);
const pageSize = ref(6);
const total = ref(0);

// 分页后的展览数据
const paginatedExhibitions = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return exhibitions.value.slice(start, end);
});

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
};

const loadExhibitions = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/exhibitions");
    if (response.ok) {
      const data = await response.json();
      console.log("从后端获取的展览数据:", data);
      exhibitions.value = data.map((exhibition) => ({
        id: exhibition.id,
        title: exhibition.title,
        date: formatDateRange(exhibition.startDate, exhibition.endDate),
        location: exhibition.location || "待定",
        image: exhibition.image || "http://localhost:8082/uploads/exhibition-1.png",
        detailImage: exhibition.image || "http://localhost:8082/uploads/exhibition-1.png",
        description: exhibition.description || "",
        detailDescription: exhibition.description || "",
        ticket: exhibition.ticketPrice ? `¥${exhibition.ticketPrice}` : "免费",
        organizer: exhibition.organizer || "汉服文化中心",
        notice:
          exhibition.notice !== undefined && exhibition.notice !== null
            ? exhibition.notice
            : "请提前预约参观时间\n保持安静，勿触摸展品\n禁止使用闪光灯拍照\n遵守展馆各项规定",
        highlights: ["精彩展览内容", "传统文化体验", "互动活动丰富"],
      }));
      console.log("处理后的展览数据:", exhibitions.value);
      total.value = exhibitions.value.length;
    }
  } catch (error) {
    console.error("加载展览数据失败:", error);
  }
};

const formatDateRange = (start, end) => {
  if (!start) return "待定";
  const startDate = new Date(start).toLocaleDateString("zh-CN");
  const endDate = end ? new Date(end).toLocaleDateString("zh-CN") : startDate;
  return `${startDate} 至 ${endDate}`;
};

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }

  initAppointments();
  await loadExhibitions();

  // 检查用户的预约状态
  const savedUserId = localStorage.getItem("userId");
  if (savedUserId) {
    await checkUserAppointments();
  }

  // 测试弹窗是否显示
  // setTimeout(() => {
  //   if (exhibitions.value.length > 0) {
  //     selectedExhibition.value = exhibitions.value[0];
  //     detailDialogVisible.value = true;
  //     console.log('Testing dialog visibility');
  //   }
  // }, 2000);
});

// 检查用户的预约状态
const checkUserAppointments = async () => {
  const userId = localStorage.getItem("userId");
  if (!userId) return;

  try {
    // 检查展览预约状态
    for (const exhibition of exhibitions.value) {
      const response = await fetch(
        `http://localhost:8082/api/exhibitions/${exhibition.id}/registration/check?userId=${userId}`,
      );
      if (response.ok) {
        const data = await response.json();
        if (data.isRegistered) {
          exhibitionAppointments.value.add(exhibition.id);
        }
      }
    }

    // 更新本地存储
    localStorage.setItem(
      "exhibitionAppointments",
      JSON.stringify([...exhibitionAppointments.value]),
    );
  } catch (error) {
    console.error("检查预约状态失败:", error);
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

const viewDetail = (exhibition) => {
  selectedExhibition.value = exhibition;
  detailDialogVisible.value = true;
};

const signUpExhibition = async () => {
  if (!selectedExhibition.value) return;

  const exhibitionId = selectedExhibition.value.id;
  const isExpired = isExhibitionExpired(selectedExhibition.value.date);
  const isAppointed = exhibitionAppointments.value.has(exhibitionId);

  if (isExpired) {
    ElMessage.info("展览已经结束，无法预约！");
    return;
  }

  const savedUserId = localStorage.getItem("userId");
  if (!savedUserId) {
    ElMessage.error("请先登录后再进行预约！");
    return;
  }

  const userId = parseInt(savedUserId);

  if (isAppointed) {
    // 取消预约
    ElMessageBox.confirm(`确定要取消预约"${selectedExhibition.value.title}"吗？`, "取消预约", {
      confirmButtonText: "确定取消",
      cancelButtonText: "取消",
      type: "warning",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/exhibitions/${exhibitionId}/registration?userId=${userId}`,
            { method: "DELETE" },
          );
          if (response.ok) {
            const data = await response.json();
            if (data.success) {
              exhibitionAppointments.value.delete(exhibitionId);
              localStorage.setItem(
                "exhibitionAppointments",
                JSON.stringify([...exhibitionAppointments.value]),
              );
              ElMessage.success(`成功取消预约"${selectedExhibition.value.title}"！`);
            } else {
              ElMessage.error("取消预约失败");
            }
          } else {
            ElMessage.error("取消预约失败");
          }
        } catch (error) {
          console.error("取消预约失败:", error);
          ElMessage.error("取消预约失败");
        }
      })
      .catch(() => {
        // 用户取消
      });
  } else {
    // 预约
    ElMessageBox.confirm(`确定要预约参观"${selectedExhibition.value.title}"吗？`, "预约确认", {
      confirmButtonText: "确定预约",
      cancelButtonText: "取消",
      type: "info",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/exhibitions/${exhibitionId}/registration`,
            {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ userId }),
            },
          );
          if (response.ok) {
            const data = await response.json();
            if (data.success) {
              exhibitionAppointments.value.add(exhibitionId);
              localStorage.setItem(
                "exhibitionAppointments",
                JSON.stringify([...exhibitionAppointments.value]),
              );
              ElMessage.success(`成功预约"${selectedExhibition.value.title}"！`);
            } else {
              ElMessage.error("预约失败");
            }
          } else {
            ElMessage.error("预约失败");
          }
        } catch (error) {
          console.error("预约失败:", error);
          ElMessage.error("预约失败");
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
.exhibition-list-container {
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

.exhibition-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 30px;
}

.exhibition-card {
  background-color: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.exhibition-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 30px rgba(139, 69, 19, 0.15);
}

.exhibition-img {
  height: 200px;
  overflow: hidden;
}

.exhibition-content {
  padding: 20px;
}

.exhibition-content h3 {
  margin: 0 0 15px 0;
  color: #8b4513;
  font-size: 20px;
}

.exhibition-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 15px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #666;
  font-size: 14px;
}

.info-item .el-icon {
  color: #8b4513;
}

.exhibition-desc {
  color: #666;
  line-height: 1.6;
  margin-bottom: 20px;
  font-size: 14px;
}

.exhibition-actions {
  display: flex;
  justify-content: flex-end;
}

.exhibition-actions .el-button {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: #8b4513;
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

/* 弹窗详情样式 */
.exhibition-detail-dialog {
  max-height: 70vh;
  overflow-y: auto;
}

.detail-header {
  margin-bottom: 20px;
}

.detail-image {
  width: 100%;
  height: 300px;
  border-radius: 8px;
  overflow: hidden;
}

.detail-content {
  padding: 0 10px;
}

.detail-info {
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
  margin-bottom: 15px;
}

.highlight-list,
.notice-list {
  padding-left: 20px;
  margin: 0;
}

.highlight-list li,
.notice-list li {
  color: #666;
  line-height: 1.8;
  margin-bottom: 8px;
}

.highlight-list li:last-child,
.notice-list li:last-child {
  margin-bottom: 0;
}

.highlight-list li {
  position: relative;
  padding-left: 10px;
}

.highlight-list li::before {
  content: "✨";
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

/* 修改预约按钮颜色 */
.signup-btn {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%) !important;
  border-color: #8b4513 !important;
}

.signup-btn:hover {
  background: linear-gradient(135deg, #7a3c10 0%, #b85c1a 100%) !important;
  border-color: #7a3c10 !important;
}

@media (max-width: 768px) {
  .exhibition-grid {
    grid-template-columns: 1fr;
  }

  .info-row {
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

  .detail-image {
    height: 200px;
  }
}
</style>
