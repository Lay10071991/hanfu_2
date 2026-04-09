<template>
  <div class="management-container historical-overview">
    <div class="header">
      <h2>历史概述管理</h2>
      <div class="header-buttons">
        <button @click="loadItems" class="btn-refresh">刷新</button>
      </div>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>标题</th>
            <th>内容</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ index + 1 }}</td>
            <td>{{ item.title }}</td>
            <td class="content-cell">{{ item.content }}</td>
            <td>
              <button @click="editItem(item)" class="btn-edit">编辑</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 编辑对话框 -->
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>编辑历史概述</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>内容</label>
            <textarea v-model="form.content" rows="8" required></textarea>
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
  name: "CulturalContentManagement",
  data() {
    return {
      items: [],
      showDialog: false,
      form: {
        id: null,
        title: "",
        content: "",
        type: "overview",
        name: "",
        years: "",
      },
    };
  },
  mounted() {
    this.loadItems();
  },
  methods: {
    async loadItems() {
      try {
        const response = await fetch("http://localhost:8082/api/cultural-content");
        const allItems = await response.json();
        // 只显示类型为overview的历史概述数据
        this.items = allItems.filter((item) => item.type === "overview");
      } catch (error) {
        console.error("加载历史概述失败", error);
      }
    },
    editItem(item) {
      this.form = { ...item };
      this.showDialog = true;
      // 阻止背景滚动
      document.body.style.overflow = "hidden";
    },
    async saveItem() {
      try {
        const url = `http://localhost:8082/api/cultural-content/${this.form.id}`;

        await fetch(url, {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        this.closeDialog();
        this.loadItems();
      } catch (error) {
        console.error("保存失败", error);
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
        this.loadItems();
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.loadItems();
      }
    },
  },
};
</script>

<style scoped>
@import "./management-common.css";

/* 历史概述部分没有横线 */
.historical-overview table {
  border-collapse: collapse;
  width: 100%;
}

.historical-overview th,
.historical-overview td {
  border: none;
  vertical-align: top;
  padding: 12px 15px;
}

.historical-overview tr:hover {
  background: #f9f9f9;
}

.content-cell {
  max-width: 600px;
  white-space: normal;
  word-wrap: break-word;
  line-height: 1.5;
}

/* 调整表格行高，使内容可以完整展示 */
.historical-overview tr {
  min-height: 100px;
  height: auto;
}

/* 调整操作列布局 */
.historical-overview td:last-child {
  text-align: right;
  padding-right: 20px;
}

.historical-overview td:last-child button {
  margin-left: 5px;
}

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
  overflow-y: auto;
  overscroll-behavior: contain;
  flex: 1;
  touch-action: auto;
}

/* 阻止背景滚动 */
.modal {
  touch-action: none;
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
.form-group textarea {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  box-sizing: border-box;
  transition: all 0.3s ease;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #d2691e;
  box-shadow: 0 0 0 3px rgba(210, 105, 30, 0.1);
}

.form-group textarea {
  min-height: 160px;
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
