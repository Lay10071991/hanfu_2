<template>
  <div class="management-container">
    <h2>店铺评价</h2>

    <!-- 店铺选择 -->
    <div class="shop-filter">
      <label for="shop-select">选择店铺：</label>
      <select id="shop-select" v-model="selectedShopId" @change="currentPage = 1">
        <option v-for="shop in shops" :key="shop.id" :value="shop.id">{{ shop.name }}</option>
      </select>
    </div>

    <div v-if="filteredEvaluations.length === 0" class="empty-state">
      <p>暂无评价</p>
    </div>

    <div v-else class="evaluation-list">
      <div v-for="evaluation in paginatedEvaluations" :key="evaluation.id" class="evaluation-card">
        <div class="evaluation-header">
          <span class="user-name">{{ evaluation.userName || "匿名用户" }}</span>
          <span class="rating">⭐ {{ evaluation.rating }}</span>
          <span class="date">{{ formatDate(evaluation.createTime) }}</span>
          <button @click="deleteEvaluation(evaluation.id)" class="btn-delete">删除</button>
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
  name: "EvaluationManagement",
  data() {
    return {
      shops: [],
      selectedShopId: null,
      evaluations: [],
      currentPage: 1,
      pageSize: 10,
    };
  },
  computed: {
    filteredEvaluations() {
      if (!this.selectedShopId && this.shops.length > 0) {
        return this.evaluations.filter((e) => e.shopId == this.shops[0].id);
      } else {
        return this.evaluations.filter((e) => e.shopId == this.selectedShopId);
      }
    },
    totalPages() {
      return Math.ceil(this.filteredEvaluations.length / this.pageSize);
    },
    paginatedEvaluations() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredEvaluations.slice(start, start + this.pageSize);
    },
  },
  mounted() {
    this.loadEvaluations();
  },
  methods: {
    async loadEvaluations() {
      try {
        const user = JSON.parse(localStorage.getItem("user") || "{}");
        if (!user.id) return;

        const shopsResponse = await fetch(`http://localhost:8082/api/shops?userId=${user.id}`);
        const shops = await shopsResponse.json();
        this.shops = shops;
        // 设置默认选择第一个店铺
        if (shops.length > 0) {
          this.selectedShopId = shops[0].id;
        }

        const userCache = {};
        const allEvaluations = [];
        for (const shop of shops) {
          try {
            const response = await fetch(`http://localhost:8082/api/evaluations/shop/${shop.id}`);
            if (!response.ok) continue;
            const evaluations = await response.json();
            for (const e of evaluations) {
              e.shopName = shop.name;
              e.shopId = shop.id;
              if (e.userId && !userCache[e.userId]) {
                try {
                  const userResp = await fetch(`http://localhost:8082/api/users/${e.userId}`);
                  if (userResp.ok) {
                    userCache[e.userId] = await userResp.json();
                  }
                } catch (err) {
                  console.error("获取用户信息失败", err);
                }
              }
              e.userName = userCache[e.userId] ? userCache[e.userId].username : "匿名用户";
              allEvaluations.push(e);
            }
          } catch (err) {
            console.error(`加载店铺${shop.id}评价失败`, err);
          }
        }

        this.evaluations = allEvaluations.sort(
          (a, b) => new Date(b.createTime) - new Date(a.createTime),
        );
      } catch (error) {
        console.error("加载评价失败", error);
      }
    },
    async deleteEvaluation(id) {
      if (!confirm("确定要删除这条评价吗？")) return;

      try {
        const response = await fetch(`http://localhost:8082/api/evaluations/${id}`, {
          method: "DELETE",
        });
        if (response.ok) {
          this.evaluations = this.evaluations.filter((e) => e.id !== id);
          alert("删除成功！");
        } else {
          alert("删除失败，请稍后重试");
        }
      } catch (error) {
        console.error("删除评价失败", error);
        alert("删除失败，请稍后重试");
      }
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    },
    formatDate(dateString) {
      const date = new Date(dateString);
      return date.toLocaleString("zh-CN", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      });
    },
  },
};
</script>

<style scoped>
.management-container {
  padding: 20px;
}

.management-container h2 {
  margin: 0 0 20px 0;
  color: #8b4513;
}

.shop-filter {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.shop-filter label {
  font-weight: bold;
  color: #333;
}

.shop-filter select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  min-width: 200px;
}

.empty-state {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.evaluation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  flex-wrap: wrap;
  gap: 10px;
}

.user-name {
  font-weight: bold;
  color: #333;
}

.rating {
  color: #ff9800;
}

.date {
  font-size: 12px;
  color: #999;
}

.btn-delete {
  padding: 4px 8px;
  background: #f44336;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.btn-delete:hover {
  background: #d32f2f;
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
