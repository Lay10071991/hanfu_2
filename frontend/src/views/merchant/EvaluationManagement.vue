<template>
  <div class="management-container">
    <h2>店铺评价</h2>

    <div v-if="evaluations.length === 0" class="empty-state">
      <p>暂无评价</p>
    </div>

    <div v-else class="evaluation-list">
      <div v-for="evaluation in paginatedEvaluations" :key="evaluation.id" class="evaluation-card">
        <div class="evaluation-header">
          <span class="user-name">{{ evaluation.userName || '匿名用户' }}</span>
          <span class="rating">⭐ {{ evaluation.rating }}</span>
          <span class="date">{{ formatDate(evaluation.createTime) }}</span>
        </div>
        <p class="evaluation-content">{{ evaluation.content }}</p>
        <div class="shop-name">店铺：{{ evaluation.shopName }}</div>
      </div>
    </div>

    <div v-if="totalPages > 1" class="pagination">
      <button @click="prevPage" :disabled="currentPage === 1">上一页</button>
      <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
      <button @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'EvaluationManagement',
  data() {
    return {
      evaluations: [],
      currentPage: 1,
      pageSize: 10
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.evaluations.length / this.pageSize)
    },
    paginatedEvaluations() {
      const start = (this.currentPage - 1) * this.pageSize
      return this.evaluations.slice(start, start + this.pageSize)
    }
  },
  mounted() {
    this.loadEvaluations()
  },
  methods: {
    async loadEvaluations() {
      try {
        const shopsResponse = await fetch('http://localhost:8082/api/shops')
        const shops = await shopsResponse.json()
        
        const userCache = {}
        const allEvaluations = []
        for (const shop of shops) {
          try {
            const response = await fetch(`http://localhost:8082/api/evaluations/shop/${shop.id}`)
            if (!response.ok) continue
            const evaluations = await response.json()
            for (const e of evaluations) {
              e.shopName = shop.name
              if (e.userId && !userCache[e.userId]) {
                try {
                  const userResp = await fetch(`http://localhost:8082/api/users/${e.userId}`)
                  if (userResp.ok) {
                    userCache[e.userId] = await userResp.json()
                  }
                } catch (err) {
                  console.error('获取用户信息失败', err)
                }
              }
              e.userName = userCache[e.userId] ? userCache[e.userId].username : '匿名用户'
              allEvaluations.push(e)
            }
          } catch (err) {
            console.error(`加载店铺${shop.id}评价失败`, err)
          }
        }
        
        this.evaluations = allEvaluations.sort((a, b) => 
          new Date(b.createTime) - new Date(a.createTime)
        )
      } catch (error) {
        console.error('加载评价失败', error)
      }
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
      }
    },
    formatDate(dateString) {
      const date = new Date(dateString)
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      })
    }
  }
}
</script>

<style scoped>
.management-container {
  padding: 20px;
}

.management-container h2 {
  margin: 0 0 20px 0;
  color: #8B4513;
}

.empty-state {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  color: #666;
}

.evaluation-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.evaluation-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.evaluation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.user-name {
  font-weight: bold;
  color: #333;
}

.rating {
  color: #FF9800;
}

.date {
  font-size: 12px;
  color: #999;
}

.evaluation-content {
  margin: 10px 0;
  line-height: 1.4;
  color: #333;
}

.shop-name {
  font-size: 14px;
  color: #666;
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid #f0f0f0;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 30px;
  gap: 15px;
}

.pagination button {
  padding: 6px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: white;
  cursor: pointer;
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination button:hover:not(:disabled) {
  background: #f5f5f5;
}

.pagination span {
  color: #666;
}
</style>