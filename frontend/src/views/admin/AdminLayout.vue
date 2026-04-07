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
        <div v-for="item in menuItems" :key="item.name">
          <div
            :class="['menu-item', { active: activeMenu === item.name }]"
            @click="toggleSubMenu(item)"
          >
            <i class="icon">{{ item.icon }}</i>
            <span>{{ item.label }}</span>
            <i v-if="item.subMenu" class="expand-icon">{{ item.expanded ? "▼" : "▶" }}</i>
          </div>
          <div v-if="item.expanded && item.subMenu">
            <div
              v-for="subItem in item.subMenu"
              :key="subItem.name"
              :class="['sub-menu-item', { active: activeMenu === subItem.name }]"
              @click="activeMenu = subItem.name"
            >
              <span>{{ subItem.label }}</span>
            </div>
          </div>
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
import HistoricalEraManagement from "./components/HistoricalEraManagement.vue";
import CultureInfluenceManagement from "./components/CultureInfluenceManagement.vue";
import EtiquetteManagement from "./components/EtiquetteManagement.vue";
import FestivalManagement from "./components/FestivalManagement.vue";
import ShapeTypeManagement from "./components/ShapeTypeManagement.vue";
import HanfuDisplayManagement from "./components/HanfuDisplayManagement.vue";
import PatternManagement from "./components/PatternManagement.vue";
import ComponentManagement from "./components/ComponentManagement.vue";
import FestivalActivityManagement from "./components/FestivalActivityManagement.vue";
import ExhibitionManagement from "./components/ExhibitionManagement.vue";
import LectureManagement from "./components/LectureManagement.vue";
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
    HistoricalEraManagement,
    CultureInfluenceManagement,
    EtiquetteManagement,
    FestivalManagement,
    ShapeTypeManagement,
    HanfuDisplayManagement,
    PatternManagement,
    ComponentManagement,
    FestivalActivityManagement,
    ExhibitionManagement,
    LectureManagement,
    Statistics,
  },
  data() {
    return {
      activeMenu: "statistics",
      username: "",
      menuItems: [
        { name: "statistics", label: "数据统计", icon: "📊" },
        { name: "users", label: "用户管理", icon: "👥" },
        {
          name: "historical",
          label: "历史管理",
          icon: "📜",
          expanded: false,
          subMenu: [
            { name: "historical-overview", label: "历史概述" },
            { name: "historical-timeline", label: "历史时间线" },
            { name: "historical-influence", label: "文化影响与传承" },
          ],
        },
        {
          name: "shape-type",
          label: "形制管理",
          icon: "👗",
          expanded: false,
          subMenu: [
            { name: "shape-type-basic", label: "基本形制" },
            { name: "shape-type-display", label: "千载衣冠" },
          ],
        },
        { name: "pattern", label: "图案管理", icon: "🎨" },
        {
          name: "cultural",
          label: "文化管理",
          icon: "📚",
          expanded: false,
          subMenu: [
            { name: "cultural-etiquette", label: "礼容仪态" },
            { name: "cultural-festival", label: "节俗礼仪" },
          ],
        },
        {
          name: "activities",
          label: "活动管理",
          icon: "🎉",
          expanded: false,
          subMenu: [
            { name: "activities-festival", label: "节庆雅集" },
            { name: "activities-exhibition", label: "展览" },
            { name: "activities-lecture", label: "讲座" },
          ],
        },
        { name: "shops", label: "店铺管理", icon: "🏪" },
        {
          name: "community",
          label: "社区管理",
          icon: "🌐",
          expanded: false,
          subMenu: [
            { name: "community-posts", label: "帖子管理" },
            { name: "community-comments", label: "评论管理" },
          ],
        },
      ],
    };
  },
  computed: {
    currentComponent() {
      const componentMap = {
        users: "UserManagement",
        shops: "ShopManagement",
        "activities-festival": "FestivalActivityManagement",
        "activities-exhibition": "ExhibitionManagement",
        "activities-lecture": "LectureManagement",
        activities: "ActivityManagement",
        "cultural-etiquette": "EtiquetteManagement",
        "cultural-festival": "FestivalManagement",
        "shape-type-basic": "ShapeTypeManagement",
        "shape-type-display": "HanfuDisplayManagement",
        pattern: "PatternManagement",
        "historical-overview": "CulturalContentManagement",
        "historical-timeline": "HistoricalEraManagement",
        "historical-influence": "CultureInfluenceManagement",
        "community-posts": "PostManagement",
        "community-comments": "CommentManagement",
        community: "PostManagement",
        statistics: "Statistics",
      };
      return componentMap[this.activeMenu];
    },
  },
  mounted() {
    this.checkAuth();
    // 从localStorage中恢复之前的活动菜单
    const savedMenu = localStorage.getItem("activeMenu");
    if (savedMenu) {
      this.activeMenu = savedMenu;
    }
  },
  methods: {
    toggleSubMenu(item) {
      if (item.subMenu) {
        // 关闭其他展开的菜单
        this.menuItems.forEach((menuItem) => {
          if (menuItem.name !== item.name) {
            menuItem.expanded = false;
          }
        });
        // 切换当前菜单的展开状态
        item.expanded = !item.expanded;
      } else {
        this.activeMenu = item.name;
      }
    },

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
    refreshPage() {
      // 保存当前活动菜单
      localStorage.setItem("activeMenu", this.activeMenu);
      // 重新加载当前路由
      this.$router.go(0);
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

.refresh-btn {
  padding: 8px 15px;
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 10px;
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

.sub-menu-item {
  padding: 10px 40px;
  cursor: pointer;
  transition: all 0.3s;
  background: #f8f9fa;
}

.sub-menu-item:hover {
  background: #e9ecef;
}

.sub-menu-item.active {
  background: #8b4513;
  color: white;
}

.expand-icon {
  margin-left: auto;
  font-size: 12px;
}

.main-content {
  flex: 1;
  padding: 30px;
  overflow-y: auto;
}
</style>
