<template>
  <div class="admin-layout">
    <div class="admin-header">
      <h1>管理员后台</h1>
      <div class="user-info">
        <span>{{ username }}</span>
        <button @click="logout" class="logout-btn">退出登录</button>
      </div>
    </div>

    <div class="admin-content">
      <div class="sidebar">
        <div
          v-for="item in menuItems"
          :key="item.name"
          :class="['menu-item', { active: activeMenu === item.name }]"
          @click="activeMenu = item.name"
        >
          <i class="icon">{{ item.icon }}</i>
          <span>{{ item.label }}</span>
        </div>
      </div>

      <div class="main-content">
        <component :is="currentComponent" />
      </div>
    </div>
  </div>
</template>

<script>
import UserManagement from "./components/UserManagement.vue";
import PostManagement from "./components/PostManagement.vue";
import CommentManagement from "./components/CommentManagement.vue";
import ShopManagement from "./components/ShopManagement.vue";
import ActivityManagement from "./components/ActivityManagement.vue";
import CulturalContentManagement from "./components/CulturalContentManagement.vue";
import EtiquetteManagement from "./components/EtiquetteManagement.vue";
import FestivalManagement from "./components/FestivalManagement.vue";
import ShapeTypeManagement from "./components/ShapeTypeManagement.vue";
import PatternManagement from "./components/PatternManagement.vue";
import ComponentManagement from "./components/ComponentManagement.vue";
import CultureInfluenceManagement from "./components/CultureInfluenceManagement.vue";
import Statistics from "./components/Statistics.vue";

export default {
  name: "AdminLayout",
  components: {
    UserManagement,
    PostManagement,
    CommentManagement,
    ShopManagement,
    ActivityManagement,
    CulturalContentManagement,
    EtiquetteManagement,
    FestivalManagement,
    ShapeTypeManagement,
    PatternManagement,
    ComponentManagement,
    CultureInfluenceManagement,
    Statistics,
  },
  data() {
    return {
      activeMenu: "statistics",
      username: "",
      menuItems: [
        { name: "statistics", label: "数据统计", icon: "📊" },
        { name: "users", label: "用户管理", icon: "👥" },
        { name: "shape-type", label: "基本形制", icon: "👗" },
        { name: "pattern", label: "图案象征", icon: "🎨" },
        { name: "component", label: "服饰部件", icon: "👔" },
        { name: "culture-influence", label: "文化影响", icon: "📜" },
        { name: "festival", label: "节日管理", icon: "🎊" },
        { name: "etiquette", label: "礼仪管理", icon: "🙏" },
        { name: "activities", label: "活动管理", icon: "🎉" },
        { name: "shops", label: "店铺管理", icon: "🏪" },
        { name: "posts", label: "帖子管理", icon: "📝" },
        { name: "comments", label: "评论管理", icon: "💬" },

        // { name: 'cultural', label: '文化内容', icon: '📚' },
      ],
    };
  },
  computed: {
    currentComponent() {
      const componentMap = {
        users: "UserManagement",
        posts: "PostManagement",
        comments: "CommentManagement",
        shops: "ShopManagement",
        activities: "ActivityManagement",
        cultural: "CulturalContentManagement",
        etiquette: "EtiquetteManagement",
        festival: "FestivalManagement",
        "shape-type": "ShapeTypeManagement",
        pattern: "PatternManagement",
        component: "ComponentManagement",
        "culture-influence": "CultureInfluenceManagement",
        statistics: "Statistics",
      };
      return componentMap[this.activeMenu];
    },
  },
  mounted() {
    this.checkAuth();
  },
  methods: {
    checkAuth() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      if (!user.userRole || user.userRole.id !== 3) {
        this.$router.push("/login");
      } else {
        this.username = user.username;
      }
    },
    logout() {
      localStorage.removeItem("user");
      localStorage.removeItem("isLoggedIn");
      this.$router.push("/login");
    },
  },
};
</script>

<style scoped>
.admin-layout {
  min-height: 100vh;
  background: #f5f5f5;
}

.admin-header {
  background: white;
  padding: 20px 40px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.admin-header h1 {
  margin: 0;
  color: #8b4513;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 15px;
}

.logout-btn {
  padding: 8px 20px;
  background: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.admin-content {
  display: flex;
  height: calc(100vh - 80px);
}

.sidebar {
  width: 200px;
  background: white;
  padding: 20px 0;
  box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
}

.menu-item {
  padding: 15px 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s;
}

.menu-item:hover {
  background: #f8f9fa;
}

.menu-item.active {
  background: #8b4513;
  color: white;
}

.main-content {
  flex: 1;
  padding: 30px;
  overflow-y: auto;
}
</style>
