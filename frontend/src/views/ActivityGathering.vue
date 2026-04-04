<template>
  <div class="activity-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/knowledge')">汉服知识库</li>
          <li class="nav-item" @click="$router.push('/culture')">传统文化学习</li>
          <li class="nav-item active">汉服活动召集</li>
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
        <h2 class="page-title">汉服活动召集</h2>

        <!-- 轮播图 -->
        <div class="section">
          <div class="carousel-section">
            <h3 class="section-title">节庆雅集</h3>
            <el-button type="primary" class="btn-top-right" @click="viewMore('festival')"
              >更多</el-button
            >
          </div>
          <el-carousel height="300px" :interval="4000" arrow="always">
            <el-carousel-item v-for="item in carouselItems" :key="item.id">
              <div class="carousel-item">
                <el-image :src="item.image" :alt="item.title" fit="cover" class="carousel-image" />
                <div class="carousel-content">
                  <h3>{{ item.title }}</h3>
                  <p>{{ item.description }}</p>
                </div>
              </div>
            </el-carousel-item>
          </el-carousel>
        </div>

        <!-- 展览和讲座 -->
        <div class="activity-grid">
          <div class="activity-column">
            <div class="section">
              <div class="section-header">
                <h3 class="section-title">展览</h3>
                <el-button type="primary" class="btn-top-right" @click="viewMore('exhibition')"
                  >更多</el-button
                >
              </div>
              <div class="activity-list">
                <div
                  class="activity-item"
                  v-for="exhibition in displayedExhibitions"
                  :key="exhibition.id"
                  @click="viewActivity(exhibition)"
                >
                  <div class="activity-img">
                    <el-image :src="exhibition.image" fit="cover" />
                  </div>
                  <div class="activity-info">
                    <h4>{{ exhibition.title }}</h4>
                    <p>{{ exhibition.date }}</p>
                    <p>{{ exhibition.location }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="activity-column">
            <div class="section">
              <div class="section-header">
                <h3 class="section-title">讲座</h3>
                <el-button type="primary" class="btn-top-right" @click="viewMore('lecture')"
                  >更多</el-button
                >
              </div>
              <div class="activity-list">
                <div
                  class="activity-item"
                  v-for="lecture in displayedLectures"
                  :key="lecture.id"
                  @click="viewActivity(lecture)"
                >
                  <div class="activity-img">
                    <el-image :src="lecture.image" fit="cover" />
                  </div>
                  <div class="activity-info">
                    <h4>{{ lecture.title }}</h4>
                    <p>{{ lecture.speaker }}</p>
                    <p>{{ lecture.date }}</p>
                  </div>
                </div>
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

    <!-- 节庆详情对话框 -->
    <el-dialog v-model="showFestivalDialog" :title="selectedFestival?.title" width="600px" center>
      <div v-if="selectedFestival" class="detail-content">
        <div class="detail-image">
          <el-image
            :src="selectedFestival.image"
            :alt="selectedFestival.extitle"
            fit="cover"
            style="width: 100%; height: 300px; border-radius: 8px"
          />
        </div>
        <div class="detail-info">
          <div class="info-item">
            <span class="info-label">活动描述：</span>
            <p class="info-description">{{ selectedFestival.description }}</p>
          </div>
        </div>
      </div>
      <template #footer>
        <el-button @click="showFestivalDialog = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 展览详情对话框 -->
    <el-dialog
      v-model="showExhibitionDialog"
      :title="selectedExhibition?.title"
      width="800px"
      :show-close="true"
    >
      <div v-if="selectedExhibition" class="exhibition-detail-dialog">
        <div class="detail-header">
          <el-image :src="selectedExhibition.image" fit="contain" class="detail-image" />
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
                  <div class="info-value">{{ selectedExhibition.organizer || "汉服文化中心" }}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="detail-section">
            <h4>展览介绍</h4>
            <p>
              {{
                selectedExhibition.description ||
                "精彩的汉服文化展览，展示传统服饰的魅力与文化内涵。"
              }}
            </p>
          </div>

          <div class="detail-section">
            <h4>展览亮点</h4>
            <ul class="highlight-list">
              <template
                v-if="
                  selectedExhibition &&
                  selectedExhibition.highlights &&
                  selectedExhibition.highlights.trim()
                "
              >
                <li
                  v-for="(highlightItem, index) in selectedExhibition.highlights
                    .split('\n')
                    .filter((item) => item && item.trim())"
                  :key="index"
                >
                  {{ highlightItem.trim() }}
                </li>
              </template>
              <template v-else>
                <li>精彩展览内容</li>
                <li>传统文化体验</li>
                <li>互动活动丰富</li>
              </template>
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
          <el-button @click="showExhibitionDialog = false">关闭</el-button>
          <el-button
            :type="
              isExhibitionExpired(selectedExhibition.date)
                ? 'danger'
                : exhibitionAppointments.has(selectedExhibition.id)
                  ? 'warning'
                  : 'primary'
            "
            :disabled="isExhibitionExpired(selectedExhibition.date)"
            @click="signUpExhibition"
            class="signup-btn"
          >
            {{
              isExhibitionExpired(selectedExhibition.date)
                ? "展览结束"
                : exhibitionAppointments.has(selectedExhibition.id)
                  ? "取消预约"
                  : "预约参观"
            }}
          </el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 讲座详情对话框 -->
    <el-dialog v-model="showLectureDialog" :title="selectedLecture?.title" width="700px" center>
      <div v-if="selectedLecture" class="lecture-detail-content">
        <div class="detail-image">
          <el-image
            :src="selectedLecture.image"
            fit="contain"
            style="width: 100%; max-height: 300px; border-radius: 8px; background-color: #f9f5f0"
          />
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
                <div class="info-value">{{ selectedLecture.time || "待定" }}</div>
              </div>
            </div>
            <div class="info-item">
              <el-icon><Location /></el-icon>
              <div class="info-content">
                <div class="info-label">讲座地点</div>
                <div class="info-value">{{ selectedLecture.location || "待定" }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="detail-section">
          <h4>讲座简介</h4>
          <p>
            {{
              selectedLecture.description ||
              "专业的汉服文化讲座，深入浅出地讲解汉服知识与传统文化。"
            }}
          </p>
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
          <el-button @click="showLectureDialog = false">关闭</el-button>
          <el-button
            :type="
              isLectureExpired(selectedLecture.date)
                ? 'danger'
                : lectureAppointments.has(selectedLecture.id)
                  ? 'warning'
                  : 'primary'
            "
            :disabled="isLectureExpired(selectedLecture.date)"
            @click="signUpLecture"
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
import { Calendar, Location, Ticket, User, Clock } from "@element-plus/icons-vue";
import { getImageUrl } from "../utils/imageHelper.js";

const router = useRouter();
const username = ref("");

// 每页显示数量
const displayCount = ref(3);

// 对话框状态
const showFestivalDialog = ref(false);
const selectedFestival = ref(null);
const showExhibitionDialog = ref(false);
const selectedExhibition = ref(null);
const showLectureDialog = ref(false);
const selectedLecture = ref(null);

// 预约状态管理
const exhibitionAppointments = ref(new Set());
const lectureAppointments = ref(new Set());

// 初始化预约状态
const initAppointments = () => {
  // 加载展览预约
  const savedExhibitionAppointments = localStorage.getItem("exhibitionAppointments");
  if (savedExhibitionAppointments) {
    try {
      const appointments = JSON.parse(savedExhibitionAppointments);
      exhibitionAppointments.value = new Set(appointments);
    } catch (error) {
      console.error("Failed to load exhibition appointments:", error);
    }
  }

  // 加载讲座预约
  const savedLectureAppointments = localStorage.getItem("lectureAppointments");
  if (savedLectureAppointments) {
    try {
      const appointments = JSON.parse(savedLectureAppointments);
      lectureAppointments.value = new Set(appointments);
    } catch (error) {
      console.error("Failed to load lecture appointments:", error);
    }
  }
};

const carouselItems = ref([]);

const allExhibitions = ref([]);
const allLectures = ref([]);

// 将中文日期字符串转换为Date对象
const parseChineseDate = (dateStr) => {
  const match = dateStr.match(/(\d{4})年(\d{1,2})月(\d{1,2})日/);
  if (match) {
    return new Date(parseInt(match[1]), parseInt(match[2]) - 1, parseInt(match[3]));
  }
  return new Date(dateStr);
};

// 解析展览结束日期
const parseExhibitionEndDate = (dateStr) => {
  // 处理 "2024年12月1日 至 2024年12月31日" 格式
  const match = dateStr.match(/至\s*(\d{4})年(\d{1,2})月(\d{1,2})日/);
  if (match) {
    return new Date(parseInt(match[1]), parseInt(match[2]) - 1, parseInt(match[3]));
  }
  // 处理单个日期格式
  return parseChineseDate(dateStr);
};

// 判断展览是否已过期
const isExhibitionExpired = (dateStr) => {
  const endDate = parseExhibitionEndDate(dateStr);
  const now = new Date();
  return endDate < now;
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

// 加载节庆雅集数据（获取日期最近的3个）
const loadCarouselItems = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/festival-activity");
    if (response.ok) {
      const data = await response.json();
      const today = new Date();

      // 按日期距离今天最近的排序，取前3个
      const sortedData = data
        .map((item) => ({
          ...item,
          parsedDate: parseChineseDate(item.date),
        }))
        .sort((a, b) => {
          const diffA = Math.abs(a.parsedDate - today);
          const diffB = Math.abs(b.parsedDate - today);
          return diffA - diffB;
        })
        .slice(0, 3);

      carouselItems.value = sortedData.map((item) => ({
        id: item.id,
        title: item.name || item.title, // 确保使用正确的字段名
        description:
          item.description.substring(0, 50) + (item.description.length > 50 ? "..." : ""),
        image: getImageUrl(item.image),
      }));
    }
  } catch (error) {
    console.error("加载轮播图数据失败:", error);
  }
};

const loadActivities = async () => {
  try {
    // 加载轮播图数据
    await loadCarouselItems();

    // 加载展览数据
    const exhibitionResponse = await fetch("http://localhost:8082/api/exhibitions");
    if (exhibitionResponse.ok) {
      const exhibitionData = await exhibitionResponse.json();
      allExhibitions.value = exhibitionData.map((exhibition) => ({
        id: exhibition.id,
        title: exhibition.title,
        date: formatDateRange(exhibition.startDate, exhibition.endDate),
        location: exhibition.location || "待定",
        image: getImageUrl(exhibition.image) || "http://localhost:8082/uploads/exhibition-1.png",
        description: exhibition.description || "",
        organizer: exhibition.organizer || "汉服文化中心",
        ticket: exhibition.ticketPrice ? `¥${exhibition.ticketPrice}` : "免费",
        notice:
          exhibition.notice ||
          "请提前预约参观时间\n保持安静，勿触摸展品\n禁止使用闪光灯拍照\n遵守展馆各项规定",
        highlights: exhibition.highlights || "精彩展览内容\n传统文化体验\n互动活动丰富",
      }));
    }

    // 加载讲座数据
    const lectureResponse = await fetch("http://localhost:8082/api/lectures");
    if (lectureResponse.ok) {
      const lectureData = await lectureResponse.json();
      allLectures.value = lectureData.map((lecture) => ({
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
        image: getImageUrl(lecture.image) || "http://localhost:8082/uploads/talk/1.jpg",
        description: lecture.description || "",
        content: lecture.content || "",
        notice:
          lecture.notice ||
          "请提前10分钟到场签到\n讲座期间请保持安静\n可携带笔记本记录\n讲座结束后设有互动问答环节",
        capacity: lecture.capacity || 0,
        registeredCount: lecture.registeredCount || 0,
      }));
    }
  } catch (error) {
    console.error("加载活动数据失败:", error);
  }
};

const formatDateRange = (start, end) => {
  if (!start) return "待定";
  const startDate = new Date(start).toLocaleDateString("zh-CN");
  const endDate = end ? new Date(end).toLocaleDateString("zh-CN") : startDate;
  return `${startDate} 至 ${endDate}`;
};

const formatDateTime = (datetime) => {
  if (!datetime) return "待定";
  const date = new Date(datetime);
  return `${date.toLocaleDateString("zh-CN")} ${date.toLocaleTimeString("zh-CN", { hour: "2-digit", minute: "2-digit" })}`;
};

// 计算显示的展览数据（只显示3个，按距离当前时间最近排序）
const displayedExhibitions = computed(() => {
  const today = new Date();
  return [...allExhibitions.value]
    .map((exhibition) => {
      // 解析展览结束日期
      const endDate = parseExhibitionEndDate(exhibition.date);
      return {
        ...exhibition,
        distance: Math.abs(endDate - today),
      };
    })
    .sort((a, b) => a.distance - b.distance)
    .slice(0, displayCount.value);
});

// 计算显示的讲座数据（只显示3个，按距离当前时间最近排序）
const displayedLectures = computed(() => {
  const today = new Date();
  return [...allLectures.value]
    .map((lecture) => {
      // 解析讲座日期
      const match = lecture.date.match(/(\d{4})年(\d{1,2})月(\d{1,2})日/);
      let lectureDate;
      if (match) {
        lectureDate = new Date(parseInt(match[1]), parseInt(match[2]) - 1, parseInt(match[3]));
      } else {
        lectureDate = new Date(lecture.date);
      }
      return {
        ...lecture,
        distance: Math.abs(lectureDate - today),
      };
    })
    .sort((a, b) => a.distance - b.distance)
    .slice(0, displayCount.value);
});

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }

  // 先清空预约状态，确保从数据库重新获取
  exhibitionAppointments.value = new Set();
  lectureAppointments.value = new Set();

  await loadActivities();

  // 检查用户的预约和报名状态
  const savedUserId = localStorage.getItem("userId");
  if (savedUserId) {
    await checkUserAppointments();
  }
});

// 检查用户的预约和报名状态
const checkUserAppointments = async () => {
  const userId = localStorage.getItem("userId");
  if (!userId) return;

  try {
    // 检查展览预约状态
    for (const exhibition of allExhibitions.value) {
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

    // 检查讲座报名状态
    for (const lecture of allLectures.value) {
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
    localStorage.setItem(
      "exhibitionAppointments",
      JSON.stringify([...exhibitionAppointments.value]),
    );
    localStorage.setItem("lectureAppointments", JSON.stringify([...lectureAppointments.value]));
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

const viewMore = (type) => {
  const routeMap = {
    festival: "/festival-gathering",
    exhibition: "/exhibition-list", // 改为跳转到展览列表页面
    lecture: "/lecture-list", // 改为跳转到讲座列表页面
  };

  if (routeMap[type]) {
    router.push(routeMap[type]);
  }
};

const viewActivity = (activity) => {
  // 判断活动类型并显示相应的对话框
  if (activity.speaker) {
    // 讲座
    selectedLecture.value = activity;
    showLectureDialog.value = true;
  } else if (activity.location && activity.date.includes("至")) {
    // 展览
    selectedExhibition.value = activity;
    showExhibitionDialog.value = true;
  } else {
    // 节庆
    selectedFestival.value = activity;
    showFestivalDialog.value = true;
  }
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

const signUpLecture = async () => {
  if (!selectedLecture.value) return;

  const lectureId = selectedLecture.value.id;
  const isExpired = isLectureExpired(selectedLecture.value.date);
  const isAppointed = lectureAppointments.value.has(lectureId);

  if (isExpired) {
    ElMessage.info("讲座已经结束，无法报名！");
    return;
  }

  const savedUserId = localStorage.getItem("userId");
  if (!savedUserId) {
    ElMessage.error("请先登录后再进行报名！");
    return;
  }

  const userId = parseInt(savedUserId);

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
            { method: "DELETE" },
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
              ElMessage.error("取消报名失败");
            }
          } else {
            ElMessage.error("取消报名失败");
          }
        } catch (error) {
          console.error("取消报名失败:", error);
          ElMessage.error("取消报名失败");
        }
      })
      .catch(() => {
        // 用户取消
      });
  } else {
    // 报名
    ElMessageBox.confirm(`确定要报名参加"${selectedLecture.value.title}"讲座吗？`, "报名确认", {
      confirmButtonText: "确定报名",
      cancelButtonText: "取消",
      type: "info",
    })
      .then(async () => {
        try {
          const response = await fetch(
            `http://localhost:8082/api/lectures/${lectureId}/registration`,
            {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ userId }),
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
              ElMessage.error("报名失败");
            }
          } else {
            ElMessage.error("报名失败");
          }
        } catch (error) {
          console.error("报名失败:", error);
          ElMessage.error("报名失败");
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
.activity-container {
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

.section {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.carousel-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
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

.carousel-item {
  position: relative;
  height: 100%;
}

.carousel-image {
  width: 100%;
  height: 100%;
  border-radius: 8px;
}

.carousel-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  color: white;
  padding: 20px;
  border-radius: 0 0 8px 8px;
}

.carousel-content h3 {
  margin: 0 0 8px 0;
  font-size: 24px;
}

.carousel-content p {
  margin: 0;
  opacity: 0.9;
}

.activity-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.activity-column {
  display: flex;
  flex-direction: column;
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.activity-item {
  display: flex;
  align-items: center;
  padding: 12px;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.activity-item:hover {
  transform: translateX(5px);
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.1);
  border-color: #d4a76a;
}

.activity-img {
  width: 100px;
  height: 80px;
  border-radius: 4px;
  overflow: hidden;
  margin-right: 15px;
  flex-shrink: 0;
  background-color: #f9f5f0;
}

.activity-img img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.activity-info h4 {
  margin: 0 0 5px 0;
  color: #8b4513;
  font-size: 16px;
}

.activity-info p {
  margin: 2px 0;
  font-size: 12px;
  color: #666;
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

/* 详情对话框样式 */
.detail-content {
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

/* 展览详情弹窗样式 */
.exhibition-detail-dialog {
  max-height: 70vh;
  overflow-y: auto;
}

.detail-header {
  margin-bottom: 20px;
}

.detail-image {
  width: 100%;
  height: 200px;
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f9f5f0;
}

.detail-image img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
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
.notice-list,
.content-list {
  padding-left: 20px;
  margin: 0;
}

.highlight-list li,
.notice-list li,
.content-list li {
  color: #666;
  line-height: 1.8;
  margin-bottom: 8px;
}

.highlight-list li:last-child,
.notice-list li:last-child,
.content-list li:last-child {
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

.content-list li {
  position: relative;
  padding-left: 10px;
}

.content-list li::before {
  content: "📚";
  position: absolute;
  left: -15px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

/* 讲座详情弹窗样式 */
.lecture-detail-content {
  max-height: 70vh;
  overflow-y: auto;
  padding: 10px;
}

.detail-info-section {
  background-color: #f9f5f0;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
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
  .activity-grid {
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
