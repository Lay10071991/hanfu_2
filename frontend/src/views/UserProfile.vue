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
                <span>我的互动</span>
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
                  <!-- 标题和按钮行 -->
                  <div class="post-header-new">
                    <div class="post-title-area">
                      <h4 class="post-title">{{ post.title }}</h4>
                      <el-tag
                        v-if="post.category"
                        :type="getCategoryType(post.category)"
                        size="small"
                        class="post-tag"
                      >
                        {{ post.category }}
                      </el-tag>
                    </div>
                    <div class="post-actions-new">
                      <el-button type="primary" size="small" @click="viewPostDetails(post.id)">
                        查看
                      </el-button>
                      <el-button type="warning" size="small" @click="editPost(post)">
                        修改
                      </el-button>
                      <el-button type="danger" size="small" @click="deletePost(post.id)">
                        删除
                      </el-button>
                    </div>
                  </div>
                  <!-- 内容和图片区域 -->
                  <div class="post-content-area">
                    <!-- 图片区域 -->
                    <div v-if="post.images && post.images.length > 0" class="post-image-area">
                      <img
                        v-for="(image, index) in post.images"
                        :key="index"
                        :src="image"
                        alt="帖子图片"
                        class="post-image-new"
                      />
                    </div>
                    <!-- 内容区域 -->
                    <div class="post-text-area">
                      <p class="post-content">{{ post.content }}</p>
                    </div>
                  </div>
                  <!-- 日期和统计信息 -->
                  <div class="post-meta-new">
                    <span class="post-date">{{ post.date }}</span>
                    <div class="post-stats-new">
                      <span class="post-likes">❤️ {{ post.likes }}</span>
                      <span class="post-comments">💬 {{ post.comments }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <el-empty v-if="userPosts.length === 0" description="暂无发帖记录" />
            </div>

            <!-- 我的互动 -->
            <div v-else-if="activeMenu === 'likes'" class="section">
              <h3 class="content-title">我的互动</h3>
              <div class="posts-list">
                <div
                  class="post-item"
                  v-for="interaction in userInteractions"
                  :key="interaction.id"
                >
                  <!-- 标题和按钮行 -->
                  <div class="post-header-new">
                    <div class="post-title-area">
                      <h4 class="post-title">{{ interaction.postTitle }}</h4>
                      <el-tag
                        v-if="interaction.postCategory"
                        :type="getCategoryType(interaction.postCategory)"
                        size="small"
                        class="post-tag"
                      >
                        {{ interaction.postCategory }}
                      </el-tag>
                    </div>
                    <div class="post-actions-new">
                      <el-button
                        type="primary"
                        size="small"
                        @click="viewPostDetails(interaction.postId)"
                      >
                        查看帖子
                      </el-button>
                      <el-button
                        :type="interaction.liked ? 'danger' : 'warning'"
                        size="small"
                        @click="toggleLike(interaction.postId)"
                      >
                        {{ interaction.liked ? "取消点赞" : "点赞" }}
                      </el-button>
                    </div>
                  </div>
                  <!-- 内容和图片区域 -->
                  <div class="post-content-area">
                    <!-- 图片区域 -->
                    <div
                      v-if="interaction.postImages && interaction.postImages.length > 0"
                      class="post-image-area"
                    >
                      <img
                        v-for="(image, index) in interaction.postImages"
                        :key="index"
                        :src="image"
                        alt="帖子图片"
                        class="post-image-new"
                      />
                    </div>
                    <!-- 内容区域 -->
                    <div class="post-text-area">
                      <p class="post-content">{{ interaction.postContent }}</p>
                    </div>
                  </div>
                  <!-- 日期和统计信息 -->
                  <div class="post-meta-new">
                    <span class="post-date">{{ interaction.date }}</span>
                    <div class="post-stats-new">
                      <span class="post-likes">❤️ {{ interaction.likes }}</span>
                      <span class="post-comments">💬 {{ interaction.comments }}</span>
                    </div>
                  </div>
                  <!-- 我的评论 -->
                  <div
                    v-if="interaction.myComments && interaction.myComments.length > 0"
                    class="my-comments"
                  >
                    <h5>我的评论</h5>
                    <div
                      class="comment-item"
                      v-for="comment in interaction.myComments"
                      :key="comment.id"
                    >
                      <p class="comment-content">{{ comment.content }}</p>
                      <div class="comment-meta">
                        <span class="comment-date">{{ comment.date }}</span>
                        <el-button type="text" size="small" @click="deleteComment(comment.id)">
                          删除评论
                        </el-button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <el-empty v-if="userInteractions.length === 0" description="暂无互动记录" />
            </div>

            <!-- 新增：活动报名 -->
            <div v-else-if="activeMenu === 'activity-registrations'" class="section">
              <h3 class="content-title">我的活动报名</h3>
              <div class="registrations-header">
                <el-tabs v-model="registrationTab" class="registration-tabs">
                  <el-tab-pane label="节庆雅集" name="festival"></el-tab-pane>
                  <el-tab-pane label="展览" name="exhibition"></el-tab-pane>
                  <el-tab-pane label="讲座" name="lecture"></el-tab-pane>
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
                            取消预约
                          </el-button>
                          <el-button
                            type="primary"
                            size="small"
                            @click="
                              viewActivityDetails(
                                registration.activityId,
                                registration.activityType,
                                registration,
                              )
                            "
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
    <el-dialog v-model="postDialogVisible" title="修改帖子" width="600px" :append-to-body="true">
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

    <!-- 展览详情弹窗 -->
    <el-dialog
      v-model="exhibitionDialogVisible"
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
                  <div class="info-value">
                    {{ selectedExhibition.organizer || "汉服文化交流平台" }}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="detail-section">
            <h4>展览介绍</h4>
            <p>
              {{
                selectedExhibition.detailDescription ||
                selectedExhibition.description ||
                "暂无详细介绍"
              }}
            </p>
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
          <el-button @click="exhibitionDialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 讲座详情弹窗 -->
    <el-dialog v-model="lectureDialogVisible" :title="selectedLecture?.title" width="700px" center>
      <div v-if="selectedLecture" class="lecture-detail-content">
        <div class="detail-info-section">
          <div class="info-row">
            <div class="info-item">
              <el-icon><User /></el-icon>
              <div class="info-content">
                <div class="info-label">主讲人</div>
                <div class="info-value">{{ selectedLecture.speaker || "待定" }}</div>
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
                <div class="info-value">{{ selectedLecture.time || "全天" }}</div>
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
          <el-button @click="lectureDialogVisible = false">关闭</el-button>
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
  Ticket,
} from "@element-plus/icons-vue";

const API_BASE = "http://localhost:8082/api";

const router = useRouter();
const route = useRoute();
const username = ref("");
const activeMenu = ref("info");
const editDialogVisible = ref(false);
const passwordDialogVisible = ref(false);
const passwordFormRef = ref();
const registrationTab = ref("festival");
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
const userInteractions = ref([]);

// 展览详情弹窗
const exhibitionDialogVisible = ref(false);
const selectedExhibition = ref(null);

// 讲座详情弹窗
const lectureDialogVisible = ref(false);
const selectedLecture = ref(null);

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
const activityRegistrations = ref([]);

// 新增：获取活动报名数据
const fetchActivityRegistrations = async () => {
  const userId = getUserId();
  if (!userId) {
    ElMessage.warning("请先登录");
    router.push("/login");
    return;
  }

  loading.value = true;
  try {
    // 获取节庆雅集报名数据
    const festivalResponse = await fetch(`${API_BASE}/festival-activity`);
    if (festivalResponse.ok) {
      const festivalActivities = await festivalResponse.json();
      const festivalRegistrations = await Promise.all(
        festivalActivities.map(async (activity) => {
          try {
            const checkResponse = await fetch(
              `${API_BASE}/festival-activity/${activity.id}/registration/check?userId=${userId}`,
            );
            if (checkResponse.ok) {
              const checkData = await checkResponse.json();
              if (checkData.isRegistered) {
                return {
                  id: `festival-${activity.id}`,
                  activityId: activity.id,
                  activityName: activity.title,
                  activityType: "festival",
                  location: activity.location,
                  time: activity.date,
                  registrationDate: new Date().toLocaleDateString(),
                  status: "upcoming",
                };
              }
            }
          } catch (error) {
            console.error("检查节庆报名失败:", error);
          }
          return null;
        }),
      );
      activityRegistrations.value = festivalRegistrations.filter((r) => r !== null);
    }

    // 获取展览报名数据
    const exhibitionResponse = await fetch(`${API_BASE}/exhibitions`);
    if (exhibitionResponse.ok) {
      const exhibitions = await exhibitionResponse.json();
      const exhibitionRegistrations = await Promise.all(
        exhibitions.map(async (exhibition) => {
          try {
            const checkResponse = await fetch(
              `${API_BASE}/exhibitions/${exhibition.id}/registration/check?userId=${userId}`,
            );
            if (checkResponse.ok) {
              const checkData = await checkResponse.json();
              if (checkData.isRegistered) {
                return {
                  id: `exhibition-${exhibition.id}`,
                  activityId: exhibition.id,
                  activityName: exhibition.title,
                  activityType: "exhibition",
                  location: exhibition.location,
                  time: `${exhibition.startDate} 至 ${exhibition.endDate}`,
                  registrationDate: new Date().toLocaleDateString(),
                  status: "upcoming",
                };
              }
            }
          } catch (error) {
            console.error("检查展览报名失败:", error);
          }
          return null;
        }),
      );
      activityRegistrations.value = [
        ...activityRegistrations.value,
        ...exhibitionRegistrations.filter((r) => r !== null),
      ];
    }

    // 获取讲座报名数据
    const lectureResponse = await fetch(`${API_BASE}/lectures`);
    if (lectureResponse.ok) {
      const lectures = await lectureResponse.json();
      const lectureRegistrations = await Promise.all(
        lectures.map(async (lecture) => {
          try {
            const checkResponse = await fetch(
              `${API_BASE}/lectures/${lecture.id}/registration/check?userId=${userId}`,
            );
            if (checkResponse.ok) {
              const checkData = await checkResponse.json();
              if (checkData.isRegistered) {
                return {
                  id: `lecture-${lecture.id}`,
                  activityId: lecture.id,
                  activityName: lecture.title,
                  activityType: "lecture",
                  location: lecture.location,
                  time: lecture.time,
                  registrationDate: new Date().toLocaleDateString(),
                  status: "upcoming",
                };
              }
            }
          } catch (error) {
            console.error("检查讲座报名失败:", error);
          }
          return null;
        }),
      );
      activityRegistrations.value = [
        ...activityRegistrations.value,
        ...lectureRegistrations.filter((r) => r !== null),
      ];
    }
  } catch (error) {
    console.error("获取活动报名数据失败:", error);
    ElMessage.error("获取活动报名数据失败");
  } finally {
    loading.value = false;
  }
};

// 计算属性：根据标签过滤活动
const filteredRegistrations = computed(() => {
  if (registrationTab.value === "festival") {
    return activityRegistrations.value.filter((item) => item.activityType === "festival");
  } else if (registrationTab.value === "exhibition") {
    return activityRegistrations.value.filter((item) => item.activityType === "exhibition");
  } else if (registrationTab.value === "lecture") {
    return activityRegistrations.value.filter((item) => item.activityType === "lecture");
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
    } else if (route.query.menu === "likes") {
      fetchUserInteractions();
    } else if (route.query.menu === "activity-registrations") {
      fetchActivityRegistrations();
    }
  }
});

const handleMenuSelect = (index) => {
  activeMenu.value = index;
  if (index === "evaluations") {
    fetchUserEvaluations();
  } else if (index === "posts") {
    fetchUserPosts();
  } else if (index === "likes") {
    fetchUserInteractions();
  } else if (index === "activity-registrations") {
    fetchActivityRegistrations();
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
    festival: "暂无节庆雅集活动",
    exhibition: "暂无展览活动",
    lecture: "暂无讲座活动",
  };
  return map[registrationTab.value] || "暂无活动记录";
};

// 新增：取消预约
const cancelRegistration = async (registrationId) => {
  ElMessageBox.confirm("确定要取消预约吗？取消后如需参加需要重新预约。", "取消预约确认", {
    confirmButtonText: "确定取消",
    cancelButtonText: "再想想",
    type: "warning",
  })
    .then(async () => {
      const userId = getUserId();
      if (!userId) {
        ElMessage.warning("请先登录");
        router.push("/login");
        return;
      }

      try {
        // 解析registrationId，获取activityId和activityType
        const [activityType, id] = registrationId.split("-");
        let response;

        if (activityType === "festival") {
          response = await fetch(
            `${API_BASE}/festival-activity/${id}/registration?userId=${userId}`,
            {
              method: "DELETE",
            },
          );
        } else if (activityType === "exhibition") {
          response = await fetch(`${API_BASE}/exhibitions/${id}/registration?userId=${userId}`, {
            method: "DELETE",
          });
        } else if (activityType === "lecture") {
          response = await fetch(`${API_BASE}/lectures/${id}/registration?userId=${userId}`, {
            method: "DELETE",
          });
        }

        if (response && response.ok) {
          const index = activityRegistrations.value.findIndex((item) => item.id === registrationId);
          if (index !== -1) {
            activityRegistrations.value[index].status = "cancelled";
            ElMessage.success("已成功取消预约");
          }
        } else {
          ElMessage.error("取消预约失败");
        }
      } catch (error) {
        console.error("取消预约失败:", error);
        ElMessage.error("网络异常，请稍后重试");
      }
    })
    .catch(() => {
      // 用户取消操作
    });
};

// 新增：查看活动详情
const viewActivityDetails = async (activityId, activityType, registration) => {
  if (activityType === "festival") {
    router.push(`/festival-activity/${activityId}`);
  } else if (activityType === "exhibition") {
    // 从后端获取展览详情
    try {
      const response = await fetch(`${API_BASE}/exhibitions/${activityId}`);
      if (response.ok) {
        const data = await response.json();
        selectedExhibition.value = {
          id: data.id,
          title: data.title,
          date: data.date,
          location: data.location,
          description: data.description,
          detailDescription: data.detailDescription,
          image: data.image,
          detailImage: data.detailImage,
          ticket: data.ticket,
          organizer: data.organizer,
          highlights: data.highlights,
          notice: data.notice,
        };
      } else {
        // 如果后端没有数据，使用注册信息
        selectedExhibition.value = {
          id: registration.activityId,
          title: registration.activityName,
          date: registration.time,
          location: registration.location,
          description: "暂无详细介绍",
          image: "http://localhost:8082/uploads/exhibition-1.png",
        };
      }
    } catch (error) {
      console.error("获取展览详情失败:", error);
      // 使用注册信息
      selectedExhibition.value = {
        id: registration.activityId,
        title: registration.activityName,
        date: registration.time,
        location: registration.location,
        description: "暂无详细介绍",
        image: "http://localhost:8082/uploads/exhibition-1.png",
      };
    }
    exhibitionDialogVisible.value = true;
  } else if (activityType === "lecture") {
    // 从后端获取讲座详情
    try {
      const response = await fetch(`${API_BASE}/lectures/${activityId}`);
      if (response.ok) {
        const data = await response.json();
        selectedLecture.value = {
          id: data.id,
          title: data.title,
          date: data.date,
          time: data.time,
          location: data.location,
          description: data.description,
          speaker: data.speaker,
          speakerBio: data.speakerBio,
          content: data.content,
          notice: data.notice,
        };
      } else {
        // 如果后端没有数据，使用注册信息
        selectedLecture.value = {
          id: registration.activityId,
          title: registration.activityName,
          date: registration.time,
          location: registration.location,
          description: "暂无详细介绍",
        };
      }
    } catch (error) {
      console.error("获取讲座详情失败:", error);
      // 使用注册信息
      selectedLecture.value = {
        id: registration.activityId,
        title: registration.activityName,
        date: registration.time,
        location: registration.location,
        description: "暂无详细介绍",
      };
    }
    lectureDialogVisible.value = true;
  }
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
        category: post.category || "",
        date: post.time || "",
        likes: post.likes || 0,
        comments: post.comments || 0,
        images: post.images || [],
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

// 获取标签类型
const getCategoryType = (value) => {
  const map = {
    穿搭分享: "success",
    发型教程: "warning",
    摄影作品: "info",
    汉服制作: "",
    文化活动: "danger",
  };
  return map[value] || "";
};

// 查看帖子详情
const viewPostDetails = (postId) => {
  // 先在userPosts中查找
  let post = userPosts.value.find((p) => p.id === postId);

  // 如果找不到，在userInteractions中查找
  if (!post) {
    const interaction = userInteractions.value.find((i) => i.postId === postId);
    if (interaction) {
      post = {
        id: interaction.postId,
        title: interaction.postTitle,
        content: interaction.postContent,
        category: interaction.postCategory,
        date: interaction.date,
        likes: interaction.likes,
        comments: interaction.comments,
        images: interaction.postImages || [],
        author: interaction.author,
      };
    }
  }

  if (post) {
    selectedPost.value = { ...post };
    postDetailVisible.value = true;
  }
};

// 修改帖子
const editPost = (post) => {
  console.log("editPost called", post);
  // 简化处理，直接设置currentPost和打开弹窗
  currentPost.value = {
    id: post.id,
    title: post.title,
    content: post.content,
    images: post.images || [],
  };
  // 确保images是数组
  if (!Array.isArray(currentPost.value.images)) {
    currentPost.value.images = [];
  }
  // 转换图片格式
  currentPost.value.images = currentPost.value.images.map((url) => ({
    url: url,
    name: url.split("/").pop(),
    status: "success",
  }));
  postDialogVisible.value = true;
  console.log("postDialogVisible set to", postDialogVisible.value);
  console.log("currentPost set to", currentPost.value);
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
  // 重新加载互动数据
  if (activeMenu.value === "likes") {
    fetchUserInteractions();
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

// 加载用户互动数据
const fetchUserInteractions = async () => {
  const userId = getUserId();
  if (!userId) {
    ElMessage.warning("请先登录");
    router.push("/login");
    return;
  }

  loading.value = true;
  try {
    // 获取所有帖子（带用户ID以获取点赞状态）
    const response = await fetch(`${API_BASE}/posts`, {
      headers: {
        "X-User-Id": userId,
      },
    });
    if (response.ok) {
      const allPosts = await response.json();

      // 筛选出用户点赞的帖子
      const likedPosts = allPosts.filter((post) => post.liked);

      // 转换为互动数据格式
      const interactions = likedPosts.map((post) => ({
        id: post.id,
        postId: post.id,
        postTitle: post.title,
        postContent: post.content,
        postCategory: post.category || "",
        postImages: post.images
          ? post.images.map((img) => img.url || img)
          : post.image
            ? [post.image]
            : [],
        author: post.author,
        date: post.time || "",
        likes: post.likes || 0,
        comments: post.comments || 0,
        liked: true,
        myComments: [],
      }));

      userInteractions.value = interactions;
    } else {
      userInteractions.value = [];
    }
  } catch (error) {
    console.error("获取互动记录失败:", error);
    ElMessage.error("网络异常，请稍后重试");
    userInteractions.value = [];
  } finally {
    loading.value = false;
  }
};

// 切换点赞状态
const toggleLike = async (postId) => {
  const userId = getUserId();
  if (!userId) {
    ElMessage.warning("请先登录");
    router.push("/login");
    return;
  }

  try {
    // 这里需要调用后端API切换点赞状态
    const response = await fetch(`${API_BASE}/posts/${postId}/like`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ userId }),
    });
    if (response.ok) {
      const result = await response.json();
      // 更新本地数据
      const interaction = userInteractions.value.find((item) => item.postId === postId);
      if (interaction) {
        interaction.liked = result.liked;
        interaction.likes = result.likes;
      }
      ElMessage.success(result.liked ? "点赞成功" : "取消点赞成功");
    } else {
      ElMessage.error("操作失败");
    }
  } catch (error) {
    console.error("操作失败:", error);
    ElMessage.error("网络异常，请稍后重试");
  }
};

// 删除评论
const deleteComment = async (commentId) => {
  ElMessageBox.confirm("确定要删除这条评论吗？删除后无法恢复。", "删除确认", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(async () => {
      try {
        // 这里需要调用后端API删除评论
        const response = await fetch(`${API_BASE}/comments/${commentId}`, {
          method: "DELETE",
        });
        if (response.ok) {
          ElMessage.success("评论删除成功");
          // 重新加载互动数据
          fetchUserInteractions();
        } else {
          ElMessage.error("删除评论失败");
        }
      } catch (error) {
        console.error("删除评论失败:", error);
        ElMessage.error("网络异常，请稍后重试");
      }
    })
    .catch(() => {
      // 取消删除
    });
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

/* 简化的帖子样式 */
.post-header-new {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.post-title-area {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
}

.post-title {
  font-size: 16px;
  font-weight: bold;
  color: #8b4513;
  margin: 0;
}

.post-tag {
  flex-shrink: 0;
}

.post-actions-new {
  display: flex;
  gap: 8px;
}

.post-content-area {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

.post-image-area {
  flex-shrink: 0;
}

.post-image-new {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 4px;
}

.post-text-area {
  flex: 1;
  padding: 10px;
  min-height: 100px;
}

.post-content {
  margin: 0;
  line-height: 1.5;
  color: #333;
}

.post-meta-new {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  color: #999;
  margin-top: 10px;
}

.post-stats-new {
  display: flex;
  gap: 15px;
}

/* 简化的互动部分样式 */
.interactions-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.interaction-item {
  background-color: #fff;
  border-radius: 4px;
  padding: 15px;
  border: 1px solid #eee;
}

.interaction-post {
  margin-bottom: 10px;
}

.interaction-actions {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
  padding-top: 10px;
  border-top: 1px solid #eee;
}

.my-comments {
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid #eee;
}

.my-comments h5 {
  margin: 0 0 8px 0;
  font-size: 14px;
  font-weight: bold;
  color: #8b4513;
}

.comment-item {
  background-color: #f9f9f9;
  border-radius: 4px;
  padding: 8px;
  margin-bottom: 8px;
}

.comment-content {
  margin: 0 0 6px 0;
  line-height: 1.5;
  color: #333;
}

.comment-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: #999;
}

/* 展览详情弹窗样式 */
.exhibition-detail-dialog {
  max-height: 70vh;
  overflow-y: auto;
}

.exhibition-detail-dialog .detail-header {
  margin-bottom: 20px;
}

.exhibition-detail-dialog .detail-image {
  width: 100%;
  height: 300px;
  border-radius: 8px;
  overflow: hidden;
}

.exhibition-detail-dialog .detail-content {
  padding: 0 10px;
}

.exhibition-detail-dialog .detail-info {
  background-color: #f9f5f0;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
}

.exhibition-detail-dialog .info-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 15px;
}

.exhibition-detail-dialog .info-row:last-child {
  margin-bottom: 0;
}

.exhibition-detail-dialog .info-item {
  display: flex;
  align-items: center;
  gap: 15px;
}

.exhibition-detail-dialog .info-item .el-icon {
  color: #8b4513;
  font-size: 24px;
}

.exhibition-detail-dialog .info-content {
  flex: 1;
}

.exhibition-detail-dialog .info-label {
  font-size: 12px;
  color: #999;
  margin-bottom: 4px;
}

.exhibition-detail-dialog .info-value {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.exhibition-detail-dialog .detail-section {
  margin-bottom: 25px;
}

.exhibition-detail-dialog .detail-section h4 {
  color: #8b4513;
  font-size: 18px;
  margin: 0 0 15px 0;
  padding-bottom: 8px;
  border-bottom: 2px solid #d4a76a;
}

.exhibition-detail-dialog .detail-section p {
  color: #666;
  line-height: 1.8;
  margin-bottom: 15px;
}

.exhibition-detail-dialog .highlight-list,
.exhibition-detail-dialog .notice-list {
  padding-left: 20px;
  margin: 0;
}

.exhibition-detail-dialog .highlight-list li,
.exhibition-detail-dialog .notice-list li {
  color: #666;
  line-height: 1.8;
  margin-bottom: 8px;
}

.exhibition-detail-dialog .highlight-list li:last-child,
.exhibition-detail-dialog .notice-list li:last-child {
  margin-bottom: 0;
}

.exhibition-detail-dialog .dialog-footer {
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

.lecture-detail-content .detail-info-section {
  background-color: #f9f5f0;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
}

.lecture-detail-content .info-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 15px;
}

.lecture-detail-content .info-row:last-child {
  margin-bottom: 0;
}

.lecture-detail-content .info-item {
  display: flex;
  align-items: center;
  gap: 15px;
}

.lecture-detail-content .info-item .el-icon {
  color: #8b4513;
  font-size: 24px;
  flex-shrink: 0;
}

.lecture-detail-content .info-content {
  flex: 1;
}

.lecture-detail-content .info-label {
  font-size: 12px;
  color: #999;
  margin-bottom: 4px;
}

.lecture-detail-content .info-value {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.lecture-detail-content .detail-section {
  margin-bottom: 25px;
}

.lecture-detail-content .detail-section h4 {
  color: #8b4513;
  font-size: 18px;
  margin: 0 0 15px 0;
  padding-bottom: 8px;
  border-bottom: 2px solid #d4a76a;
}

.lecture-detail-content .detail-section p {
  color: #666;
  line-height: 1.8;
  margin: 0;
}

.lecture-detail-content .content-list,
.lecture-detail-content .notice-list {
  padding-left: 20px;
  margin: 0;
}

.lecture-detail-content .content-list li,
.lecture-detail-content .notice-list li {
  color: #666;
  line-height: 1.8;
  margin-bottom: 8px;
}

.lecture-detail-content .content-list li:last-child,
.lecture-detail-content .notice-list li:last-child {
  margin-bottom: 0;
}

.lecture-detail-content .content-list li {
  position: relative;
  padding-left: 10px;
}

.lecture-detail-content .content-list li::before {
  content: "📚";
  position: absolute;
  left: -15px;
}

.lecture-detail-content .notice-list li {
  position: relative;
  padding-left: 10px;
}

.lecture-detail-content .notice-list li::before {
  content: "•";
  position: absolute;
  left: -10px;
  color: #8b4513;
}

.lecture-detail-content .dialog-footer {
  display: flex;
  justify-content: flex-end;
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
