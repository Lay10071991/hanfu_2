<template>
  <div class="community-container">
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
        <div class="page-header">
          <h2 class="page-title">社区互动</h2>
          <p class="page-subtitle">分享你的汉服故事，发现同袍精彩瞬间</p>
        </div>

        <!-- 小红书风格布局 -->
        <div class="community-layout">
          <!-- 发布板块（左边） -->
          <div class="publish-section-left">
            <div class="section publish-card">
              <div class="section-header">
                <h3 class="section-title">
                  <el-icon><Edit /></el-icon>
                  发布内容
                </h3>
                <p class="section-subtitle">分享你的汉服生活</p>
              </div>

              <div class="publish-content-preview" @click="showPublishDialog">
                <div class="preview-placeholder">
                  <el-icon><Edit /></el-icon>
                  <span>分享你的汉服日常...</span>
                </div>
              </div>

              <div class="publish-actions">
                <div class="action-tips">
                  <div class="tip-item">
                    <el-icon><Picture /></el-icon>
                    <span>支持图片上传</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 发现板块（右边） -->
          <div class="discovery-section-right">
            <!-- 发现板块标题 -->
            <div class="discovery-header">
              <h3 class="section-title">发现精彩</h3>
              <div class="sort-options">
                <el-button
                  :type="sortBy === 'hot' ? 'primary' : 'default'"
                  size="small"
                  @click="changeSort('hot')"
                >
                  热门
                </el-button>
                <el-button
                  :type="sortBy === 'new' ? 'primary' : 'default'"
                  size="small"
                  @click="changeSort('new')"
                >
                  最新
                </el-button>
              </div>
            </div>

            <!-- 帖子网格 -->
            <div class="posts-grid">
              <div
                class="post-card"
                v-for="post in sortedPosts"
                :key="post.id"
                @click="viewPost(post)"
              >
                <div class="post-img">
                  <img
                    :src="post.image"
                    :alt="post.title"
                    loading="lazy"
                    @load="handleImageLoad($event, post)"
                    :style="post.imgStyle"
                  />
                </div>
                <div class="post-content">
                  <div class="post-header">
                    <h4 class="post-title">{{ post.title }}</h4>
                    <el-tag v-if="post.category" :type="post.categoryType" size="small">
                      {{ post.category }}
                    </el-tag>
                  </div>
                  <p class="post-desc">{{ post.description }}</p>
                  <div class="post-meta">
                    <div class="author-info">
                      <span class="post-author">{{ post.author }}</span>
                    </div>
                    <div class="post-stats">
                      <span class="likes" @click.stop="toggleLike(post)">
                        <el-icon :class="{ liked: post.liked }">
                          <StarFilled v-if="post.liked" />
                          <Star v-else />
                        </el-icon>
                        {{ post.likes }}
                      </span>
                      <span class="comments">
                        <el-icon><ChatDotRound /></el-icon>
                        {{ post.comments }}
                      </span>
                    </div>
                  </div>
                  <div class="post-time">{{ post.time }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 发布对话框 -->
    <el-dialog
      v-model="publishDialogVisible"
      title="发布内容"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form :model="publishForm" label-width="80px">
        <el-form-item label="标题" required>
          <el-input
            v-model="publishForm.title"
            placeholder="请输入标题（最多50字）"
            maxlength="50"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="标签" required>
          <el-input
            v-model="publishForm.category"
            placeholder="请输入标签（最多10字）"
            maxlength="10"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="简介" required>
          <el-input
            v-model="publishForm.description"
            placeholder="请输入简介（最多100字）"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="内容" required>
          <el-input
            v-model="publishForm.content"
            type="textarea"
            :rows="5"
            placeholder="分享你的汉服故事..."
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="图片" required>
          <div class="upload-tips">支持上传JPG、PNG格式图片，最多9张</div>
          <el-upload
            v-model:file-list="publishForm.images"
            action="#"
            list-type="picture-card"
            :auto-upload="false"
            :on-change="handleImageChange"
            :limit="9"
            :on-exceed="handleExceed"
            :on-preview="handlePictureCardPreview"
            accept=".jpg,.jpeg,.png,.gif"
            multiple="multiple"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>

          <!-- 图片预览组件 -->
          <el-image-viewer
            v-if="previewDialogVisible"
            :url-list="[previewImageUrl]"
            @close="() => (previewDialogVisible = false)"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="publishDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitPublish" :loading="publishing"> 发布 </el-button>
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
        <div class="footer-links">
          <span>关于我们</span>
          <span>联系我们</span>
          <span>用户协议</span>
          <span>隐私政策</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { Plus, Edit, Picture, Star, StarFilled, ChatDotRound } from "@element-plus/icons-vue";
import PostDetailDialog from "./PostDetailDialog.vue";
import { processPostImages } from "../utils/imageHelper.js";

const API_BASE = "http://localhost:8082/api";

defineOptions({
  name: "CommunityPage",
});

const router = useRouter();
const username = ref("");
const userId = ref(null);
const publishDialogVisible = ref(false);
const publishing = ref(false);
const sortBy = ref("hot");
const loading = ref(false);
const currentPage = ref(1);
const postDetailVisible = ref(false);
const selectedPost = ref(null);

const publishForm = ref({
  title: "",
  content: "",
  description: "",
  category: "",
  images: [],
});

const discoveryPosts = ref([]);

const sortedPosts = computed(() => {
  const posts = [...discoveryPosts.value];
  if (sortBy.value === "hot") {
    return posts.sort((a, b) => {
      // 先按点赞数排序
      const likeDiff = b.likes - a.likes;
      if (likeDiff !== 0) {
        return likeDiff;
      }
      // 点赞数相同时，按发布日期排序
      const dateA = new Date(a.publishDate || a.time);
      const dateB = new Date(b.publishDate || b.time);
      return dateB - dateA;
    });
  } else {
    return posts.sort((a, b) => {
      const dateA = new Date(a.publishDate || a.time);
      const dateB = new Date(b.publishDate || b.time);
      return dateB - dateA;
    });
  }
});

const handleImageLoad = (event, post) => {
  const img = event.target;
  if (img && img.naturalWidth && img.naturalHeight) {
    const aspectRatio = img.naturalWidth / img.naturalHeight;

    post.imgStyle = {
      width: "100%",
      height: "auto",
      display: "block",
    };
  }
};

const fetchPosts = async () => {
  try {
    const response = await fetch(`${API_BASE}/posts`, {
      headers: {
        "X-User-Id": userId.value || 1,
      },
    });
    if (response.ok) {
      const data = await response.json();
      discoveryPosts.value = data.map((post) => {
        // 使用工具函数处理图片URL
        const processedPost = processPostImages(post);
        return {
          ...processedPost,
          // 确保有必要的字段
          id: post.id,
          title: post.title,
          description:
            post.description || (post.content ? post.content.substring(0, 100) + "..." : ""),
          author: post.author,
          likes: post.likes || 0,
          comments: post.comments || 0,
          time: post.time,
          category: post.category || "其他",
          categoryType: getCategoryType(post.category || "其他"),
          liked: post.liked || false,
          imgStyle: {
            width: "100%",
            height: "auto",
            display: "block",
          },
        };
      });
    } else {
      console.error("获取帖子失败，状态码:", response.status);
      // 显示错误信息
      ElMessage.error("获取帖子失败，请稍后重试");
      // 确保discoveryPosts为空数组，这样会显示空状态
      discoveryPosts.value = [];
    }
  } catch (error) {
    console.error("获取帖子失败:", error);
    // 显示错误信息
    ElMessage.error("获取帖子失败，请稍后重试");
    // 确保discoveryPosts为空数组，这样会显示空状态
    discoveryPosts.value = [];
  }
};

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  const savedUserId = localStorage.getItem("userId");
  // 尝试从user对象中获取userId
  const userStr = localStorage.getItem("user");
  if (userStr) {
    try {
      const user = JSON.parse(userStr);
      if (user.id) {
        userId.value = user.id;
      } else if (user.userId) {
        userId.value = user.userId;
      }
    } catch (e) {
      console.error("解析用户信息失败", e);
    }
  }
  // 如果从user对象中没有获取到userId，尝试从userId字段获取
  if (!userId.value && savedUserId) {
    userId.value = parseInt(savedUserId);
  }
  if (savedUsername) {
    username.value = savedUsername;
  }
  fetchPosts();
});

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

const showPublishDialog = () => {
  publishDialogVisible.value = true;
};

// 图片预览相关
const previewDialogVisible = ref(false);
const previewImageUrl = ref("");

const handleImageChange = (file, fileList) => {
  // el-upload 的 v-model:file-list 已经自动管理文件列表
  // 不需要手动同步
  console.log("文件列表变化:", fileList.length, "个文件");
};

const handlePictureCardPreview = (file) => {
  // 处理本地文件预览
  if (file.raw) {
    previewImageUrl.value = URL.createObjectURL(file.raw);
  } else {
    previewImageUrl.value = file.url;
  }
  previewDialogVisible.value = true;
};

const handleExceed = () => {
  ElMessage.warning("最多只能上传9张图片");
};

const getCurrentDate = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

const formatDate = (date) => {
  // 将 YYYY-MM-DD 格式化为 YYYY年MM月DD日
  const [year, month, day] = date.split("-");
  return `${year}年${month}月${day}日`;
};

const submitPublish = async () => {
  if (
    !publishForm.value.title ||
    !publishForm.value.content ||
    !publishForm.value.category ||
    !publishForm.value.description ||
    publishForm.value.images.length === 0
  ) {
    ElMessage.warning("请填写标题、标签、简介、内容并上传图片");
    return;
  }

  publishing.value = true;
  try {
    // 确保userId存在
    if (!userId.value) {
      ElMessage.warning("请先登录后再发布内容");
      publishing.value = false;
      return;
    }

    // 上传图片到服务器
    const imageUrls = [];
    console.log("开始上传图片，图片数量:", publishForm.value.images.length);
    for (let i = 0; i < publishForm.value.images.length; i++) {
      const img = publishForm.value.images[i];
      console.log("处理图片:", img);
      if (img.raw) {
        // 创建FormData对象
        const formData = new FormData();
        formData.append("file", img.raw);
        formData.append("type", "community_post");
        // 对于新帖子，暂时没有ID，使用0作为临时ID
        // 后端会在没有ID时使用UUID

        // 上传图片到community_post类别
        const uploadUrl = `${API_BASE}/upload/image`;
        console.log("上传图片到:", uploadUrl);
        try {
          const uploadResponse = await fetch(uploadUrl, {
            method: "POST",
            body: formData,
          });

          console.log("图片上传响应状态:", uploadResponse.status);
          if (uploadResponse.ok) {
            const uploadData = await uploadResponse.json();
            console.log("图片上传响应数据:", uploadData);
            if (uploadData.success) {
              // 使用url字段，因为后端返回的是相对路径
              imageUrls.push(uploadData.url);
              console.log("图片上传成功，路径:", uploadData.url);
            } else {
              ElMessage.error(`图片上传失败: ${uploadData.message}`);
              publishing.value = false;
              return;
            }
          } else {
            console.error("图片上传失败，响应状态:", uploadResponse.status);
            const errorText = await uploadResponse.text();
            console.error("图片上传失败，响应内容:", errorText);
            ElMessage.error("图片上传失败，请重试");
            publishing.value = false;
            return;
          }
        } catch (error) {
          console.error("图片上传异常:", error);
          ElMessage.error(`图片上传异常: ${error.message}`);
          publishing.value = false;
          return;
        }
      } else if (img.url) {
        imageUrls.push(img.url);
        console.log("使用已有的图片URL:", img.url);
      }
    }
    console.log("图片上传完成，imageUrls:", imageUrls);

    console.log("发布帖子数据:", {
      title: publishForm.value.title,
      content: publishForm.value.content,
      category: publishForm.value.category || "其他",
      images: imageUrls,
      userId: userId.value,
    });

    const response = await fetch(`${API_BASE}/posts`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-User-Id": userId.value,
      },
      body: JSON.stringify({
        title: publishForm.value.title,
        content: publishForm.value.content,
        description: publishForm.value.description,
        category: publishForm.value.category || "其他",
        images: imageUrls,
      }),
    });

    if (response.ok) {
      const newPost = await response.json();
      const processedPost = processPostImages(newPost);
      discoveryPosts.value.unshift({
        ...processedPost,
        title: processedPost.title,
        description: processedPost.description || processedPost.content.substring(0, 100) + "...",
        author: processedPost.author,
        likes: processedPost.likes || 0,
        comments: processedPost.comments || 0,
        time: processedPost.time,
        category: processedPost.category || "其他",
        categoryType:
          processedPost.categoryType || getCategoryType(processedPost.category || "其他"),
        liked: processedPost.liked || false,
        imgStyle: {
          width: "100%",
          height: "auto",
          display: "block",
        },
      });
      ElMessage.success("发布成功！");
      publishDialogVisible.value = false;
      publishForm.value = { title: "", content: "", category: "", images: [] };
    } else {
      ElMessage.error("发布失败，请重试");
    }
  } catch (error) {
    console.error("发布失败:", error);
    ElMessage.error("发布失败，请重试");
  } finally {
    publishing.value = false;
  }
};

const getCategoryType = (value) => {
  // 根据分类名称返回对应的 tag 类型
  const map = {
    穿搭分享: "success",
    发型教程: "warning",
    摄影作品: "info",
    汉服制作: "",
    文化活动: "danger",
  };
  return map[value] || "";
};

const viewPost = (post) => {
  // 使用工具函数处理图片URL
  selectedPost.value = processPostImages({
    ...post,
    // 确保有 content 字段，如果没有则使用 description
    content: post.content || post.description,
  });
  postDetailVisible.value = true;
};

const toggleLike = async (post) => {
  // 确保userId存在
  if (!userId.value) {
    ElMessage.warning("请先登录后再进行点赞操作");
    return;
  }

  // 禁用按钮状态，防止重复点击
  const originalLiked = post.liked;
  const originalLikes = post.likes;

  try {
    console.log("点赞操作数据:", {
      postId: post.id,
      userId: userId.value,
    });

    // 先更新本地状态，提供即时反馈
    post.liked = !post.liked;
    post.likes += post.liked ? 1 : -1;

    const response = await fetch(`${API_BASE}/posts/${post.id}/like`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-User-Id": userId.value,
      },
    });

    if (response.ok) {
      const result = await response.json();
      // 确保状态与后端一致
      post.liked = result.liked;
      post.likes = result.likes;
      ElMessage.success(result.liked ? "已点赞" : "已取消点赞");
    } else {
      // 恢复原始状态
      post.liked = originalLiked;
      post.likes = originalLikes;
      ElMessage.error("操作失败，请稍后重试");
    }
  } catch (error) {
    console.error("点赞操作失败:", error);
    // 恢复原始状态
    post.liked = originalLiked;
    post.likes = originalLikes;
    ElMessage.error("网络异常，请稍后重试");
  }
};

// 处理帖子详情弹窗的点赞变化
const handleLikeChanged = ({ postId, liked, likes }) => {
  const post = discoveryPosts.value.find((p) => p.id === postId);
  if (post) {
    // 更新帖子状态
    post.liked = liked;
    post.likes = likes;
  }
};

// 处理帖子详情弹窗的新评论
const handleCommentAdded = ({ postId }) => {
  const post = discoveryPosts.value.find((p) => p.id === postId);
  if (post) {
    post.comments += 1;
  }
};

const changeSort = (type) => {
  sortBy.value = type;
  fetchPosts();
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
.community-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f3e9 0%, #f5f0e4 100%);
}

/* 头部样式 - 修改为和HomePage一致 */
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

.page-header {
  margin-bottom: 30px;
}

.page-title {
  font-size: 32px;
  margin-bottom: 8px;
  color: #8b4513;
  font-weight: 600;
  position: relative;
  padding-left: 16px;
}

.page-title::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: linear-gradient(180deg, #8b4513, #d2691e);
  border-radius: 2px;
}

.page-subtitle {
  color: #666;
  font-size: 16px;
  margin: 0;
}

/* 布局 */
.community-layout {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 24px;
}

/* 发布卡片 */
.section {
  background-color: white;
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 20px;
  box-shadow: 0 4px 20px rgba(139, 69, 19, 0.08);
  transition:
    transform 0.3s ease,
    box-shadow 0.3s ease;
  border: 1px solid rgba(139, 69, 19, 0.1);
}

.section:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 30px rgba(139, 69, 19, 0.12);
}

.publish-card {
  border-top: 4px solid #d2691e;
}

.section-header {
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.section-title {
  font-size: 18px;
  color: #8b4513;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
}

.section-title .el-icon {
  color: #d2691e;
}

.section-subtitle {
  color: #888;
  font-size: 14px;
  margin: 0;
}

/* 发布预览 */
.publish-content-preview {
  background-color: #f9f9f9;
  border: 2px dashed #ddd;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.publish-content-preview:hover {
  background-color: #f0f0f0;
  border-color: #d2691e;
}

.preview-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  color: #999;
  font-size: 14px;
}

.preview-placeholder .el-icon {
  font-size: 18px;
}

/* 发布按钮区域 */
.publish-actions {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.action-tips {
  display: flex;
  justify-content: center;
}

.tip-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #888;
  padding: 8px;
  background-color: #f8f8f8;
  border-radius: 8px;
}

.tip-item .el-icon {
  color: #d2691e;
}

/* 发现板块头部 */
.discovery-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.sort-options {
  display: flex;
  gap: 10px;
}

.sort-options .el-button {
  border-radius: 16px;
  padding: 6px 16px;
}

/* 帖子网格 - 瀑布流布局 */
.posts-grid {
  column-count: 3;
  column-gap: 20px;
  margin-bottom: 24px;
}

.post-card {
  break-inside: avoid;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(139, 69, 19, 0.1);
  background-color: white;
  position: relative;
  margin-bottom: 20px;
}

.post-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(139, 69, 19, 0.15);
}

.post-img {
  width: 100%;
  background-color: #f8f8f8;
  position: relative;
  overflow: hidden;
}

.post-img img {
  width: 100%;
  height: auto;
  display: block;
}

.image-skeleton {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #ccc;
}

.post-content {
  padding: 16px;
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
}

.post-title {
  margin: 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
  flex: 1;
  line-height: 1.4;
}

.post-header .el-tag {
  margin-left: 8px;
  flex-shrink: 0;
}

.post-desc {
  margin: 0 0 12px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.5;
  /* 添加标准 line-clamp 属性 */
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  line-clamp: 2;
  -webkit-box-orient: vertical;
}

.post-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.author-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.post-author {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.post-stats {
  display: flex;
  gap: 16px;
  font-size: 13px;
  color: #888;
}

.post-stats span {
  display: flex;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  transition: color 0.3s;
}

.post-stats .el-icon {
  font-size: 16px;
}

.likes .el-icon.liked {
  color: #ff4757;
}

.likes:hover {
  color: #ff4757;
}

.comments:hover {
  color: #4a90e2;
}

.post-time {
  font-size: 12px;
  color: #999;
  font-weight: normal;
}

/* 上传提示 */
.upload-tips {
  font-size: 12px;
  color: #999;
  margin-bottom: 10px;
}

/* 页脚 */
.footer {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  text-align: center;
  padding: 30px 0;
  margin-top: 40px;
}

.footer-subtitle {
  font-size: 14px;
  opacity: 0.9;
  margin: 8px 0 16px 0;
}

.footer-links {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 16px;
}

.footer-links span {
  font-size: 13px;
  opacity: 0.8;
  cursor: pointer;
  transition: opacity 0.3s;
}

.footer-links span:hover {
  opacity: 1;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .community-layout {
    grid-template-columns: 280px 1fr;
    gap: 20px;
  }

  .posts-grid {
    column-count: 2;
  }
}

@media (max-width: 768px) {
  .community-layout {
    grid-template-columns: 1fr;
  }

  .nav-container {
    flex-direction: column;
    gap: 12px;
  }

  .nav-menu {
    flex-wrap: wrap;
    justify-content: center;
    gap: 8px;
  }

  .nav-item {
    margin: 0;
    font-size: 13px;
    padding: 6px 12px;
  }

  .user-info-vertical {
    align-items: center;
  }

  .page-title {
    font-size: 24px;
  }

  .posts-grid {
    column-count: 2;
  }

  .footer-links {
    flex-wrap: wrap;
    gap: 10px 20px;
  }
}

@media (max-width: 480px) {
  .container {
    padding: 0 12px;
  }

  .section {
    padding: 16px;
  }

  .post-title {
    font-size: 15px;
  }

  .post-desc {
    font-size: 13px;
  }

  .action-tips {
    justify-content: flex-start;
  }

  .posts-grid {
    column-count: 1;
  }
}
</style>
