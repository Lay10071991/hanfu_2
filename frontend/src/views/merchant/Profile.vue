<template>
  <div class="profile-container">
    <h2>个人信息</h2>

    <div class="profile-card">
      <h3>基本信息</h3>
      <form @submit.prevent="updateProfile">
        <div class="form-group">
          <label>用户名</label>
          <input v-model="profileForm.username" required />
        </div>
        <div class="form-group">
          <label>性别</label>
          <select v-model="profileForm.gender">
            <option value="male">男</option>
            <option value="female">女</option>
            <option value="other">其他</option>
          </select>
        </div>
        <div class="form-group">
          <label>个人简介</label>
          <textarea v-model="profileForm.bio" rows="3"></textarea>
        </div>
        <div class="form-actions">
          <button type="submit" class="btn-save">保存修改</button>
        </div>
      </form>
    </div>

    <div class="profile-card">
      <h3>修改密码</h3>
      <form @submit.prevent="updatePassword">
        <div class="form-group">
          <label>原密码</label>
          <input type="password" v-model="passwordForm.oldPassword" required />
        </div>
        <div class="form-group">
          <label>新密码</label>
          <input type="password" v-model="passwordForm.newPassword" required />
        </div>
        <div class="form-group">
          <label>确认新密码</label>
          <input type="password" v-model="passwordForm.confirmPassword" required />
        </div>
        <div class="form-actions">
          <button type="submit" class="btn-save">修改密码</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: "Profile",
  data() {
    return {
      profileForm: {
        username: "",
        gender: "",
        bio: "",
        userRole: null,
      },
      passwordForm: {
        oldPassword: "",
        newPassword: "",
        confirmPassword: "",
      },
    };
  },
  mounted() {
    this.loadProfile();
  },
  methods: {
    async loadProfile() {
      try {
        const user = JSON.parse(localStorage.getItem("user") || "{}");
        if (!user.id) return;

        const response = await fetch(`http://localhost:8082/api/users/${user.id}`);
        if (response.ok) {
          const userData = await response.json();
          this.profileForm = {
            username: userData.username || "",
            gender: userData.gender || "",
            bio: userData.bio || "",
            userRole: userData.userRole || null,
          };
        }
      } catch (error) {
        console.error("加载个人信息失败", error);
      }
    },
    async updateProfile() {
      try {
        const user = JSON.parse(localStorage.getItem("user") || "{}");
        if (!user.id) return;

        const response = await fetch(`http://localhost:8082/api/users/${user.id}`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(this.profileForm),
        });

        if (response.ok) {
          const updatedUser = await response.json();
          // 更新本地存储的用户信息
          const currentUser = JSON.parse(localStorage.getItem("user") || "{}");
          const newUser = {
            ...currentUser,
            username: updatedUser.username,
            gender: updatedUser.gender,
            bio: updatedUser.bio,
            userRole: updatedUser.userRole || null,
          };
          localStorage.setItem("user", JSON.stringify(newUser));
          alert("个人信息更新成功！");
        } else {
          alert("更新失败，请稍后重试");
        }
      } catch (error) {
        console.error("更新个人信息失败", error);
        alert("更新失败，请稍后重试");
      }
    },
    async updatePassword() {
      if (this.passwordForm.newPassword !== this.passwordForm.confirmPassword) {
        alert("两次输入的新密码不一致");
        return;
      }

      try {
        const user = JSON.parse(localStorage.getItem("user") || "{}");
        if (!user.id) return;

        const response = await fetch(`http://localhost:8082/api/users/${user.id}/password`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            oldPassword: this.passwordForm.oldPassword,
            newPassword: this.passwordForm.newPassword,
          }),
        });

        if (response.ok) {
          alert("密码修改成功，请重新登录！");
          // 清空本地存储
          localStorage.removeItem("user");
          localStorage.removeItem("isLoggedIn");
          localStorage.removeItem("username");
          localStorage.removeItem("gender");
          localStorage.removeItem("bio");
          localStorage.removeItem("role");
          // 跳转到登录页面
          window.location.href = "/login";
        } else {
          alert("密码修改失败，请检查原密码是否正确");
        }
      } catch (error) {
        console.error("修改密码失败", error);
        alert("修改密码失败，请稍后重试");
      }
    },
  },
};
</script>

<style scoped>
.profile-container {
  padding: 20px;
}

.profile-container h2 {
  margin: 0 0 30px 0;
  color: #8b4513;
}

.profile-card {
  background: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 30px;
}

.profile-card h3 {
  margin: 0 0 20px 0;
  color: #333;
  border-bottom: 1px solid #f0f0f0;
  padding-bottom: 10px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-group textarea {
  resize: vertical;
}

.form-actions {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.btn-save {
  padding: 8px 20px;
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.btn-save:hover {
  background: linear-gradient(135deg, #6b340e 0%, #b85a1a 100%);
  transform: translateY(-2px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}
</style>
