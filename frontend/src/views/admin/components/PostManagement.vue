<template>
  <div class="management-container">
    <div class="header">
      <h2>帖子管理</h2>
      <div class="header-buttons">
        <button @click="loadPosts" class="btn-refresh">刷新</button>
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
      <div class="modal-content large">
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
      selectedPost: {},
      postComments: [],
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

    getImageUrl(url) {
      if (!url) return "";
      // 如果已经是完整URL,直接返回
      if (url.startsWith("http://") || url.startsWith("https://")) {
        return url;
      }
      // 如果是相对路径,添加服务器地址
      return `http://localhost:8082${url}`;
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
