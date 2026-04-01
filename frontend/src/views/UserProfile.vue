<template>
  <div class="user-profile-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/')">汉服知识库</li>
          <li class="nav-item" @click="$router.push('/culture')">传统文化学习</li>
          <li class="nav-item" @click="$router.push('/activity')">汉服活动召集</li>
          <li class="nav-item" @click="$router.push('/shop-evaluation')">汉服店铺测评</li>
          <li class="nav-item" @click="$router.push('/community')">社区互动</li>
          <li class="nav-item" @click="$router.push('/ai-chat')">AI问答</li>
          <li class="nav-item active">个人中心</li>
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
        <h2 class="page-title">个人中心</h2>

        <div class="profile-layout">
          <!-- 左侧菜单 -->
          <div class="sidebar">
            <el-menu :default-active="activeMenu" class="profile-menu" @select="handleMenuSelect">
              <el-menu-item index="info">
                <el-icon><User /></el-icon>
                <span>个人信息</span>
              </el-menu-item>
              <el-menu-item index="evaluations">
                <el-icon><Document /></el-icon>
                <span>我的测评</span>
              </el-menu-item>
              <el-menu-item index="posts">
                <el-icon><ChatDotSquare /></el-icon>
                <span>我的发帖</span>
              </el-menu-item>
              <el-menu-item index="likes">
                <el-icon><Star /></el-icon>
                <span>我的点赞</span>
              </el-menu-item>
              <!-- 新增活动报名菜单 -->
              <el-menu-item index="activity-registrations">
                <el-icon><Calendar /></el-icon>
                <span>活动报名</span>
              </el-menu-item>
            </el-menu>
          </div>

          <!-- 右侧内容 -->
          <div class="content">
            <!-- 个人信息 -->
            <div v-if="activeMenu === 'info'" class="section">
              <div class="profile-header">
                <div class="user-basic-info">
                  <h3>{{ userInfo.username }}</h3>
                  <p>汉服爱好者</p>
                </div>
                <el-dropdown>
                  <el-button class="edit-button">
                    修改设置
                    <el-icon class="el-icon--right"><ArrowDown /></el-icon>
                  </el-button>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item @click="showEditDialog">修改信息</el-dropdown-item>
                      <el-dropdown-item @click="showPasswordDialog">修改密码</el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </div>

              <div class="profile-details">
                <div class="detail-item">
                  <label>用户名：</label>
                  <span>{{ userInfo.username }}</span>
                </div>
                <div class="detail-item">
                  <label>性别：</label>
                  <span>{{ userInfo.gender || "未设置" }}</span>
                </div>
                <div class="detail-item">
                  <label>简介：</label>
                  <span>{{ userInfo.bio || "这个人很懒，什么都没有写～" }}</span>
                </div>
              </div>
            </div>

            <!-- 我的测评 -->
            <div v-else-if="activeMenu === 'evaluations'" class="section">
              <h3 class="content-title">我的测评</h3>
              <div class="evaluations-list">
                <div
                  class="evaluation-item"
                  v-for="evaluation in userEvaluations"
                  :key="evaluation.id"
                >
                  <div class="eval-header">
                    <div class="eval-shop">{{ evaluation.shopName }}</div>
                    <div class="eval-actions">
                      <el-button
                        type="primary"
                        size="small"
                        @click="viewEvaluationDetails(evaluation)"
                        >查看</el-button
                      >
                      <el-button type="danger" size="small" @click="deleteEvaluation(evaluation.id)"
                        >删除</el-button
                      >
                    </div>
                  </div>
                  <div class="eval-rating">
                    <el-rate v-model="evaluation.rating" disabled />
                    <span class="eval-date">{{ evaluation.date }}</span>
                  </div>
                  <p class="eval-content">{{ evaluation.content }}</p>
                </div>
              </div>
              <el-empty v-if="userEvaluations.length === 0" description="暂无测评记录" />
            </div>

            <!-- 我的发帖 -->
            <div v-else-if="activeMenu === 'posts'" class="section">
              <h3 class="content-title">我的发帖</h3>
              <div class="posts-list">
                <div class="post-item" v-for="post in userPosts" :key="post.id">
                  <div class="post-header">
                    <h4>{{ post.title }}</h4>
                    <div class="post-actions">
                      <el-button type="primary" size="small" @click="viewPostDetails(post.id)"
                        >查看</el-button
                      >
                      <el-button type="warning" size="small" @click="editPost(post)"
                        >修改</el-button
                      >
                      <el-button type="danger" size="small" @click="deletePost(post.id)"
                        >删除</el-button
                      >
                    </div>
                  </div>
                  <p>{{ post.content }}</p>
                  <div class="post-meta">
                    <span>{{ post.date }}</span>
                    <div class="post-stats">
                      <span>❤️ {{ post.likes }}</span>
                      <span>💬 {{ post.comments }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <el-empty v-if="userPosts.length === 0" description="暂无发帖记录" />
            </div>

            <!-- 我的点赞 -->
            <div v-else-if="activeMenu === 'likes'" class="section">
              <h3 class="content-title">我的点赞</h3>
              <div class="likes-list">
                <div class="like-item" v-for="like in userLikes" :key="like.id">
                  <div class="like-type">{{ like.type }}</div>
                  <h4>{{ like.title }}</h4>
                  <p>{{ like.content }}</p>
                  <div class="like-meta">
                    <span>{{ like.author }}</span>
                    <span>{{ like.date }}</span>
                  </div>
                </div>
              </div>
              <el-empty v-if="userLikes.length === 0" description="暂无点赞记录" />
            </div>

            <!-- 新增：活动报名 -->
            <div v-else-if="activeMenu === 'activity-registrations'" class="section">
              <h3 class="content-title">我的活动报名</h3>
              <div class="registrations-header">
                <el-tabs v-model="registrationTab" class="registration-tabs">
                  <el-tab-pane label="已报名" name="registered"></el-tab-pane>
                  <el-tab-pane label="待参加" name="upcoming"></el-tab-pane>
                  <el-tab-pane label="已结束" name="completed"></el-tab-pane>
                  <el-tab-pane label="已取消" name="cancelled"></el-tab-pane>
                </el-tabs>
              </div>

              <div class="registrations-list">
                <div
                  class="registration-item"
                  v-for="registration in filteredRegistrations"
                  :key="registration.id"
                >
                  <div class="registration-status">
                    <el-tag :type="getStatusTagType(registration.status)" size="small">
                      {{ getStatusText(registration.status) }}
                    </el-tag>
                  </div>
                  <div class="registration-content">
                    <h4>{{ registration.activityName }}</h4>
                    <div class="registration-info">
                      <div class="info-item">
                        <el-icon><Location /></el-icon>
                        <span>{{ registration.location }}</span>
                      </div>
                      <div class="info-item">
                        <el-icon><Clock /></el-icon>
                        <span>{{ registration.time }}</span>
                      </div>
                    </div>
                    <div class="registration-details">
                      <div class="registration-meta">
                        <span class="registration-date"
                          >报名时间：{{ registration.registrationDate }}</span
                        >
                        <div class="registration-actions">
                          <el-button
                            v-if="
                              registration.status === 'registered' ||
                              registration.status === 'upcoming'
                            "
                            type="danger"
                            size="small"
                            @click="cancelRegistration(registration.id)"
                          >
                            取消报名
                          </el-button>
                          <el-button
                            v-if="registration.status === 'upcoming'"
                            type="primary"
                            size="small"
                            @click="viewActivityDetails(registration.activityId)"
                          >
                            查看详情
                          </el-button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <el-empty
                v-if="filteredRegistrations.length === 0"
                :description="getEmptyDescription()"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 修改信息对话框 -->
    <el-dialog v-model="editDialogVisible" title="修改个人信息" width="500px">
      <el-form :model="editForm" label-width="80px">
        <el-form-item label="用户名">
          <el-input v-model="editForm.username" />
        </el-form-item>
        <el-form-item label="性别">
          <el-radio-group v-model="editForm.gender">
            <el-radio label="男">男</el-radio>
            <el-radio label="女">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="简介">
          <el-input v-model="editForm.bio" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveProfile">保存</el-button>
      </template>
    </el-dialog>

    <!-- 修改密码对话框 -->
    <el-dialog v-model="passwordDialogVisible" title="修改密码" width="400px">
      <el-form
        :model="passwordForm"
        label-width="80px"
        :rules="passwordRules"
        ref="passwordFormRef"
      >
        <el-form-item label="原密码" prop="oldPassword">
          <el-input v-model="passwordForm.oldPassword" type="password" show-password />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="passwordForm.newPassword" type="password" show-password />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="passwordForm.confirmPassword" type="password" show-password />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="passwordDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="changePassword">确认修改</el-button>
      </template>
    </el-dialog>

    <!-- 帖子修改对话框 -->
    <el-dialog v-model="postDialogVisible" title="修改帖子" width="600px">
      <div v-if="currentPost">
        <el-form :model="currentPost" label-width="80px">
          <el-form-item label="标题">
            <el-input v-model="currentPost.title" placeholder="请输入标题" />
          </el-form-item>
          <el-form-item label="内容">
            <el-input
              v-model="currentPost.content"
              type="textarea"
              :rows="5"
              placeholder="请输入内容"
            />
          </el-form-item>
          <el-form-item label="图片">
            <div class="upload-tips">支持上传JPG、PNG格式图片，最多9张</div>
            <el-upload
              v-model:file-list="currentPost.images"
              action="#"
              list-type="picture-card"
              :auto-upload="false"
              :on-change="handleImageChange"
              :limit="9"
              :on-exceed="handleExceed"
              accept=".jpg,.jpeg,.png,.gif"
            >
              <el-icon><Plus /></el-icon>
            </el-upload>
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="postDialogVisible = false">关闭</el-button>
        <el-button type="primary" @click="savePost">保存修改</el-button>
      </template>
    </el-dialog>

    <!-- 帖子详情弹窗 -->
    <PostDetailDialog
      v-model:visible="postDetailVisible"
      :post-data="selectedPost"
      @like-changed="handleLikeChanged"
      @comment-added="handleCommentAdded"
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
import { ref, onMounted, reactive, computed } from "vue";
import { useRouter, useRoute } from "vue-router";
import PostDetailDialog from "./PostDetailDialog.vue";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  User,
  Document,
  ChatDotSquare,
  Plus,
  Star,
  Calendar,
  Location,
  Clock,
  ArrowDown,
} from "@element-plus/icons-vue";

const API_BASE = "http://localhost:8082/api";

const router = useRouter();
const route = useRoute();
const username = ref("");
const activeMenu = ref("info");
const editDialogVisible = ref(false);
const passwordDialogVisible = ref(false);
const passwordFormRef = ref();
const registrationTab = ref("registered");
const loading = ref(false);

const userInfo = ref({
  username: "",
  gender: "",
  bio: "",
});

const editForm = reactive({
  username: "",
  gender: "",
  bio: "",
});

const passwordForm = reactive({
  oldPassword: "",
  newPassword: "",
  confirmPassword: "",
});

const passwordRules = {
  oldPassword: [{ required: true, message: "请输入原密码", trigger: "blur" }],
  newPassword: [
    { required: true, message: "请输入新密码", trigger: "blur" },
    { min: 6, message: "密码长度不能少于6位", trigger: "blur" },
  ],
  confirmPassword: [
    { required: true, message: "请确认密码", trigger: "blur" },
    {
      validator: (rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error("两次输入密码不一致"));
        } else {
          callback();
        }
      },
      trigger: "blur",
    },
  ],
};

const userEvaluations = ref([]);

const userPosts = ref([]);
const postDialogVisible = ref(false);
const postDialogType = ref("view"); // view 或 edit
const currentPost = ref(null);
const postDetailVisible = ref(false);
const selectedPost = ref(null);

const userLikes = ref([
  {
    id: 1,
    type: "帖子",
    title: "汉服穿搭技巧",
    content: "分享一些日常汉服穿搭的小技巧...",
    author: "穿搭达人",
    date: "2023-11-08",
  },
]);

// 新增：活动报名数据
const activityRegistrations = ref([
  {
    id: 1,
    activityId: 101,
    activityName: "春日汉服游园会",
    location: "中山公园",
    time: "2024-03-15 14:00-17:00",
    registrationDate: "2024-02-20",
    status: "upcoming", // registered, upcoming, completed, cancelled
  },
  {
    id: 2,
    activityId: 102,
    activityName: "汉服茶艺交流会",
    location: "茶文化馆",
    time: "2024-02-28 19:00-21:00",
    registrationDate: "2024-02-15",
    status: "completed",
  },
  {
    id: 3,
    activityId: 103,
    activityName: "汉服摄影大赛",
    location: "古城墙景区",
    time: "2024-04-10 09:00-16:00",
    registrationDate: "2024-02-25",
    status: "registered",
  },
  {
    id: 4,
    activityId: 104,
    activityName: "传统节日庆典",
    location: "文化广场",
    time: "2024-01-20 10:00-18:00",
    registrationDate: "2024-01-10",
    status: "cancelled",
  },
]);

// 计算属性：根据标签过滤活动
const filteredRegistrations = computed(() => {
  if (registrationTab.value === "registered") {
    return activityRegistrations.value.filter((item) => item.status === "registered");
  } else if (registrationTab.value === "upcoming") {
    return activityRegistrations.value.filter((item) => item.status === "upcoming");
  } else if (registrationTab.value === "completed") {
    return activityRegistrations.value.filter((item) => item.status === "completed");
  } else if (registrationTab.value === "cancelled") {
    return activityRegistrations.value.filter((item) => item.status === "cancelled");
  }
  return activityRegistrations.value;
});

const getUserId = () => {
  const userStr = localStorage.getItem("user");
  if (userStr) {
    try {
      const user = JSON.parse(userStr);
      if (user.id) {
        return user.id;
      } else if (user.userId) {
        return user.userId;
      }
    } catch (e) {
      console.error("解析用户信息失败", e);
    }
  }
  const savedUserId = localStorage.getItem("userId");
  if (savedUserId) {
    return parseInt(savedUserId);
  }
  return null;
};

const fetchUserInfo = async () => {
  const userId = getUserId();
  if (!userId) {
    ElMessage.warning("请先登录");
    router.push("/login");
    return;
  }

  loading.value = true;
  try {
    const response = await fetch(`${API_BASE}/users/${userId}`);
    if (response.ok) {
      const user = await response.json();
      userInfo.value = {
        ...userInfo.value,
        username: user.username || "",
        gender: user.gender || "",
        bio: user.bio || "",
      };
      editForm.username = user.username || "";
      editForm.gender = user.gender || "";
      editForm.bio = user.bio || "";
      username.value = user.username || "";
    } else {
      ElMessage.error("获取用户信息失败");
    }
  } catch (error) {
    console.error("获取用户信息失败:", error);
    ElMessage.error("网络异常，请稍后重试");
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchUserInfo();
  // 检查路由参数，如果有menu参数，就设置activeMenu为该值
  if (route.query.menu) {
    activeMenu.value = route.query.menu;
    // 如果是evaluations菜单，就加载用户测评数据
    if (route.query.menu === "evaluations") {
      fetchUserEvaluations();
    } else if (route.query.menu === "posts") {
      fetchUserPosts();
    }
  }
});

const handleMenuSelect = (index) => {
  activeMenu.value = index;
  if (index === "evaluations") {
    fetchUserEvaluations();
  } else if (index === "posts") {
    fetchUserPosts();
  }
};

const showEditDialog = () => {
  editDialogVisible.value = true;
};

const showPasswordDialog = () => {
  passwordDialogVisible.value = true;
};

const saveProfile = async () => {
  const userId = getUserId();
  if (!userId) {
    ElMessage.warning("请先登录");
    router.push("/login");
    return;
  }

  loading.value = true;
  try {
    const response = await fetch(`${API_BASE}/users/${userId}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        username: editForm.username,
        gender: editForm.gender,
        bio: editForm.bio,
      }),
    });

    if (response.ok) {
      const updatedUser = await response.json();
      userInfo.value = {
        ...userInfo.value,
        username: updatedUser.username || "",
        gender: updatedUser.gender || "",
        bio: updatedUser.bio || "",
      };
      username.value = updatedUser.username || "";
      ElMessage.success("个人信息更新成功");
      editDialogVisible.value = false;
    } else {
      ElMessage.error("更新个人信息失败");
    }
  } catch (error) {
    console.error("更新个人信息失败:", error);
    ElMessage.error("网络异常，请稍后重试");
  } finally {
    loading.value = false;
  }
};

const changePassword = async () => {
  if (!passwordFormRef.value) return;

  try {
    await passwordFormRef.value.validate();
    const userId = getUserId();
    if (!userId) {
      ElMessage.warning("请先登录");
      router.push("/login");
      return;
    }

    loading.value = true;
    const response = await fetch(`${API_BASE}/users/${userId}/password`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        oldPassword: passwordForm.oldPassword,
        newPassword: passwordForm.newPassword,
      }),
    });

    if (response.ok) {
      ElMessage.success("密码修改成功，即将退出登录");
      passwordDialogVisible.value = false;
      passwordForm.oldPassword = "";
      passwordForm.newPassword = "";
      passwordForm.confirmPassword = "";
      // 延迟一秒后退出登录，让用户看到成功提示
      setTimeout(() => {
        logout();
      }, 1000);
    } else {
      const errorData = await response.json();
      ElMessage.error(errorData.message || "密码修改失败");
    }
  } catch (error) {
    console.error("修改密码失败:", error);
    ElMessage.error("网络异常，请稍后重试");
  } finally {
    loading.value = false;
  }
};

// 新增：获取状态标签类型
const getStatusTagType = (status) => {
  const map = {
    registered: "primary",
    upcoming: "success",
    completed: "info",
    cancelled: "warning",
  };
  return map[status] || "info";
};

// 新增：获取状态文本
const getStatusText = (status) => {
  const map = {
    registered: "已报名",
    upcoming: "待参加",
    completed: "已结束",
    cancelled: "已取消",
  };
  return map[status] || "未知状态";
};

// 新增：获取空状态描述
const getEmptyDescription = () => {
  const map = {
    registered: "暂无已报名的活动",
    upcoming: "暂无待参加的活动",
    completed: "暂无已结束的活动",
    cancelled: "暂无已取消的活动",
  };
  return map[registrationTab.value] || "暂无活动记录";
};

// 新增：取消报名
const cancelRegistration = (registrationId) => {
  ElMessageBox.confirm("确定要取消报名吗？取消后如需参加需要重新报名。", "取消报名确认", {
    confirmButtonText: "确定取消",
    cancelButtonText: "再想想",
    type: "warning",
  })
    .then(() => {
      const index = activityRegistrations.value.findIndex((item) => item.id === registrationId);
      if (index !== -1) {
        activityRegistrations.value[index].status = "cancelled";
        ElMessage.success("已成功取消报名");
      }
    })
    .catch(() => {
      // 用户取消操作
    });
};

// 新增：查看活动详情
const viewActivityDetails = (activityId) => {
  router.push(`/activity/${activityId}`);
};

// 加载用户测评数据
const fetchUserEvaluations = async () => {
  const userId = getUserId();
  if (!userId) {
    ElMessage.warning("请先登录");
    router.push("/login");
    return;
  }

  loading.value = true;
  try {
    const response = await fetch(`${API_BASE}/evaluations/user/${userId}`);
    if (response.ok) {
      const evaluations = await response.json();
      // 为每个测评获取店铺名称
      const evaluationsWithShopName = await Promise.all(
        evaluations.map(async (evalItem) => {
          let shopName = "未知店铺";
          try {
            const shopResponse = await fetch(`${API_BASE}/shops/${evalItem.shopId}`);
            if (shopResponse.ok) {
              const shop = await shopResponse.json();
              shopName = shop.name || shopName;
            }
          } catch (error) {
            console.error("获取店铺信息失败:", error);
          }
          return {
            id: evalItem.id,
            shopId: evalItem.shopId,
            shopName: shopName,
            rating: evalItem.rating || 0,
            date: evalItem.createTime ? new Date(evalItem.createTime).toLocaleDateString() : "",
            content: evalItem.content || "",
          };
        }),
      );
      userEvaluations.value = evaluationsWithShopName;
    } else {
      ElMessage.error("获取测评记录失败");
    }
  } catch (error) {
    console.error("获取测评记录失败:", error);
    ElMessage.error("网络异常，请稍后重试");
  } finally {
    loading.value = false;
  }
};

// 查看测评详情
const viewEvaluationDetails = (evaluation) => {
  // 跳转到店铺详情页面，携带当前菜单状态
  router.push({
    path: `/shop-detail/${evaluation.shopId}`,
    query: {
      from: "profile",
      menu: activeMenu.value,
    },
  });
};

// 删除测评
const deleteEvaluation = (evaluationId) => {
  ElMessageBox.confirm("确定要删除这条测评吗？删除后无法恢复。", "删除确认", {
    confirmButtonText: "确定删除",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(async () => {
      loading.value = true;
      try {
        const response = await fetch(`${API_BASE}/evaluations/${evaluationId}`, {
          method: "DELETE",
        });
        if (response.ok) {
          ElMessage.success("测评删除成功");
          // 重新加载测评数据
          fetchUserEvaluations();
        } else {
          ElMessage.error("删除测评失败");
        }
      } catch (error) {
        console.error("删除测评失败:", error);
        ElMessage.error("网络异常，请稍后重试");
      } finally {
        loading.value = false;
      }
    })
    .catch(() => {
      // 用户取消操作
    });
};

// 加载用户发帖数据
const fetchUserPosts = async () => {
  const userId = getUserId();
  if (!userId) {
    ElMessage.warning("请先登录");
    router.push("/login");
    return;
  }

  loading.value = true;
  try {
    const response = await fetch(`${API_BASE}/posts/user/${userId}`);
    if (response.ok) {
      const posts = await response.json();
      const postsWithStats = posts.map((post) => ({
        id: post.id,
        title: post.title || "",
        content: post.content || "",
        date: post.time || "",
        likes: post.likes || 0,
        comments: post.comments || 0,
      }));
      userPosts.value = postsWithStats;
    } else {
      ElMessage.error("获取发帖记录失败");
    }
  } catch (error) {
    console.error("获取发帖记录失败:", error);
    ElMessage.error("网络异常，请稍后重试");
  } finally {
    loading.value = false;
  }
};

// 查看帖子详情
const viewPostDetails = (postId) => {
  // 查找对应帖子
  const post = userPosts.value.find((p) => p.id === postId);
  if (post) {
    selectedPost.value = { ...post };
    postDetailVisible.value = true;
  }
};

// 修改帖子
const editPost = (post) => {
  // 复制帖子数据
  const postCopy = { ...post };

  // 处理图片数据，转换为el-upload需要的格式
  if (post.images) {
    postCopy.images = Array.isArray(post.images)
      ? post.images.map((url) => ({
          url: url,
          name: url.split("/").pop(),
          status: "success",
        }))
      : [];
  } else {
    postCopy.images = [];
  }

  currentPost.value = postCopy;
  postDialogType.value = "edit";
  postDialogVisible.value = true;
};

// 保存修改后的帖子
const savePost = async () => {
  if (!currentPost.value) return;

  loading.value = true;
  try {
    // 处理图片上传
    const imageUrls = [];
    if (currentPost.value.images && currentPost.value.images.length > 0) {
      for (const file of currentPost.value.images) {
        // 检查是否是新上传的文件（本地文件对象）
        if (file.raw) {
          const formData = new FormData();
          formData.append("file", file.raw);

          const uploadResponse = await fetch(`${API_BASE}/upload`, {
            method: "POST",
            body: formData,
          });

          if (uploadResponse.ok) {
            const result = await uploadResponse.json();
            imageUrls.push(result.fileUrl);
          } else {
            ElMessage.error("图片上传失败");
            return;
          }
        } else if (file.url) {
          // 保留已有的图片URL
          imageUrls.push(file.url);
        }
      }
    }

    // 更新帖子信息
    const response = await fetch(`${API_BASE}/posts/${currentPost.value.id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        title: currentPost.value.title,
        content: currentPost.value.content,
        images: imageUrls,
      }),
    });
    if (response.ok) {
      ElMessage.success("帖子修改成功");
      postDialogVisible.value = false;
      // 重新加载发帖数据
      fetchUserPosts();
    } else {
      ElMessage.error("修改帖子失败");
    }
  } catch (error) {
    console.error("修改帖子失败:", error);
    ElMessage.error("网络异常，请稍后重试");
  } finally {
    loading.value = false;
  }
};

// 处理帖子详情弹窗的点赞变化
const handleLikeChanged = ({ postId, liked, likes }) => {
  const post = userPosts.value.find((p) => p.id === postId);
  if (post) {
    post.liked = liked;
    post.likes = likes;
  }
};

// 处理帖子详情弹窗的新评论
const handleCommentAdded = ({ postId }) => {
  const post = userPosts.value.find((p) => p.id === postId);
  if (post) {
    post.comments += 1;
  }
};

// 处理图片上传变化
const handleImageChange = (file, fileList) => {
  // el-upload 的 v-model:file-list 已经自动管理文件列表
  // 这里只需要同步到 currentPost.images
  if (currentPost.value) {
    currentPost.value.images = fileList;
  }
};

// 处理图片上传超过限制
const handleExceed = () => {
  ElMessage.warning("最多只能上传9张图片");
};

// 删除帖子
const deletePost = (postId) => {
  ElMessageBox.confirm("确定要删除这条帖子吗？删除后无法恢复。", "删除确认", {
    confirmButtonText: "确定删除",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(async () => {
      loading.value = true;
      try {
        const response = await fetch(`${API_BASE}/posts/${postId}`, {
          method: "DELETE",
        });
        if (response.ok) {
          ElMessage.success("帖子删除成功");
          // 重新加载发帖数据
          fetchUserPosts();
        } else {
          ElMessage.error("删除帖子失败");
        }
      } catch (error) {
        console.error("删除帖子失败:", error);
        ElMessage.error("网络异常，请稍后重试");
      } finally {
        loading.value = false;
      }
    })
    .catch(() => {
      // 用户取消操作
    });
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
.user-profile-container {
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

.page-title {
  font-size: 28px;
  margin-bottom: 20px;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

.profile-layout {
  display: flex;
  position: relative;
  min-height: calc(100vh - 220px);
}

.sidebar {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  width: 250px;
  position: sticky;
  top: 20px;
  align-self: flex-start;
  height: fit-content;
  max-height: calc(100vh - 100px);
  overflow-y: auto;
}

.content {
  flex: 1;
  margin-left: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.profile-menu {
  border: none;
  border-radius: 8px;
}

.profile-menu .el-menu-item {
  height: 60px;
  line-height: 60px;
  border-bottom: 1px solid #f0f0f0;
}

.profile-menu .el-menu-item:last-child {
  border-bottom: none;
}

.profile-menu .el-menu-item.is-active {
  background-color: #f8f0e8;
  color: #8b4513;
  border-right: 3px solid #8b4513;
}

.content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.section {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.profile-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}

.user-basic-info h3 {
  margin: 0 0 5px 0;
  color: #8b4513;
  font-size: 20px;
}

.user-basic-info p {
  margin: 0;
  color: #666;
  font-size: 14px;
}

.profile-details {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 20px;
}

.detail-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.detail-item:last-child {
  border-bottom: none;
}

.detail-item label {
  width: 80px;
  font-weight: bold;
  color: #333;
}

.detail-item span {
  color: #666;
}

.edit-button {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  border: none;
}

.edit-button:hover {
  background: linear-gradient(135deg, #6b340d 0%, #b15a1a 100%);
  color: white;
}

.content-title {
  margin: 0 0 20px 0;
  color: #8b4513;
  font-size: 20px;
  border-left: 4px solid #d4a76a;
  padding-left: 10px;
}

.evaluations-list,
.posts-list,
.likes-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.evaluation-item,
.post-item,
.like-item {
  padding: 15px;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  background-color: #fafafa;
}

.eval-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
}

.eval-shop {
  font-weight: bold;
  color: #8b4513;
  flex: 1;
}

.eval-actions {
  display: flex;
  gap: 8px;
}

.eval-rating {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.eval-date {
  font-size: 12px;
  color: #999;
}

.eval-content {
  margin: 0;
  line-height: 1.5;
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
}

.post-header h4 {
  margin: 0;
  color: #8b4513;
  flex: 1;
}

.post-actions {
  display: flex;
  gap: 8px;
}

.post-item p {
  margin: 0 0 10px 0;
  color: #666;
  line-height: 1.5;
}

.post-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: #999;
}

.post-stats {
  display: flex;
  gap: 10px;
}

.like-type {
  display: inline-block;
  padding: 2px 8px;
  background-color: #e6f7ff;
  color: #1890ff;
  border-radius: 4px;
  font-size: 12px;
  margin-bottom: 8px;
}

.like-item h4 {
  margin: 0 0 8px 0;
  color: #8b4513;
}

.like-item p {
  margin: 0 0 10px 0;
  color: #666;
  line-height: 1.5;
}

.like-meta {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #999;
}

/* 新增：活动报名样式 */
.registrations-header {
  margin-bottom: 20px;
}

.registration-tabs {
  margin-bottom: 0;
}

.registrations-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.registration-item {
  padding: 20px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  background-color: #fafafa;
  display: flex;
  flex-direction: column;
}

.registration-status {
  margin-bottom: 12px;
}

.registration-content h4 {
  margin: 0 0 12px 0;
  color: #8b4513;
  font-size: 18px;
}

.registration-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
  margin-bottom: 15px;
  padding: 12px;
  background-color: #f8f8f8;
  border-radius: 6px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #666;
  font-size: 14px;
}

.info-item .el-icon {
  color: #8b4513;
}

.registration-details {
  margin-top: 15px;
}

.registration-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.registration-date {
  font-size: 12px;
  color: #999;
}

.registration-actions {
  display: flex;
  gap: 10px;
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

@media (max-width: 768px) {
  .profile-layout {
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

  .profile-header {
    flex-direction: column;
    gap: 15px;
  }

  .avatar-section {
    align-self: flex-start;
  }

  /* 响应式：活动报名 */
  .registration-info {
    grid-template-columns: 1fr;
  }

  .registration-meta {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .registration-actions {
    align-self: flex-end;
  }
}
</style>
