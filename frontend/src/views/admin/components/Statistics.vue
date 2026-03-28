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
        <div class="stat-icon">📝</div>
        <div class="stat-info">
          <div class="stat-value">{{ statistics.totalPosts }}</div>
          <div class="stat-label">总帖子数</div>
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
        <div class="stat-icon">🎉</div>
        <div class="stat-info">
          <div class="stat-value">{{ statistics.totalActivities }}</div>
          <div class="stat-label">总活动数</div>
        </div>
      </div>
    </div>

    <div class="charts-container">
      <div class="chart-wrapper">
        <h3>帖子分类分布</h3>
        <div ref="categoryChart" class="chart"></div>
      </div>
      
      <div class="chart-wrapper">
        <h3>用户角色分布</h3>
        <div ref="roleChart" class="chart"></div>
      </div>
      
      <div class="chart-wrapper full-width">
        <h3>最近7天数据趋势</h3>
        <div ref="trendChart" class="chart"></div>
      </div>
      
      <div class="chart-wrapper">
        <h3>店铺评分分布</h3>
        <div ref="ratingChart" class="chart"></div>
      </div>
      
      <div class="chart-wrapper">
        <h3>活动参与度</h3>
        <div ref="activityChart" class="chart"></div>
      </div>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'Statistics',
  data() {
    return {
      statistics: {
        totalUsers: 0,
        totalPosts: 0,
        totalShops: 0,
        totalActivities: 0
      },
      charts: {}
    }
  },
  mounted() {
    this.loadStatistics()
  },
  beforeUnmount() {
    Object.values(this.charts).forEach(chart => chart.dispose())
  },
  methods: {
    async loadStatistics() {
      try {
        const [users, posts, shops, activities] = await Promise.all([
          fetch('http://localhost:8082/api/users').then(r => r.json()),
          fetch('http://localhost:8082/api/posts').then(r => r.json()),
          fetch('http://localhost:8082/api/shops').then(r => r.json()),
          fetch('http://localhost:8082/api/activities').then(r => r.json())
        ])
        
        this.statistics = {
          totalUsers: users.length,
          totalPosts: posts.length,
          totalShops: shops.length,
          totalActivities: activities.length
        }

        this.$nextTick(() => {
          this.initCategoryChart(posts)
          this.initRoleChart(users)
          this.initTrendChart(posts)
          this.initRatingChart(shops)
          this.initActivityChart(activities)
        })
      } catch (error) {
        console.error('加载统计数据失败', error)
      }
    },
    
    initCategoryChart(posts) {
      const categoryCount = {}
      posts.forEach(post => {
        categoryCount[post.category] = (categoryCount[post.category] || 0) + 1
      })
      
      const chart = echarts.init(this.$refs.categoryChart)
      this.charts.category = chart
      
      chart.setOption({
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [{
          name: '帖子分类',
          type: 'pie',
          radius: '60%',
          data: Object.entries(categoryCount).map(([name, value]) => ({ name, value })),
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          }
        }]
      })
    },
    
    initRoleChart(users) {
      const roleCount = {}
      users.forEach(user => {
        const roleName = user.userRole?.roleName || '未知'
        roleCount[roleName] = (roleCount[roleName] || 0) + 1
      })
      
      const chart = echarts.init(this.$refs.roleChart)
      this.charts.role = chart
      
      chart.setOption({
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' }
        },
        xAxis: {
          type: 'category',
          data: Object.keys(roleCount)
        },
        yAxis: {
          type: 'value'
        },
        series: [{
          name: '用户数',
          type: 'bar',
          data: Object.values(roleCount),
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#83bff6' },
              { offset: 1, color: '#188df0' }
            ])
          }
        }]
      })
    },
    
    initTrendChart(posts) {
      const last7Days = []
      const today = new Date()
      for (let i = 6; i >= 0; i--) {
        const date = new Date(today)
        date.setDate(date.getDate() - i)
        last7Days.push(date.toISOString().split('T')[0])
      }
      
      const postCounts = last7Days.map(date => {
        return posts.filter(post => {
          const postDate = new Date(post.publishDate).toISOString().split('T')[0]
          return postDate === date
        }).length
      })
      
      const chart = echarts.init(this.$refs.trendChart)
      this.charts.trend = chart
      
      chart.setOption({
        tooltip: {
          trigger: 'axis'
        },
        xAxis: {
          type: 'category',
          data: last7Days.map(date => date.substring(5)),
          boundaryGap: false
        },
        yAxis: {
          type: 'value'
        },
        series: [{
          name: '发帖数',
          type: 'line',
          data: postCounts,
          smooth: true,
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(58, 77, 233, 0.8)' },
              { offset: 1, color: 'rgba(58, 77, 233, 0.1)' }
            ])
          },
          itemStyle: {
            color: '#3a4de9'
          }
        }]
      })
    },
    
    initRatingChart(shops) {
      const ratingRanges = { '5星': 0, '4-5星': 0, '3-4星': 0, '3星以下': 0 }
      shops.forEach(shop => {
        const rating = shop.averageRating || 0
        if (rating >= 5) ratingRanges['5星']++
        else if (rating >= 4) ratingRanges['4-5星']++
        else if (rating >= 3) ratingRanges['3-4星']++
        else ratingRanges['3星以下']++
      })
      
      const chart = echarts.init(this.$refs.ratingChart)
      this.charts.rating = chart
      
      chart.setOption({
        tooltip: {
          trigger: 'item'
        },
        series: [{
          name: '店铺评分',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: true,
            formatter: '{b}: {c}'
          },
          data: Object.entries(ratingRanges).map(([name, value]) => ({ name, value }))
        }]
      })
    },
    
    initActivityChart(activities) {
      const now = new Date()
      const statusCount = { '未开始': 0, '进行中': 0, '已结束': 0 }
      
      activities.forEach(activity => {
        const startTime = new Date(activity.startTime)
        const endTime = new Date(activity.endTime)
        
        if (now < startTime) statusCount['未开始']++
        else if (now >= startTime && now <= endTime) statusCount['进行中']++
        else statusCount['已结束']++
      })
      
      const chart = echarts.init(this.$refs.activityChart)
      this.charts.activity = chart
      
      chart.setOption({
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' }
        },
        xAxis: {
          type: 'category',
          data: Object.keys(statusCount)
        },
        yAxis: {
          type: 'value'
        },
        series: [{
          name: '活动数',
          type: 'bar',
          data: Object.values(statusCount),
          itemStyle: {
            color: (params) => {
              const colors = ['#5470c6', '#91cc75', '#fac858']
              return colors[params.dataIndex]
            }
          }
        }]
      })
    }
  }
}
</script>

<style scoped>
@import './management-common.css';

.statistics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 30px;
  border-radius: 12px;
  color: white;
  display: flex;
  align-items: center;
  gap: 20px;
}

.stat-card:nth-child(2) {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-card:nth-child(3) {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-card:nth-child(4) {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
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

.charts-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-top: 30px;
}

.chart-wrapper {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.chart-wrapper.full-width {
  grid-column: 1 / -1;
}

.chart-wrapper h3 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
}

.chart {
  width: 100%;
  height: 300px;
}
</style>
