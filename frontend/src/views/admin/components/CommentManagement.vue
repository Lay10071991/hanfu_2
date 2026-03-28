<template>
  <div class="management-container">
    <div class="header">
      <h2>评论管理</h2>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>评论内容</th>
            <th>所属帖子</th>
            <th>评论用户</th>
            <th>点赞数</th>
            <th>评论时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(comment, index) in comments" :key="comment.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ comment.content }}</td>
            <td>{{ comment.postTitle }}</td>
            <td>{{ comment.username }}</td>
            <td>{{ comment.likes }}</td>
            <td>{{ formatDate(comment.createTime) }}</td>
            <td>
              <button @click="deleteComment(comment.id)" class="btn-delete">删除</button>
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
  </div>
</template>

<script>
export default {
  name: 'CommentManagement',
  data() {
    return {
      comments: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1
    }
  },
  mounted() {
    this.loadComments()
  },
  methods: {
    async loadComments() {
      try {
        const response = await fetch('http://localhost:8082/api/comments')
        const allComments = await response.json()
        this.totalPages = Math.ceil(allComments.length / this.pageSize)
        const start = (this.currentPage - 1) * this.pageSize
        this.comments = allComments.slice(start, start + this.pageSize)
      } catch (error) {
        console.error('加载评论失败', error)
      }
    },
    async deleteComment(id) {
      if (confirm('确定要删除这条评论吗？')) {
        try {
          await fetch(`http://localhost:8082/api/comments/${id}`, {
            method: 'DELETE'
          })
          this.loadComments()
        } catch (error) {
          console.error('删除评论失败', error)
        }
      }
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
        this.loadComments()
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
        this.loadComments()
      }
    },
    formatDate(dateTime) {
      return new Date(dateTime).toLocaleString('zh-CN')
    }
  }
}
</script>

<style scoped>
@import './management-common.css';
</style>
