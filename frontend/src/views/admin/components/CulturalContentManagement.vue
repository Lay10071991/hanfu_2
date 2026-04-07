<template>
  <div class="management-container">
    <div class="header">
      <h2>历史概述管理</h2>
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

.content-cell {
  max-width: 600px;
  white-space: normal;
  word-wrap: break-word;
  line-height: 1.5;
  padding: 10px;
}

/* 调整表格行高，使内容可以完整展示 */
tr {
  min-height: 100px;
  height: auto;
}

/* 调整表格单元格垂直对齐方式 */
td {
  vertical-align: top;
}
</style>
