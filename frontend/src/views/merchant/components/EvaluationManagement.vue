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
    formatDate(date) {
      return new Date(date).toLocaleDateString('zh-CN')
    }
  }
}
</script>

<style scoped>
@import '../../admin/components/management-common.css';

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
}

.evaluation-list {
  display: grid;
  gap: 15px;
}

.evaluation-card {
  border: 1px solid #e0e0e0;
  padding: 15px;
  border-radius: 8px;
  background: white;
}

.evaluation-header {
  display: flex;
  gap: 15px;
  margin-bottom: 10px;
  font-size: 14px;
  flex-wrap: wrap;
}

.user-name {
  font-weight: bold;
  color: #333;
}

.rating {
  color: #ff9800;
}

.date {
  color: #999;
}

.evaluation-content {
  color: #666;
  margin-bottom: 10px;
  line-height: 1.6;
}

.shop-name {
  font-size: 12px;
  color: #999;
}
</style>
