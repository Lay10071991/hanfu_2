<template>
  <div class="management-container">
    <h2>数据统计</h2>

    <div class="statistics-grid">
      <div class="stat-card">
        <div class="stat-icon">👥</div>
        <div class="stat-info">
          <div class="stat-value">{{ statistics.totalUsers }}</div>
          <div class="stat-label">总用户数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">🎉</div>
        <div class="stat-info">
          <div class="stat-value">{{ statistics.totalActivities }}</div>
          <div class="stat-label">总活动数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">🏪</div>
        <div class="stat-info">
          <div class="stat-value">{{ statistics.totalShops }}</div>
          <div class="stat-label">总店铺数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">📝</div>
        <div class="stat-info">
          <div class="stat-value">{{ statistics.totalPosts }}</div>
          <div class="stat-label">总帖子数</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Statistics",
  data() {
    return {
      statistics: {
        totalUsers: 0,
        totalPosts: 0,
        totalShops: 0,
        totalActivities: 0,
      },
    };
  },
  mounted() {
    this.loadStatistics();
  },
  methods: {
    async loadStatistics() {
      try {
        const [users, posts, shops, activities] = await Promise.all([
          fetch("http://localhost:8082/api/users").then((r) => r.json()),
          fetch("http://localhost:8082/api/posts").then((r) => r.json()),
          fetch("http://localhost:8082/api/shops").then((r) => r.json()),
          fetch("http://localhost:8082/api/activities").then((r) => r.json()),
        ]);

        this.statistics = {
          totalUsers: users.length,
          totalPosts: posts.length,
          totalShops: shops.length,
          totalActivities: activities.length,
        };
      } catch (error) {
        console.error("加载统计数据失败", error);
      }
    },
  },
};
</script>

<style scoped>
@import "./management-common.css";

.statistics-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 30px;
  margin-top: 20px;
}

.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 40px 20px;
  border-radius: 12px;
  color: white;
  display: flex;
  align-items: center;
  gap: 20px;
  height: 160px;
}

.stat-card:nth-child(2) {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-card:nth-child(3) {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-card:nth-child(4) {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-icon {
  font-size: 48px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 36px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  opacity: 0.9;
}
</style>
