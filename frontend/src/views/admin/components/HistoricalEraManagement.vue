<template>
  <div class="management-container historical-timeline">
    <div class="header">
      <h2>历史时间线管理</h2>
      <div class="header-buttons">
        <button @click="loadItems" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增朝代</button>
      </div>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>朝代名称</th>
            <th>年代</th>
            <th>标题</th>
            <th>描述</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.years }}</td>
            <td>{{ item.title }}</td>
            <td>{{ item.description.substring(0, 50) }}...</td>
            <td>
              <button @click="editItem(item)" class="btn-edit">编辑</button>
              <button @click="deleteItem(item.id)" class="btn-delete">删除</button>
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
        <h3>{{ isEdit ? "编辑朝代" : "新增朝代" }}</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>朝代名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>年代</label>
            <input v-model="form.years" required />
          </div>
          <div class="form-group">
            <label>标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>描述</label>
            <textarea v-model="form.description" rows="8" required></textarea>
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
  name: "HistoricalEraManagement",
  data() {
    return {
      items: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        name: "",
        years: "",
        title: "",
        description: "",
      },
    };
  },
  mounted() {
    this.loadItems();
  },
  methods: {
    async loadItems() {
      try {
        const response = await fetch("http://localhost:8082/api/historical-era");
        const allItems = await response.json();
        this.totalPages = Math.ceil(allItems.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        this.items = allItems.slice(start, start + this.pageSize);
      } catch (error) {
        console.error("加载历史朝代失败", error);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        name: "",
        years: "",
        title: "",
        description: "",
      };
      this.showDialog = true;
      // 阻止背景滚动
      document.body.style.overflow = "hidden";
    },
    editItem(item) {
      this.isEdit = true;
      this.form = { ...item };
      this.showDialog = true;
      // 阻止背景滚动
      document.body.style.overflow = "hidden";
    },
    async saveItem() {
      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/historical-era/${this.form.id}`
          : "http://localhost:8082/api/historical-era";

        await fetch(url, {
          method: this.isEdit ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        this.closeDialog();
        this.loadItems();
      } catch (error) {
        console.error("保存失败", error);
      }
    },
    async deleteItem(id) {
      if (confirm("确定要删除这个朝代吗？")) {
        try {
          await fetch(`http://localhost:8082/api/historical-era/${id}`, {
            method: "DELETE",
          });
          this.loadItems();
        } catch (error) {
          console.error("删除失败", error);
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

/* 修复表格横线不正确问题 */
.historical-timeline table {
  border-collapse: collapse;
  width: 100%;
}

.historical-timeline th,
.historical-timeline td {
  border-bottom: 1px solid #eee;
  vertical-align: top;
  padding: 12px 15px;
}

.historical-timeline tr:hover {
  background: #f9f9f9;
}

/* 调整操作列布局，确保横线正确显示 */
.historical-timeline td:last-child {
  text-align: right;
  padding-right: 20px;
}

.historical-timeline td:last-child button {
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
