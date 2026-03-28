<template>
  <div class="festival-detail-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo" @click="$router.push('/knowledge')">汉服文化交流平台</div>
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
        <div class="page-header">
          <el-button type="text" @click="goBack" class="back-btn">
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
          <h2 class="page-title">古代节俗礼仪</h2>
        </div>

        <!-- 节俗分类 -->
        <div class="category-section">
          <div class="category-filter">
            <el-radio-group v-model="activeSeason" @change="handleSeasonChange">
              <el-radio-button label="all">全部季节</el-radio-button>
              <el-radio-button label="spring">春季</el-radio-button>
              <el-radio-button label="summer">夏季</el-radio-button>
              <el-radio-button label="autumn">秋季</el-radio-button>
              <el-radio-button label="winter">冬季</el-radio-button>
            </el-radio-group>
          </div>

          <!-- 节俗列表 -->
          <div class="festival-grid">
            <div
              class="festival-card"
              v-for="festival in paginatedFestivals"
              :key="festival.id"
              @click="viewFestivalDetail(festival)"
            >
              <div class="festival-header">
                <div class="festival-image">
                  <el-image :src="festival.image" :alt="festival.name" fit="cover">
                    <template #error>
                      <div class="image-slot">
                        <el-icon><Picture /></el-icon>
                      </div>
                    </template>
                  </el-image>
                  <div class="festival-date">{{ festival.date }}</div>
                </div>
                <div class="festival-basic">
                  <h3 class="festival-name">{{ festival.name }}</h3>
                  <div class="festival-season">
                    <el-tag :type="getSeasonType(festival.season)" size="small">
                      {{ getSeasonText(festival.season) }}
                    </el-tag>
                  </div>
                </div>
              </div>

              <div class="festival-content">
                <p class="festival-description">{{ festival.description }}</p>
              </div>

              <div class="festival-actions">
                <el-button
                  type="primary"
                  size="small"
                  @click.stop="learnMore(festival)"
                  class="learn-btn"
                >
                  学习详细
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-container">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :page-sizes="[6, 12]"
            :total="totalItems"
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

    <!-- 节俗详情弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentFestival.name"
      width="70%"
      :before-close="handleClose"
      class="festival-dialog"
    >
      <div class="dialog-content">
        <div class="detail-header">
          <div class="detail-image">
            <el-image :src="currentFestival.image" :alt="currentFestival.name" fit="cover">
              <template #error>
                <div class="image-slot">
                  <el-icon><Picture /></el-icon>
                </div>
              </template>
            </el-image>
          </div>
          <div class="detail-basic">
            <div class="detail-date">{{ currentFestival.date }}</div>
            <div class="detail-season">
              <el-tag :type="getSeasonType(currentFestival.season)" size="small">
                {{ getSeasonText(currentFestival.season) }}
              </el-tag>
            </div>
          </div>
        </div>

        <div class="detail-body">
          <h3 class="detail-title">节俗介绍</h3>
          <p class="detail-description">{{ currentFestival.description }}</p>

          <div
            class="detail-customs"
            v-if="currentFestival.customs && currentFestival.customs.length"
          >
            <h4>传统习俗</h4>
            <div class="customs-list">
              <div
                class="custom-item"
                v-for="(custom, index) in currentFestival.customs"
                :key="index"
              >
                <div class="custom-icon">
                  <el-icon><Star /></el-icon>
                </div>
                <div class="custom-content">
                  <h5>{{ custom.title }}</h5>
                  <p>{{ custom.description }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, reactive } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { ArrowLeft, Picture, Star } from "@element-plus/icons-vue";

const router = useRouter();
const username = ref("");
const dialogVisible = ref(false);

// 分类和分页
const activeSeason = ref("all");
const currentPage = ref(1);
const pageSize = ref(6);
const totalItems = ref(0);

// 当前选中的节俗
const currentFestival = reactive({
  id: null,
  name: "",
  date: "",
  season: "",
  image: "",
  description: "",
  customs: [],
});

// 节俗数据（删除了历史渊源和文化意义字段）
const festivals = ref([
  {
    id: 1,
    name: "春节",
    date: "农历正月初一",
    season: "spring",
    image: "https://placehold.co/300x200/FF6B6B/FFFFFF?text=春节",
    description: "中国最重要的传统节日，象征新的开始，家人团聚，辞旧迎新。",
    mainActivity: "贴春联、守岁、拜年",
    customs: [
      {
        title: "贴春联",
        description: "在门框上贴上红纸黑字的对联，寓意驱邪避灾、祈求平安",
      },
      {
        title: "守岁",
        description: "除夕夜全家团聚，通宵不眠，等待新年的到来",
      },
      {
        title: "拜年",
        description: "正月初一走访亲友，互相祝福，表达美好祝愿",
      },
    ],
  },
  {
    id: 2,
    name: "元宵节",
    date: "农历正月十五",
    season: "spring",
    image: "https://placehold.co/300x200/4ECDC4/FFFFFF?text=元宵节",
    description: "新年第一个月圆之夜，赏灯猜谜，祈求新的一年平安顺利。",
    mainActivity: "赏花灯、猜灯谜、吃元宵",
    customs: [
      {
        title: "赏花灯",
        description: "各地举办灯会，展示各种精美的花灯造型",
      },
      {
        title: "猜灯谜",
        description: "将谜语写在灯笼上，供人猜射，增添节日趣味",
      },
      {
        title: "吃元宵",
        description: "食用糯米制成的圆形食品，象征团圆美满",
      },
    ],
  },
  {
    id: 3,
    name: "清明节",
    date: "公历4月4-6日",
    season: "spring",
    image: "https://placehold.co/300x200/45B7D1/FFFFFF?text=清明节",
    description: "祭祖扫墓，缅怀先人，同时也是踏青郊游的好时节。",
    mainActivity: "扫墓祭祖、踏青郊游",
    customs: [
      {
        title: "扫墓祭祖",
        description: "清理祖先墓地，献上祭品，表达对先人的怀念",
      },
      {
        title: "踏青郊游",
        description: "春光明媚时节，外出游玩，感受大自然",
      },
      {
        title: "放风筝",
        description: "放飞风筝，寓意放走晦气，迎接好运",
      },
    ],
  },
  {
    id: 4,
    name: "端午节",
    date: "农历五月初五",
    season: "summer",
    image: "https://placehold.co/300x200/96CEB4/FFFFFF?text=端午节",
    description: "纪念屈原的节日，有赛龙舟、吃粽子的习俗，驱邪避疫。",
    mainActivity: "赛龙舟、吃粽子、挂艾草",
    customs: [
      {
        title: "赛龙舟",
        description: "多人划桨竞赛，纪念屈原投江，体现团结协作精神",
      },
      {
        title: "吃粽子",
        description: "用糯米包裹各种馅料，纪念屈原，也是时令美食",
      },
      {
        title: "挂艾草",
        description: "悬挂艾草和菖蒲，驱除蚊虫，净化空气",
      },
    ],
  },
  {
    id: 5,
    name: "七夕节",
    date: "农历七月初七",
    season: "summer",
    image: "https://placehold.co/300x200/FEA47F/FFFFFF?text=七夕节",
    description: "中国的情人节，源于牛郎织女的传说，女子乞巧祈福。",
    mainActivity: "乞巧、祈福、观星",
    customs: [
      {
        title: "乞巧",
        description: "女子向织女星祈求智巧，提高女红技艺",
      },
      {
        title: "观星",
        description: "夜晚仰望星空，寻找牛郎织女星",
      },
      {
        title: "祈福",
        description: "祈求美好姻缘和幸福生活",
      },
    ],
  },
  {
    id: 6,
    name: "中秋节",
    date: "农历八月十五",
    season: "autumn",
    image: "https://placehold.co/300x200/F97F51/FFFFFF?text=中秋节",
    description: "月圆人团圆，赏月吃月饼，寄托思念之情。",
    mainActivity: "赏月、吃月饼、团圆",
    customs: [
      {
        title: "赏月",
        description: "家人团聚，欣赏圆月，寄托思念之情",
      },
      {
        title: "吃月饼",
        description: "食用圆形月饼，象征团圆美满",
      },
      {
        title: "祭月",
        description: "设香案祭拜月神，祈求平安吉祥",
      },
    ],
  },
  {
    id: 7,
    name: "重阳节",
    date: "农历九月初九",
    season: "autumn",
    image: "https://placehold.co/300x200/1B9CFC/FFFFFF?text=重阳节",
    description: "敬老爱老的节日，登高赏菊，祈求健康长寿。",
    mainActivity: "登高、赏菊、敬老",
    customs: [
      {
        title: "登高",
        description: "登山远眺，锻炼身体，祈求避灾",
      },
      {
        title: "赏菊",
        description: "欣赏菊花，饮酒赋诗，陶冶情操",
      },
      {
        title: "敬老",
        description: "慰问老人，表达对长者的尊敬和关爱",
      },
    ],
  },
  {
    id: 8,
    name: "冬至",
    date: "公历12月21-23日",
    season: "winter",
    image: "https://placehold.co/300x200/82589F/FFFFFF?text=冬至",
    description: "一年中白昼最短的一天，北方吃饺子，南方吃汤圆。",
    mainActivity: "祭祖、家庭聚餐",
    customs: [
      {
        title: "吃饺子",
        description: "北方习俗，吃饺子寓意不冻耳朵",
      },
      {
        title: "吃汤圆",
        description: "南方习俗，吃汤圆象征团圆",
      },
      {
        title: "祭祖",
        description: "祭祀祖先，表达对先人的怀念",
      },
    ],
  },
]);

// 计算过滤后的节俗（无副作用）
const filteredFestivals = computed(() => {
  let filtered = festivals.value;

  // 按季节过滤
  if (activeSeason.value !== "all") {
    filtered = filtered.filter((festival) => festival.season === activeSeason.value);
  }

  return filtered;
});

// 计算分页后的节俗
const paginatedFestivals = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return filteredFestivals.value.slice(start, end);
});

// 监听过滤后的数据变化，更新总数
watch(
  filteredFestivals,
  (newFiltered) => {
    totalItems.value = newFiltered.length;
  },
  { immediate: true },
);

// 季节类型和文本
const getSeasonType = (season) => {
  const typeMap = {
    spring: "success",
    summer: "warning",
    autumn: "danger",
    winter: "info",
  };
  return typeMap[season] || "";
};

const getSeasonText = (season) => {
  const textMap = {
    spring: "春季",
    summer: "夏季",
    autumn: "秋季",
    winter: "冬季",
  };
  return textMap[season] || "";
};

// 查看节俗详情
const learnMore = (festival) => {
  Object.assign(currentFestival, festival);
  dialogVisible.value = true;
};

// 关闭弹窗
const handleClose = (done) => {
  done();
};

const loadFestivals = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/festival");
    if (response.ok) {
      const data = await response.json();
      festivals.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        date: item.date,
        season: item.season,
        image: item.image
          ? `http://localhost:8082${item.image}`
          : `https://placehold.co/300x200/FF6B6B/FFFFFF?text=${item.name}`,
        description: item.description,
        mainActivity: item.mainActivity || "",
        customs: item.customs
          ? item.customs.split("|").map((custom) => {
              const [title, ...descParts] = custom.split(":");
              return {
                title: title.trim(),
                description: descParts.join(":").trim(),
              };
            })
          : [],
      }));
    }
  } catch (error) {
    console.error("加载节俗数据失败:", error);
  }
};

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  loadFestivals();
  // 滚动到页面顶部
  window.scrollTo({ top: 0, behavior: "instant" });
});

const handleSeasonChange = () => {
  currentPage.value = 1;
};

const handleSizeChange = (size) => {
  pageSize.value = size;
  currentPage.value = 1;
};

const handleCurrentChange = (page) => {
  currentPage.value = page;
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
  router.push("/culture");
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
</script>

<style scoped>
.festival-detail-container {
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
  cursor: pointer;
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

.page-header {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
}

.back-btn {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  color: #8b4513;
}

.page-title {
  font-size: 32px;
  margin-bottom: 10px;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

.page-subtitle {
  color: #666;
  font-size: 16px;
}

.category-section {
  background: white;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.category-filter {
  margin-bottom: 30px;
  text-align: center;
}

:deep(.el-radio-group) {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 10px;
}

:deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-color: #8b4513;
  color: white;
}

.festival-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}

.festival-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #e8e8e8;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.festival-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 16px 40px rgba(139, 69, 19, 0.15);
}

.festival-header {
  position: relative;
}

.festival-image {
  height: 160px;
  overflow: hidden;
}

.festival-date {
  position: absolute;
  top: 12px;
  right: 12px;
  background: rgba(139, 69, 19, 0.9);
  color: white;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.festival-basic {
  padding: 16px 16px 0;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.festival-name {
  font-size: 18px;
  font-weight: 600;
  color: #8b4513;
  margin: 0;
  flex: 1;
}

.festival-season {
  margin-left: 10px;
}

.festival-content {
  padding: 16px;
}

.festival-description {
  color: #666;
  line-height: 1.6;
  margin-bottom: 16px;
  font-size: 14px;
  /* 修复 line-clamp 兼容性问题 */
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  /* 标准属性 */
  display: -moz-box;
  -moz-line-clamp: 2;
  -moz-box-orient: vertical;
  display: box;
  line-clamp: 2;
  box-orient: vertical;
}

.festival-features {
  margin-bottom: 16px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-size: 12px;
  color: #666;
}

.feature-item .el-icon {
  color: #8b4513;
}

.festival-actions {
  padding: 0 16px 16px;
  display: flex;
  gap: 8px;
}

.learn-btn {
  width: 100%;
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border: none;
  border-radius: 6px;
  color: white;
  font-weight: 500;
  transition: all 0.3s ease;
}

.learn-btn:hover {
  background: linear-gradient(135deg, #a0522d 0%, #da7b2d 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 40px;
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
}

/* 弹窗样式 */
.festival-dialog {
  border-radius: 12px;
}

.dialog-content {
  max-height: 70vh;
  overflow-y: auto;
  padding-right: 10px;
}

.detail-header {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  align-items: flex-start;
}

.detail-image {
  width: 200px;
  height: 150px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.detail-basic {
  flex: 1;
}

.detail-date {
  font-size: 16px;
  color: #8b4513;
  font-weight: 500;
  margin-bottom: 10px;
}

.detail-season {
  margin-bottom: 10px;
}

.detail-body {
  border-top: 1px solid #e8e8e8;
  padding-top: 20px;
}

.detail-title {
  font-size: 18px;
  color: #8b4513;
  margin-bottom: 15px;
}

.detail-description {
  line-height: 1.8;
  color: #666;
  margin-bottom: 20px;
}

.detail-customs {
  margin-bottom: 20px;
}

.detail-customs h4 {
  font-size: 16px;
  color: #8b4513;
  margin-bottom: 10px;
}

.customs-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.custom-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px;
  background: #f9f5f0;
  border-radius: 6px;
  border-left: 3px solid #d4a76a;
}

.custom-icon {
  width: 24px;
  height: 24px;
  background: #8b4513;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  flex-shrink: 0;
}

.custom-content {
  flex: 1;
}

.custom-content h5 {
  font-size: 14px;
  color: #8b4513;
  margin: 0 0 4px 0;
}

.custom-content p {
  font-size: 13px;
  color: #666;
  line-height: 1.5;
  margin: 0;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}

@media (max-width: 768px) {
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

  .page-header {
    text-align: center;
  }

  .back-btn {
    position: relative;
    margin-bottom: 15px;
    left: auto;
    transform: none;
  }

  .festival-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }

  .category-section {
    padding: 20px;
  }

  :deep(.el-radio-group) {
    flex-direction: column;
    align-items: center;
  }

  /* 移动端弹窗样式 */
  .festival-dialog {
    width: 90% !important;
  }

  .detail-header {
    flex-direction: column;
  }

  .detail-image {
    width: 100%;
    height: 200px;
  }
}
</style>
