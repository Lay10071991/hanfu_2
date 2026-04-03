import { createRouter, createWebHistory } from "vue-router";

import Knowledge from "../views/Knowledge.vue";
import Login from "../views/Login.vue";
import Register from "../views/Register.vue";
import UserProfile from "../views/UserProfile.vue";
import ShopProfile from "../views/ShopProfile.vue";
import CultureLearning from "../views/CultureLearning.vue";
import ActivityGathering from "../views/ActivityGathering.vue";
import ShopEvaluation from "../views/ShopEvaluation.vue";
import ShopList from "../views/ShopList.vue";
import ShopDetail from "../views/ShopDetail.vue";
import Community from "../views/Community.vue";
import HistoryEvolution from "../views/HistoryEvolution.vue";
import ShapeClassification from "../views/ShapeClassification.vue";
import PatternSymbolismDetail from "../views/PatternSymbolismDetail.vue";
import EtiquetteDetail from "../views/EtiquetteDetail.vue";
import FestivalDetail from "../views/FestivalDetail.vue";
import FestivalGathering from "../views/FestivalGathering.vue";
import FestivalActivityDetail from "../views/FestivalActivityDetail.vue";
import ExhibitionList from "../views/ExhibitionList.vue";
import LectureList from "../views/LectureList.vue";
import LectureDetail from "../views/LectureDetail.vue";
import ShopEvaluationForm from "../views/ShopEvaluationForm.vue";
import AiChat from "../views/AiChat.vue";
import AdminLayout from "../views/admin/AdminLayout.vue";
import MerchantLayout from "../views/merchant/MerchantLayout.vue";

const routes = [
  {
    path: "/",
    redirect: "/login",
  },
  {
    path: "/knowledge",
    name: "Home",
    component: Knowledge,
  },
  {
    path: "/login",
    name: "Login",
    component: Login,
  },
  {
    path: "/register",
    name: "Register",
    component: Register,
  },
  {
    path: "/profile",
    name: "Profile",
    component: UserProfile,
  },
  {
    path: "/shop-profile",
    name: "ShopProfile",
    component: ShopProfile,
  },
  {
    path: "/culture",
    name: "Culture",
    component: CultureLearning,
  },
  {
    path: "/activity",
    name: "Activity",
    component: ActivityGathering,
  },
  {
    path: "/shop-evaluation",
    name: "ShopEvaluation",
    component: ShopEvaluation,
  },
  {
    path: "/shop-evaluation-form/:id",
    name: "ShopEvaluationForm",
    component: ShopEvaluationForm,
    props: true,
  },
  {
    path: "/shop-list",
    name: "ShopList",
    component: ShopList,
  },
  {
    path: "/shop-detail/:id",
    name: "ShopDetail",
    component: ShopDetail,
    props: true,
  },
  {
    path: "/community",
    name: "Community",
    component: Community,
  },
  {
    path: "/history-evolution",
    name: "HistoryEvolution",
    component: HistoryEvolution,
  },
  {
    path: "/shape-classification",
    name: "ShapeClassification",
    component: ShapeClassification,
  },
  {
    path: "/pattern",
    name: "PatternSymbolism",
    component: PatternSymbolismDetail,
  },
  {
    path: "/pattern/:id",
    name: "PatternSymbolismDetail",
    component: PatternSymbolismDetail,
    props: true,
  },
  {
    path: "/etiquette-detail",
    name: "EtiquetteDetail",
    component: EtiquetteDetail,
  },
  {
    path: "/festival-detail",
    name: "FestivalDetail",
    component: FestivalDetail,
  },
  {
    path: "/festival-gathering",
    name: "FestivalGathering",
    component: FestivalGathering,
  },
  {
    path: "/festival-activity/:id",
    name: "FestivalActivityDetail",
    component: FestivalActivityDetail,
    props: true,
  },
  {
    path: "/exhibition-list",
    name: "ExhibitionList",
    component: ExhibitionList,
  },
  {
    path: "/lecture-list",
    name: "LectureList",
    component: LectureList,
  },
  {
    path: "/lecture-detail/:id",
    name: "LectureDetail",
    component: LectureDetail,
    props: true,
  },
  {
    path: "/ai-chat",
    name: "AiChat",
    component: AiChat,
  },
  {
    path: "/admin",
    name: "AdminLayout",
    component: AdminLayout,
  },
  {
    path: "/merchant",
    name: "MerchantLayout",
    component: MerchantLayout,
  },
  {
    path: "/:pathMatch(.*)*",
    redirect: "/",
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// 路由守卫
router.beforeEach((to, from, next) => {
  const isLoggedIn = localStorage.getItem("isLoggedIn") === "true";
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const userRole = user.userRole;
  
  // 不需要登录的页面
  const publicPages = ["/login", "/register"];
  
  // 需要登录的页面
  if (!publicPages.includes(to.path) && !isLoggedIn) {
    next("/login");
    return;
  }
  
  // 权限控制
  if (isLoggedIn) {
    // 管理员页面只能管理员访问
    if (to.path.startsWith("/admin") && (!userRole || userRole.id !== 3)) {
      if (userRole && userRole.id === 2) {
        next("/merchant");
      } else {
        next("/knowledge");
      }
      return;
    }
    
    // 商家页面只能商家访问
    if (to.path.startsWith("/merchant") && (!userRole || userRole.id !== 2)) {
      if (userRole && userRole.id === 3) {
        next("/admin");
      } else {
        next("/knowledge");
      }
      return;
    }
  }
  
  next();
});

export default router;
