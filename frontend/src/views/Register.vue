<template>
  <div class="register-container">
    <div class="register-box">
      <div class="register-header">
        <h2>用户注册</h2>
        <p>加入汉服文化交流平台</p>
      </div>

      <el-form
        :model="registerForm"
        :rules="registerRules"
        ref="registerFormRef"
        class="register-form"
      >
        <el-form-item prop="username">
          <el-input
            v-model="registerForm.username"
            placeholder="用户名"
            size="large"
            :prefix-icon="User"
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="密码"
            size="large"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>

        <el-form-item prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="确认密码"
            size="large"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>

        <el-form-item prop="gender">
          <el-radio-group v-model="registerForm.gender" size="large">
            <el-radio label="unknown">未知</el-radio>
            <el-radio label="male">男</el-radio>
            <el-radio label="female">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item prop="bio">
          <el-input
            v-model="registerForm.bio"
            type="textarea"
            placeholder="个人简介"
            :rows="3"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>

        <el-form-item prop="role">
          <el-select
            v-model="registerForm.role"
            placeholder="选择角色"
            size="large"
            style="width: 100%"
          >
            <el-option label="普通用户" value="user" />
            <el-option label="商家" value="merchant" />
            <el-option label="平台负责人" value="admin" />
          </el-select>
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            size="large"
            class="register-btn"
            @click="handleRegister"
            :loading="loading"
          >
            确定注册
          </el-button>
        </el-form-item>

        <div class="register-links">
          <span>已有账号？</span>
          <el-link type="primary" @click="$router.push('/login')">立即登录</el-link>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'

defineOptions({
  name: 'UserRegister'
})

const router = useRouter()
const loading = ref(false)
const registerFormRef = ref()

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  gender: 'unknown',
  bio: '',
  role: 'user'
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入密码'))
  } else if (value !== registerForm.password) {
    callback(new Error('两次输入密码不一致!'))
  } else {
    callback()
  }
}

const registerRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, validator: validateConfirmPassword, trigger: 'blur' }
  ],
  gender: [
    { required: true, message: '请选择性别', trigger: 'change' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ]
}

const handleRegister = async () => {
  if (!registerFormRef.value) return

  try {
    const valid = await registerFormRef.value.validate()
    if (valid) {
      loading.value = true
      // 模拟注册请求
      setTimeout(() => {
        // 保存用户信息（实际项目中应该发送到后端）
        localStorage.setItem('username', registerForm.username)
        localStorage.setItem('gender', registerForm.gender)
        localStorage.setItem('bio', registerForm.bio)
        localStorage.setItem('role', registerForm.role)

        ElMessage.success('注册成功！')
        router.push('/login')
        loading.value = false
      }, 1000)
    }
  } catch (error) {
    console.error('注册失败:', error)
    loading.value = false
    ElMessage.error('请正确填写表单')
  }
}
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  background-image: url('/login-bg.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.register-box {
  width: 450px;
  background: rgba(255, 255, 255, 0.85);
  border-radius: 10px;
  padding: 40px 30px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

.register-header {
  text-align: center;
  margin-bottom: 30px;
}

.register-header h2 {
  color: #333;
  margin-bottom: 10px;
  font-size: 24px;
}

.register-header p {
  color: #666;
  font-size: 14px;
}

.register-form {
  width: 100%;
}

.register-btn {
  width: 100%;
  margin-top: 10px;
}

.register-links {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #666;
}

.register-links .el-link {
  margin-left: 5px;
}
</style>
