<template>
  <div class="management-container">
    <div class="header">
      <h2>用户管理</h2>
      <div class="header-buttons">
        <button @click="loadUsers" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增用户</button>
      </div>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>用户名</th>
            <th>性别</th>
            <th>角色</th>
            <th>个人简介</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(user, index) in users" :key="user.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ user.username }}</td>
            <td>{{ getGenderText(user.gender) }}</td>
            <td>{{ user.userRole?.roleName || "-" }}</td>
            <td>{{ user.bio || "-" }}</td>
            <td>
              <button @click="editUser(user)" class="btn-edit">编辑</button>
              <button @click="deleteUser(user.id)" class="btn-delete">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="pagination">
      <button @click="prevPage" :disabled="currentPage === 1">上一页</button>
      <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
      <button @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
    </div>

    <!-- 添加/编辑对话框 -->
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? "编辑用户" : "新增用户" }}</h3>
        <form @submit.prevent="saveUser">
          <div class="form-group">
            <label>用户名</label>
            <input v-model="form.username" required />
          </div>
          <div class="form-group">
            <label>密码</label>
            <input v-model="form.password" type="password" :required="!isEdit" />
          </div>
          <div class="form-group">
            <label>性别</label>
            <select v-model="form.gender">
              <option value="male">男</option>
              <option value="female">女</option>
              <option value="unknown">未知</option>
            </select>
          </div>
          <div class="form-group">
            <label>用户角色</label>
            <select v-model.number="form.userRole.id" @change="updateRoleName">
              <option v-for="role in roles" :key="role.id" :value="role.id">
                {{ role.roleName }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>个人简介</label>
            <textarea v-model="form.bio" rows="3"></textarea>
          </div>
          <div class="form-actions">
            <button type="button" @click="closeDialog" class="btn-cancel">取消</button>
            <button type="submit" class="btn-primary">保存</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "UserManagement",
  data() {
    return {
      users: [],
      roles: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        username: "",
        password: "",
        gender: "unknown",
        bio: "",
        userRole: {
          id: 1,
          roleName: "普通用户",
        },
      },
    };
  },
  mounted() {
    this.loadRoles();
    this.loadUsers();
  },
  methods: {
    async loadRoles() {
      try {
        const response = await fetch("http://localhost:8082/api/roles");
        this.roles = await response.json();
      } catch (error) {
        console.error("加载角色失败", error);
        // 如果API不存在，使用默认角色
        this.roles = [
          { id: 1, roleName: "普通用户" },
          { id: 2, roleName: "商家" },
          { id: 3, roleName: "平台负责人" },
        ];
      }
    },
    async loadUsers() {
      try {
        const response = await fetch("http://localhost:8082/api/users");
        const allUsers = await response.json();
        this.totalPages = Math.ceil(allUsers.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        this.users = allUsers.slice(start, start + this.pageSize);
      } catch (error) {
        console.error("加载用户失败", error);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        username: "",
        password: "",
        gender: "unknown",
        bio: "",
        userRole: {
          id: 1,
          roleName: "普通用户",
        },
      };
      this.showDialog = true;
      // 阻止背景滚动
      document.body.style.overflow = "hidden";
    },
    updateRoleName() {
      const selectedRole = this.roles.find((r) => r.id === this.form.userRole.id);
      if (selectedRole) {
        this.form.userRole.roleName = selectedRole.roleName;
      }
    },
    editUser(user) {
      this.isEdit = true;
      this.form = { ...user, password: "" };
      this.showDialog = true;
      // 阻止背景滚动
      document.body.style.overflow = "hidden";
    },
    async saveUser() {
      // 验证用户名长度
      if (this.form.username.length < 2 || this.form.username.length > 20) {
        alert("用户名长度必须在2-20个字符之间");
        return;
      }

      // 验证密码长度（对于新增用户或修改密码的情况）
      if (
        (!this.isEdit || this.form.password) &&
        (this.form.password.length < 6 || this.form.password.length > 20)
      ) {
        alert("密码长度必须在6-20个字符之间");
        return;
      }

      // 检查是否修改了平台负责人（admin）的用户名或密码
      const isAdminUser = this.isEdit && this.form.userRole.id === 3;
      const originalUsername = this.$route.params.username || localStorage.getItem("username");
      const usernameChanged = isAdminUser && this.form.username !== originalUsername;
      const passwordChanged = isAdminUser && this.form.password;

      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/users/${this.form.id}`
          : "http://localhost:8082/api/users";

        await fetch(url, {
          method: this.isEdit ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        this.closeDialog();
        this.loadUsers();

        // 如果修改了平台负责人的用户名或密码，需要重新登录
        if (isAdminUser && (usernameChanged || passwordChanged)) {
          // 清除登录状态
          localStorage.removeItem("isLoggedIn");
          localStorage.removeItem("user");
          localStorage.removeItem("username");

          // 跳转到登录页面
          this.$router.push("/login");
        }
      } catch (error) {
        console.error("保存用户失败", error);
      }
    },
    async deleteUser(id) {
      if (confirm("确定要删除这个用户吗？")) {
        try {
          await fetch(`http://localhost:8082/api/users/${id}`, {
            method: "DELETE",
          });
          this.loadUsers();
        } catch (error) {
          console.error("删除用户失败", error);
        }
      }
    },
    closeDialog() {
      this.showDialog = false;
      // 恢复背景滚动
      document.body.style.overflow = "auto";
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
        this.loadUsers();
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.loadUsers();
      }
    },
    getGenderText(gender) {
      const map = { male: "男", female: "女", unknown: "未知" };
      return map[gender] || "未知";
    },
  },
};
</script>

<style scoped>
@import "./management-common.css";

/* 美化编辑弹窗 */
.modal-content {
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  overflow: hidden;
  animation: modalFadeIn 0.3s ease-in-out;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}

.modal-content form {
  padding: 25px;
  overflow-y: auto;
  overscroll-behavior: contain;
  flex: 1;
}

/* 阻止背景滚动 */
.modal {
  touch-action: none;
}

.modal-content form {
  touch-action: auto;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-content h3 {
  margin: 0;
  padding: 20px;
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  font-size: 18px;
  font-weight: 600;
  border-bottom: none;
}

.modal-content form {
  padding: 25px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  color: #555;
  font-weight: 600;
  font-size: 14px;
}

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  box-sizing: border-box;
  transition: all 0.3s ease;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  outline: none;
  border-color: #d2691e;
  box-shadow: 0 0 0 3px rgba(210, 105, 30, 0.1);
}

.form-group textarea {
  min-height: 120px;
  resize: vertical;
  font-family: inherit;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.btn-cancel,
.btn-primary {
  padding: 10px 24px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.btn-cancel {
  background: #f5f5f5;
  color: #333;
  border: 1px solid #e0e0e0;
}

.btn-cancel:hover {
  background: #e0e0e0;
}

.btn-primary {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(210, 105, 30, 0.3);
}

.btn-primary:hover {
  opacity: 0.9;
  box-shadow: 0 6px 16px rgba(210, 105, 30, 0.4);
  transform: translateY(-1px);
}

.btn-primary:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(210, 105, 30, 0.3);
}
</style>
