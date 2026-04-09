<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2>汉服文化交流平台</h2>
        <p>传承华夏衣冠，弘扬汉服文化</p>
      </div>

      <el-form :model="loginForm" :rules="loginRules" ref="loginFormRef" class="login-form">
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="用户名"
            size="large"
            :prefix-icon="User"
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="密码"
            size="large"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            size="large"
            class="login-btn"
            @click="handleLogin"
            :loading="loading"
          >
            登录
          </el-button>
        </el-form-item>

        <div class="login-links">
          <span>还没有账号？</span>
          <el-link type="primary" @click="$router.push('/register')">立即注册</el-link>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { User, Lock } from "@element-plus/icons-vue";

defineOptions({
  name: "UserLogin",
});

const router = useRouter();
const loading = ref(false);
const loginFormRef = ref();
// 添加标记防止重复弹窗
const loginSuccessShown = ref(false);

const loginForm = reactive({
  username: "",
  password: "",
});

const loginRules = {
  username: [
    { required: true, message: "请输入用户名", trigger: "blur" },
    { min: 2, max: 20, message: "用户名长度在 2 到 20 个字符", trigger: "blur" },
  ],
  password: [
    { required: true, message: "请输入密码", trigger: "blur" },
    { min: 6, max: 20, message: "密码长度在 6 到 20 个字符", trigger: "blur" },
  ],
};

const handleLogin = async () => {
  if (!loginFormRef.value) return;

  try {
    const valid = await loginFormRef.value.validate();
    if (valid) {
      loading.value = true;

      console.log("开始登录请求...", {
        username: loginForm.username,
        password: loginForm.password,
      });

      // 调用后端登录接口
      const response = await fetch("http://localhost:8082/api/users/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          username: loginForm.username,
          password: loginForm.password,
        }),
      });

      console.log("响应状态:", response.status, response.statusText);

      if (response.ok) {
        const user = await response.json();
        console.log("登录成功，用户信息:", user);

        // 保存登录状态和用户信息
        localStorage.setItem("isLoggedIn", "true");
        localStorage.setItem("user", JSON.stringify(user));
        localStorage.setItem("username", user.username);

        // 添加标记，防止重复显示
        if (!loginSuccessShown.value) {
          loginSuccessShown.value = true;
          ElMessage.success({
            message: "登录成功！",
            duration: 2000,
            showClose: false,
          });
        }

        // 根据用户角色跳转到不同页面
        if (user.userRole) {
          console.log("用户角色:", user.userRole);
          if (user.userRole.id === 3) {
            // 管理员跳转到管理后台
            router.push("/admin");
          } else if (user.userRole.id === 2) {
            // 商家跳转到商家后台
            router.push("/merchant");
          } else {
            // 普通用户跳转到汉服知识库页面
            router.push("/knowledge");
          }
        } else {
          // 默认跳转到汉服知识库页面
          router.push("/knowledge");
        }
      } else {
        const errorText = await response.text();
        console.error("登录失败响应:", errorText);
        ElMessage.error("用户名或密码错误");
      }

      loading.value = false;
    }
  } catch (error) {
    console.error("登录异常:", error);
    console.error("错误详情:", error.message);
    loading.value = false;

    // 更详细的错误提示
    if (error.message.includes("Failed to fetch") || error.message.includes("NetworkError")) {
      ElMessage.error("无法连接到服务器，请确保后端服务已启动（端口8080）");
    } else {
      ElMessage.error("登录失败：" + error.message);
    }
  }
};

// 添加路由守卫，当离开登录页面时重置标记
onUnmounted(() => {
  loginSuccessShown.value = false;
});

// 可选：检查是否已经登录，如果已登录则根据角色跳转到对应页面
onMounted(() => {
  const isLoggedIn = localStorage.getItem("isLoggedIn");
  if (isLoggedIn === "true") {
    // 避免重复弹窗
    loginSuccessShown.value = true;
    // 根据用户角色跳转到对应页面
    const user = JSON.parse(localStorage.getItem("user") || "{}");
    if (user.userRole) {
      if (user.userRole.id === 3) {
        // 管理员跳转到管理后台
        router.push("/admin");
      } else if (user.userRole.id === 2) {
        // 商家跳转到商家后台
        router.push("/merchant");
      } else {
        // 普通用户跳转到汉服知识库页面
        router.push("/knowledge");
      }
    } else {
      // 默认跳转到汉服知识库页面
      router.push("/knowledge");
    }
  }
});
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  background-image: url("/login-bg.jpg");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.login-box {
  width: 400px;
  background: rgba(255, 255, 255, 0.85);
  border-radius: 10px;
  padding: 40px 30px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-header h2 {
  color: #333;
  margin-bottom: 10px;
  font-size: 24px;
}

.login-header p {
  color: #666;
  font-size: 14px;
}

.login-form {
  width: 100%;
}

.login-btn {
  width: 100%;
  margin-top: 10px;
}

.login-links {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #666;
}

.login-links .el-link {
  margin-left: 5px;
}
</style>
