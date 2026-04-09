import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";

// 检查是否是首次启动应用
const isFirstLoad = !localStorage.getItem("appInitialized");

// 只在首次启动时清除登录状态，确保每次启动都是登录页面
if (isFirstLoad) {
  localStorage.removeItem("isLoggedIn");
  localStorage.removeItem("user");
  // 标记应用已初始化
  localStorage.setItem("appInitialized", "true");
}

// Element Plus
import ElementPlus from "element-plus";
import "element-plus/dist/index.css";
import * as ElementPlusIconsVue from "@element-plus/icons-vue";
import zhCn from "element-plus/es/locale/lang/zh-cn";

const app = createApp(App);

// 注册所有图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component);
}

// 正确配置 Element Plus，一次性传入所有配置
app.use(ElementPlus, {
  locale: zhCn,
});

app.use(router);
app.mount("#app");
