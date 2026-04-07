<template>
  <div class="management-container">
    <div class="header">
      <h2>帖子管理</h2>
      <div class="header-buttons">
        <button @click="loadPosts" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增帖子</button>
      </div>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>标题</th>
            <th>作者</th>
            <th>分类</th>
            <th>点赞数</th>
            <th>评论数</th>
            <th>发布日期</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(post, index) in posts" :key="post.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ post.title }}</td>
            <td>{{ post.author }}</td>
            <td>{{ post.category }}</td>
            <td>{{ post.likes }}</td>
            <td>{{ post.comments }}</td>
            <td>{{ formatDate(post.publishDate) }}</td>
            <td>
              <button @click="viewPost(post)" class="btn-edit">查看</button>
              <button @click="deletePost(post.id)" class="btn-delete">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="pagination">
      <button @click="prevPage" :disabled="currentPage === 1">上一页</button>
      <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
      <button @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
    </div>

    <!-- 查看详情对话框 -->
    <div v-if="showViewDialog" class="modal" @click.self="closeViewDialog">
      <div class="modal-content">
        <div class="modal-header">
          <h3>帖子详情</h3>
          <button class="close-btn" @click="closeViewDialog">×</button>
        </div>
        <div class="modal-body">
          <div class="post-detail">
            <p><strong>标题：</strong>{{ selectedPost.title }}</p>
            <p><strong>分类：</strong>{{ selectedPost.category }}</p>
            <div v-if="selectedPost.imageUrl" class="detail-image">
              <p><strong>封面图片：</strong></p>
              <img :src="getImageUrl(selectedPost.imageUrl)" alt="封面图" />
            </div>
            <p><strong>简介：</strong></p>
            <p>{{ selectedPost.description }}</p>
            <p><strong>内容：</strong></p>
            <p>{{ selectedPost.content }}</p>
            <p><strong>评论：</strong></p>
            <div v-if="postComments.length > 0" class="comments-list">
              <div v-for="comment in postComments" :key="comment.id" class="comment-item">
                <div class="comment-header">
                  <span class="comment-username">{{ comment.username }}</span>
                  <span class="comment-time">{{ formatDate(comment.createTime) }}</span>
                </div>
                <div class="comment-content">{{ comment.content }}</div>
                <div class="comment-actions">
                  <button @click="deleteComment(comment.id)" class="btn-delete btn-sm">删除</button>
                </div>
              </div>
            </div>
            <div v-else class="no-comments">暂无评论</div>
          </div>
          <div class="form-actions">
            <button @click="closeViewDialog" class="btn-cancel">关闭</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 添加/编辑对话框 -->
    <div v-if="showEditDialog" class="modal" @click.self="closeEditDialog">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ isEdit ? "编辑帖子" : "新增帖子" }}</h3>
          <button class="close-btn" @click="closeEditDialog">×</button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="savePost">
            <div class="form-group">
              <label>标题</label>
              <input v-model="form.title" required />
            </div>
            <div class="form-group">
              <label>分类</label>
              <select v-model="form.category" required>
                <option value="穿搭分享">穿搭分享</option>
                <option value="发型教程">发型教程</option>
                <option value="摄影作品">摄影作品</option>
                <option value="汉服制作">汉服制作</option>
                <option value="文化活动">文化活动</option>
              </select>
            </div>
            <div class="form-group">
              <label>简介</label>
              <textarea v-model="form.description" rows="2" required></textarea>
            </div>
            <div class="form-group">
              <label>内容</label>
              <textarea v-model="form.content" rows="5" required></textarea>
            </div>
            <div class="form-group">
              <label>封面图片</label>
              <div class="upload-area">
                <input
                  type="file"
                  ref="fileInput"
                  @change="handleFileChange"
                  accept="image/*"
                  style="display: none"
                />
                <div
                  v-if="!imagePreview"
                  class="upload-placeholder"
                  @click="$refs.fileInput.click()"
                >
                  <span>点击上传图片</span>
                </div>
                <div v-else class="image-preview">
                  <img :src="imagePreview" alt="预览图" />
                  <button type="button" @click="removeImage" class="btn-remove">删除</button>
                </div>
              </div>
              <small v-if="uploading">上传中...</small>
            </div>
            <div class="form-actions">
              <button type="button" @click="closeEditDialog" class="btn-cancel">取消</button>
              <button type="submit" class="btn-save">保存</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "PostManagement",
  data() {
    return {
      posts: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showViewDialog: false,
      showEditDialog: false,
      isEdit: false,
      selectedPost: {},
      postComments: [],
      uploading: false,
      imagePreview: null,
      form: {
        id: null,
        title: "",
        category: "穿搭分享",
        description: "",
        content: "",
        imageUrl: "",
        authorId: null,
      },
    };
  },
  mounted() {
    this.loadPosts();
  },
  methods: {
    async loadPosts() {
      try {
        const response = await fetch("http://localhost:8082/api/posts");
        const allPosts = await response.json();
        this.totalPages = Math.ceil(allPosts.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        this.posts = allPosts.slice(start, start + this.pageSize);
      } catch (error) {
        console.error("加载帖子失败", error);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      this.form = {
        id: null,
        title: "",
        category: "穿搭分享",
        description: "",
        content: "",
        imageUrl: "",
        authorId: user.id,
      };
      this.imagePreview = null;
      this.showEditDialog = true;
    },
    async viewPost(post) {
      // 确保图片字段正确
      this.selectedPost = {
        ...post,
        imageUrl: post.imageUrl || post.image,
      };
      // 获取帖子的评论
      await this.loadPostComments(post.id);
      this.showViewDialog = true;
    },
    async loadPostComments(postId) {
      try {
        const response = await fetch(`http://localhost:8082/api/posts/${postId}/comments`);
        this.postComments = await response.json();
      } catch (error) {
        console.error("加载评论失败", error);
        this.postComments = [];
      }
    },
    async deleteComment(commentId) {
      if (confirm("确定要删除这条评论吗？")) {
        try {
          await fetch(`http://localhost:8082/api/comments/${commentId}`, {
            method: "DELETE",
          });
          // 重新加载当前帖子的评论
          await this.loadPostComments(this.selectedPost.id);
        } catch (error) {
          console.error("删除评论失败", error);
        }
      }
    },
    editPost(post) {
      this.isEdit = true;
      this.form = {
        id: post.id,
        title: post.title,
        category: post.category,
        description: post.description,
        content: post.content,
        imageUrl: post.imageUrl || post.image,
        authorId: post.authorId,
      };
      // 设置图片预览
      if (this.form.imageUrl) {
        this.imagePreview = this.getImageUrl(this.form.imageUrl);
      } else {
        this.imagePreview = null;
      }
      this.showEditDialog = true;
    },
    getImageUrl(url) {
      if (!url) return "";
      // 如果已经是完整URL,直接返回
      if (url.startsWith("http://") || url.startsWith("https://")) {
        return url;
      }
      // 如果是相对路径,添加服务器地址
      return `http://localhost:8082${url}`;
    },
    async handleFileChange(event) {
      const file = event.target.files[0];
      if (!file) return;

      // 验证文件类型
      if (!file.type.startsWith("image/")) {
        alert("请选择图片文件");
        return;
      }

      // 验证文件大小 (5MB)
      if (file.size > 5 * 1024 * 1024) {
        alert("图片大小不能超过5MB");
        return;
      }

      this.uploading = true;

      try {
        const formData = new FormData();
        formData.append("file", file);

        const response = await fetch("http://localhost:8082/api/upload/image", {
          method: "POST",
          body: formData,
        });

        const result = await response.json();

        if (result.success) {
          this.form.imageUrl = result.url;
          this.imagePreview = `http://localhost:8082${result.url}`;
        } else {
          alert(result.message || "上传失败");
        }
      } catch (error) {
        console.error("上传失败", error);
        alert("上传失败,请重试");
      } finally {
        this.uploading = false;
      }
    },
    removeImage() {
      this.form.imageUrl = "";
      this.imagePreview = null;
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = "";
      }
    },
    async savePost() {
      if (!this.form.imageUrl) {
        alert("请上传封面图片");
        return;
      }

      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/posts/${this.form.id}`
          : "http://localhost:8082/api/posts";

        await fetch(url, {
          method: this.isEdit ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        this.closeEditDialog();
        this.loadPosts();
      } catch (error) {
        console.error("保存帖子失败", error);
      }
    },
    async deletePost(id) {
      if (confirm("确定要删除这个帖子吗？")) {
        try {
          await fetch(`http://localhost:8082/api/posts/${id}`, {
            method: "DELETE",
          });
          this.loadPosts();
        } catch (error) {
          console.error("删除帖子失败", error);
        }
      }
    },
    closeViewDialog() {
      this.showViewDialog = false;
    },
    closeEditDialog() {
      this.showEditDialog = false;
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
        this.loadPosts();
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.loadPosts();
      }
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString("zh-CN");
    },
  },
};
</script>

<style scoped>
@import "./management-common.css";

.post-detail p {
  margin: 10px 0;
  line-height: 1.6;
}

.detail-image {
  margin: 15px 0;
}

.detail-image img {
  max-width: 100%;
  max-height: 400px;
  border-radius: 8px;
  margin-top: 10px;
}

.upload-area {
  margin-top: 8px;
}

.upload-placeholder {
  border: 2px dashed #ddd;
  border-radius: 8px;
  padding: 40px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
}

.upload-placeholder:hover {
  border-color: #8b4513;
  background: #f9f9f9;
}

.upload-placeholder span {
  color: #666;
  font-size: 14px;
}

.image-preview {
  position: relative;
  display: inline-block;
}

.image-preview img {
  max-width: 300px;
  max-height: 200px;
  border-radius: 8px;
  display: block;
}

.btn-remove {
  position: absolute;
  top: 10px;
  right: 10px;
  padding: 5px 10px;
  background: rgba(220, 53, 69, 0.9);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.btn-remove:hover {
  background: rgba(220, 53, 69, 1);
}

.form-group small {
  display: block;
  margin-top: 5px;
  color: #666;
  font-size: 12px;
}

.comments-list {
  margin-top: 15px;
  border-top: 1px solid #eee;
  padding-top: 15px;
}

.comment-item {
  margin-bottom: 15px;
  padding: 10px;
  background-color: #f9f9f9;
  border-radius: 8px;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
  font-size: 14px;
}

.comment-username {
  font-weight: bold;
  color: #8b4513;
}

.comment-time {
  color: #999;
}

.comment-content {
  margin: 10px 0;
  line-height: 1.5;
}

.comment-actions {
  text-align: right;
}

.btn-sm {
  padding: 3px 8px;
  font-size: 12px;
}

.no-comments {
  margin-top: 10px;
  color: #999;
  font-style: italic;
}
</style>
