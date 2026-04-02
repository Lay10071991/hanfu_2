<template>
  <el-dialog
    v-model="visible"
    :title="post.title"
    width="800px"
    :close-on-click-modal="false"
    :fullscreen="isMobile"
    class="post-detail-dialog"
    @close="handleClose"
  >
    <!-- 帖子内容 -->
    <div class="post-detail-content" v-if="post">
      <!-- 图片轮播 -->
      <div class="post-gallery" v-if="post.images && post.images.length > 0">
        <el-carousel
          :height="galleryHeight"
          indicator-position="outside"
          arrow="always"
          class="post-carousel"
        >
          <el-carousel-item v-for="(img, index) in post.images" :key="index">
            <el-image
              :src="img.url"
              :alt="`${post.title}-${index + 1}`"
              fit="contain"
              class="gallery-image"
              :preview-src-list="post.images.map((i) => i.url)"
              :initial-index="index"
            >
              <template #placeholder>
                <div class="image-skeleton">
                  <el-icon><Picture /></el-icon>
                </div>
              </template>
            </el-image>
          </el-carousel-item>
        </el-carousel>
      </div>

      <!-- 单张图片 -->
      <div class="post-image-single" v-else-if="post.image">
        <el-image
          :src="post.image"
          :alt="post.title"
          fit="cover"
          class="single-image"
          :preview-src-list="[post.image]"
        >
          <template #placeholder>
            <div class="image-skeleton">
              <el-icon><Picture /></el-icon>
            </div>
          </template>
        </el-image>
      </div>

      <!-- 帖子元信息 -->
      <div class="post-meta-section">
        <div class="meta-header">
          <div class="author-info">
            <div class="author-name">{{ post.author }}</div>
            <div class="post-time">{{ formatTime(post.time) }}</div>
          </div>

          <div class="meta-actions">
            <el-button
              :type="post.liked ? 'danger' : 'default'"
              :icon="post.liked ? StarFilled : Star"
              @click="toggleLike"
              circle
            />
            <el-button type="default" :icon="ChatDotRound" circle @click="focusCommentInput" />
          </div>
        </div>

        <div class="category-tags">
          <el-tag :type="post.categoryType" size="small">
            {{ post.category }}
          </el-tag>
        </div>
      </div>

      <!-- 帖子内容 -->
      <div class="post-body">
        <h2 class="post-title">{{ post.title }}</h2>
        <div class="post-content-text">
          {{ post.content || post.description }}
        </div>

        <!-- 互动统计 -->
        <div class="interaction-stats">
          <div class="stats-item">
            <el-icon><StarFilled /></el-icon>
            <span>{{ post.likes }} 人点赞</span>
          </div>
          <div class="stats-item">
            <el-icon><ChatDotRound /></el-icon>
            <span>{{ post.comments }} 条评论</span>
          </div>
        </div>
      </div>

      <!-- 评论区域 -->
      <div class="comments-section">
        <div class="comments-header">
          <h3 class="comments-title">评论 ({{ post.comments }})</h3>
        </div>

        <!-- 发表评论 -->
        <div class="comment-input-area">
          <div class="input-wrapper">
            <el-input
              v-model="newComment"
              type="textarea"
              :rows="3"
              placeholder="写下你的评论..."
              maxlength="500"
              show-word-limit
              ref="commentInput"
              @keydown.enter.exact.prevent="submitComment"
            />
            <div class="input-actions">
              <el-button
                type="primary"
                size="small"
                @click="submitComment"
                :disabled="!newComment.trim()"
                :loading="commenting"
              >
                发表评论
              </el-button>
            </div>
          </div>
        </div>

        <!-- 评论列表 -->
        <div class="comments-list" v-if="comments.length > 0">
          <div class="comment-item" v-for="comment in comments" :key="comment.id">
            <div class="comment-content">
              <div class="comment-header">
                <span class="comment-author">{{ comment.author }}</span>
                <span class="comment-time">{{ comment.time }}</span>
              </div>
              <div class="comment-text">{{ comment.content }}</div>
              <div class="comment-actions">
                <el-button type="text" size="small" @click="replyComment(comment)">
                  回复
                </el-button>
                <el-button
                  type="text"
                  size="small"
                  :icon="comment.liked ? StarFilled : Star"
                  @click="toggleCommentLike(comment)"
                >
                  {{ comment.likes || 0 }}
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 加载更多评论 -->
        <div class="load-more-comments">
          <el-button
            v-if="hasMoreComments"
            type="text"
            @click="loadMoreComments"
            :loading="loadingComments"
          >
            加载更多评论
          </el-button>
          <span v-else class="all-comments-text">以上为全部评论</span>
        </div>
      </div>
    </div>

    <!-- 加载中状态 -->
    <div v-else class="loading-state">
      <el-skeleton :rows="5" animated />
    </div>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">关闭</el-button>
        <el-button type="primary" @click="handleSave" v-if="isOwner"> 编辑帖子 </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, computed, onMounted, nextTick, watch } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { Star, StarFilled, ChatDotRound, Picture } from "@element-plus/icons-vue";
import { processPostImages } from "../utils/imageHelper.js";

const API_BASE = "http://localhost:8082/api";

const props = defineProps({
  visible: {
    type: Boolean,
    required: true,
  },
  postId: {
    type: Number,
    required: false,
  },
  postData: {
    type: Object,
    required: false,
  },
});

const emit = defineEmits(["update:visible", "like-changed", "comment-added"]);

// 响应式数据
const visible = computed({
  get: () => props.visible,
  set: (value) => emit("update:visible", value),
});

const post = ref({
  id: props.postId,
  title: "",
  content: "",
  description: "",
  image: "",
  images: [],
  author: "",
  likes: 0,
  comments: 0,
  time: "",
  category: "",
  categoryType: "",
  liked: false,
  tags: [],
});

// 监听 postData 变化，更新 post 数据
watch(
  () => props.postData,
  (newVal) => {
    if (newVal) {
      // 使用工具函数处理图片URL
      const processed = processPostImages(newVal);
      post.value = {
        ...processed,
        // 确保 content 字段存在
        content: processed.content || processed.description || "",
      };
    }
  },
  { immediate: true, deep: true },
);

const newComment = ref("");
const commenting = ref(false);
const loadingComments = ref(false);
const commentInput = ref(null);
const isMobile = ref(false);
const userId = ref(null);

const comments = ref([]);

const fetchComments = async () => {
  if (!post.value.id) return;
  try {
    const response = await fetch(`${API_BASE}/posts/${post.value.id}/comments`);
    if (response.ok) {
      const data = await response.json();
      comments.value = data.map((comment) => ({
        ...comment,
        author: comment.author,
        time: comment.time,
        likes: 0,
        liked: false,
      }));
    }
  } catch (error) {
    console.error("获取评论失败:", error);
  }
};

// 检查用户评论点赞状态函数已不再需要，因为后端API在获取评论时没有包含liked字段
// 保留此函数以保持代码结构完整性，实际使用时会被跳过
const checkCommentLikes = async () => {
  // 由于后端API在获取评论时没有包含liked字段，此函数不再需要执行
  return;
};

watch(
  () => props.visible,
  (newVal) => {
    if (newVal && post.value.id) {
      fetchComments();
    }
  },
);

// 计算属性
const isOwner = computed(() => {
  const username = localStorage.getItem("username") || "";
  return post.value.author === username;
});

const galleryHeight = computed(() => {
  return isMobile.value ? "300px" : "400px";
});

// 判断是否还有更多评论（基于帖子总评论数）
const hasMoreComments = computed(() => {
  return comments.value.length < post.value.comments;
});

// 方法
const handleClose = () => {
  visible.value = false;
  emit("update:visible", false);
};

const handleSave = () => {
  ElMessageBox.prompt("请输入新的标题", "编辑帖子", {
    confirmButtonText: "保存",
    cancelButtonText: "取消",
    inputValue: post.value.title,
  }).then(({ value }) => {
    post.value.title = value;
    ElMessage.success("标题已更新");
  });
};

const toggleLike = async () => {
  // 确保userId存在
  if (!userId.value) {
    ElMessage.warning("请先登录后再进行点赞操作");
    return;
  }

  try {
    const response = await fetch(`${API_BASE}/posts/${post.value.id}/like`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-User-Id": userId.value,
      },
    });

    if (response.ok) {
      const result = await response.json();
      post.value.liked = result.liked;
      post.value.likes = result.likes;
      ElMessage.success(result.liked ? "已点赞" : "已取消点赞");
      emit("like-changed", {
        postId: post.value.id,
        liked: post.value.liked,
        likes: post.value.likes,
      });
    }
  } catch (error) {
    console.error("点赞操作失败:", error);
    // 本地模拟点赞操作
    post.value.liked = !post.value.liked;
    post.value.likes += post.value.liked ? 1 : -1;
    ElMessage.success(post.value.liked ? "已点赞" : "已取消点赞");
    emit("like-changed", {
      postId: post.value.id,
      liked: post.value.liked,
      likes: post.value.likes,
    });
  }
};

const toggleCommentLike = (comment) => {
  // 确保userId存在
  if (!userId.value) {
    ElMessage.warning("请先登录后再进行点赞操作");
    return;
  }

  // 由于后端API没有提供评论点赞功能，仅在前端模拟点赞操作
  comment.liked = !comment.liked;
  comment.likes += comment.liked ? 1 : -1;
};

const submitComment = async () => {
  if (!newComment.value.trim()) {
    ElMessage.warning("请输入评论内容");
    return;
  }

  // 确保userId存在
  if (!userId.value) {
    ElMessage.warning("请先登录后再发表评论");
    commenting.value = false;
    return;
  }

  commenting.value = true;
  try {
    console.log("发表评论数据:", {
      postId: post.value.id,
      content: newComment.value,
      userId: userId.value,
    });

    const response = await fetch(`${API_BASE}/posts/${post.value.id}/comments`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-User-Id": userId.value,
      },
      body: JSON.stringify({
        content: newComment.value.trim(),
      }),
    });

    if (response.ok) {
      const newCommentObj = await response.json();
      comments.value.push({
        ...newCommentObj,
        author: newCommentObj.author,
        time: newCommentObj.time,
        likes: 0,
        liked: false,
      });
      post.value.comments = newCommentObj.postComments || post.value.comments + 1;
      newComment.value = "";

      ElMessage.success("评论发表成功");
      emit("comment-added", {
        postId: post.value.id,
        comment: newCommentObj,
      });
    } else {
      const errorText = await response.text();
      console.error("评论发表失败响应:", errorText);
      ElMessage.error("评论发表失败");
    }
  } catch (error) {
    console.error("评论发表失败:", error);
    ElMessage.error("评论发表失败");
  } finally {
    commenting.value = false;
  }
};

const replyComment = (comment) => {
  newComment.value = `@${comment.author} `;
  nextTick(() => {
    commentInput.value.focus();
  });
};

const focusCommentInput = () => {
  commentInput.value.focus();
};

const loadMoreComments = async () => {
  if (!hasMoreComments.value) return;

  loadingComments.value = true;
  try {
    await new Promise((resolve) => setTimeout(resolve, 500));
  } catch {
    ElMessage.error("加载评论失败");
  } finally {
    loadingComments.value = false;
  }
};

const formatTime = (time) => {
  if (!time) return "";

  if (time === "刚刚") return time;

  const now = new Date();
  const timeMap = {
    小时前: 3600000,
    天前: 86400000,
    周前: 604800000,
    个月前: 2592000000,
  };

  for (const [unit, milliseconds] of Object.entries(timeMap)) {
    if (time.includes(unit)) {
      const num = parseInt(time);
      const postTime = new Date(now.getTime() - num * milliseconds);
      return postTime.toLocaleDateString("zh-CN", {
        year: "numeric",
        month: "short",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      });
    }
  }

  return time;
};

// 生命周期
onMounted(() => {
  isMobile.value = window.innerWidth <= 768;

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
  if (!userId.value) {
    const savedUserId = localStorage.getItem("userId");
    if (savedUserId) {
      userId.value = parseInt(savedUserId);
    }
  }

  if (!props.postData && props.postId) {
    loadPostData();
  }

  window.addEventListener("resize", () => {
    isMobile.value = window.innerWidth <= 768;
  });
});

const loadPostData = async () => {
  try {
    const response = await fetch(`${API_BASE}/posts/${props.postId}`, {
      headers: {
        "X-User-Id": userId.value || 1,
      },
    });

    if (response.ok) {
      const data = await response.json();
      // 使用工具函数处理图片URL
      const processed = processPostImages(data);
      post.value = {
        ...processed,
        content: processed.content || processed.description || "",
      };
    }
  } catch (error) {
    console.error("加载帖子详情失败:", error);
  }
};
</script>

<style scoped>
.post-detail-dialog {
  --dialog-border-radius: 16px;
}

.post-detail-dialog :deep(.el-dialog) {
  border-radius: var(--dialog-border-radius);
  overflow: hidden;
}

.post-detail-dialog :deep(.el-dialog__header) {
  border-bottom: 1px solid #f0f0f0;
  margin-right: 0;
  padding-bottom: 16px;
}

.post-detail-dialog :deep(.el-dialog__body) {
  padding: 0;
  max-height: 70vh;
  overflow-y: auto;
}

.post-detail-content {
  padding: 0;
}

/* 图片区域 */
.post-gallery,
.post-image-single {
  width: 100%;
  background: #f8f8f8;
}

.post-carousel {
  width: 100%;
}

.gallery-image {
  width: 100%;
  height: 100%;
  display: block;
}

.single-image {
  width: 100%;
  height: 400px;
  display: block;
}

.image-skeleton {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  color: #ccc;
}

@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

/* 元信息区域 */
.post-meta-section {
  padding: 20px 24px;
  border-bottom: 1px solid #f0f0f0;
}

.meta-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.author-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.author-name {
  font-weight: 600;
  color: #333;
  font-size: 16px;
}

.post-time {
  font-size: 12px;
  color: #999;
}

.meta-actions {
  display: flex;
  gap: 8px;
}

.meta-actions .el-button {
  border-radius: 50%;
  width: 36px;
  height: 36px;
}

.category-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag-item {
  background-color: #f0f9ff;
  border-color: #91d5ff;
  color: #1890ff;
}

/* 帖子内容区域 */
.post-body {
  padding: 24px;
  border-bottom: 1px solid #f0f0f0;
}

.post-title {
  margin: 0 0 16px 0;
  color: #333;
  font-size: 24px;
  font-weight: 700;
  line-height: 1.3;
}

.post-content-text {
  color: #555;
  font-size: 16px;
  line-height: 1.8;
  white-space: pre-line;
  margin-bottom: 20px;
}

.interaction-stats {
  display: flex;
  gap: 24px;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
}

.stats-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #666;
  font-size: 14px;
}

.stats-item .el-icon {
  color: #d2691e;
}

/* 评论区域 */
.comments-section {
  padding: 24px;
}

.comments-header {
  margin-bottom: 20px;
}

.comments-title {
  margin: 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.comment-input-area {
  margin-bottom: 24px;
}

.input-wrapper {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.input-actions {
  display: flex;
  justify-content: flex-end;
}

/* 评论列表 */
.comments-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.comment-item {
  display: flex;
}

.comment-content {
  flex: 1;
  background-color: #f9f9f9;
  border-radius: 12px;
  padding: 12px 16px;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.comment-author {
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.comment-time {
  font-size: 12px;
  color: #999;
}

.comment-text {
  color: #555;
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 8px;
}

.comment-actions {
  display: flex;
  gap: 16px;
}

.comment-actions .el-button {
  padding: 0;
  height: auto;
  font-size: 12px;
}

/* 加载更多 */
.load-more-comments {
  display: flex;
  justify-content: center;
  padding: 16px 0;
  border-top: 1px solid #f0f0f0;
  margin-top: 20px;
}

.all-comments-text {
  color: #999;
  font-size: 14px;
}

/* 加载中状态 */
.loading-state {
  padding: 40px 24px;
}

/* 对话框底部 */
.dialog-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 24px;
  border-top: 1px solid #f0f0f0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .post-detail-dialog :deep(.el-dialog) {
    width: 100% !important;
    margin: 0;
    height: 100%;
    border-radius: 0;
  }

  .post-detail-dialog :deep(.el-dialog__body) {
    max-height: none;
    height: calc(100% - 120px);
  }

  .post-title {
    font-size: 20px;
  }

  .post-content-text {
    font-size: 15px;
  }

  .gallery-image,
  .single-image {
    height: 300px;
  }
}
</style>
