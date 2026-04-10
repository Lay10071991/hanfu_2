<template>
  <div class="management-container">
    <div class="header">
      <h2>节日管理</h2>
      <div class="header-buttons">
        <button @click="loadItems" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增节日</button>
      </div>
    </div>
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>节日名称</th>
            <th>日期</th>
            <th>季节</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.date }}</td>
            <td>{{ getSeasonText(item.season) }}</td>
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
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? "编辑节日" : "新增节日" }}</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>节日名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>日期</label>
            <input v-model="form.date" required />
          </div>
          <div class="form-group">
            <label>季节</label>
            <select v-model="form.season" required>
              <option value="spring">春季</option>
              <option value="summer">夏季</option>
              <option value="autumn">秋季</option>
              <option value="winter">冬季</option>
            </select>
          </div>
          <div class="form-group">
            <label>图片</label>
            <div class="upload-area">
              <input
                type="file"
                ref="fileInput"
                @change="handleFileChange"
                accept="image/*"
                style="display: none"
              />
              <div v-if="!imagePreview" class="upload-placeholder" @click="$refs.fileInput.click()">
                <span>点击上传图片</span>
              </div>
              <div v-else class="image-preview">
                <img :src="imagePreview" alt="预览图" />
                <button type="button" @click="removeImage" class="btn-remove">删除</button>
              </div>
            </div>
            <small v-if="uploading">上传中...</small>
          </div>
          <div class="form-group">
            <label>描述</label>
            <textarea v-model="form.description" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label>习俗(用|分隔)</label>
            <textarea v-model="form.customs" rows="3"></textarea>
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
  name: "FestivalManagement",
  data() {
    return {
      items: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showDialog: false,
      isEdit: false,
      uploading: false,
      imagePreview: null,
      form: {
        id: null,
        name: "",
        date: "",
        season: "spring",
        image: "",
        description: "",
        customs: "",
      },
    };
  },
  mounted() {
    this.loadItems();
  },
  methods: {
    async loadItems() {
      try {
        const response = await fetch("http://localhost:8082/api/festival");
        const allItems = await response.json();
        this.totalPages = Math.ceil(allItems.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        this.items = allItems.slice(start, start + this.pageSize);
      } catch (error) {
        console.error("加载失败", error);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        name: "",
        date: "",
        season: "spring",
        image: "",
        description: "",
        customs: "",
      };
      this.imagePreview = null;
      this.showDialog = true;
    },
    editItem(item) {
      this.isEdit = true;
      this.form = { ...item };
      this.imagePreview = item.image ? `http://localhost:8082${item.image}` : null;
      this.showDialog = true;
    },
    async handleFileChange(event) {
      const file = event.target.files[0];
      if (!file) return;

      if (!file.type.startsWith("image/")) {
        alert("请选择图片文件");
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        alert("图片大小不能超过5MB");
        return;
      }

      this.uploading = true;

      try {
        const formData = new FormData();
        formData.append("file", file);
        formData.append("type", "festival_custom");
        if (this.form.id) {
          formData.append("id", this.form.id);
        }

        const response = await fetch("http://localhost:8082/api/upload/image", {
          method: "POST",
          body: formData,
        });

        const result = await response.json();

        if (result.success) {
          this.form.image = result.url
          this.imagePreview = `http://localhost:8082${result.url}?t=${new Date().getTime()}`
        } else {
          alert(result.message || '上传失败')
        }
      } catch (error) {
        console.error("上传失败", error);
        alert("上传失败,请重试");
      } finally {
        this.uploading = false;
        // 清空文件输入框，确保可以选择相同的图片
        event.target.value = "";
      }
    },
    async removeImage() {
      // 如果有图片URL，调用后端删除接口
      if (this.form.image) {
        try {
          const response = await fetch("http://localhost:8082/api/upload/image", {
            method: "DELETE",
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: `url=${encodeURIComponent(this.form.image)}`,
          });

          if (response.ok) {
            const data = await response.json();
            if (!data.success) {
              console.warn("删除图片失败:", data.message);
            }
          }
        } catch (error) {
          console.error("删除图片失败:", error);
        }
      }

      // 清空表单和预览
      this.form.image = "";
      this.imagePreview = null;
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = "";
      }
    },
    async saveItem() {
      if (!this.form.image) {
        alert("请上传图片");
        return;
      }

      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/festival/${this.form.id}`
          : "http://localhost:8082/api/festival";

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
      if (confirm("确定要删除吗？")) {
        try {
          await fetch(`http://localhost:8082/api/festival/${id}`, {
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
    getSeasonText(season) {
      const map = {
        spring: "春季",
        summer: "夏季",
        autumn: "秋季",
        winter: "冬季",
      };
      return map[season] || season;
    },
  },
};
</script>

<style scoped>
@import "./management-common.css";

/* 修复表格横线不正确问题 */
.management-container table {
  border-collapse: collapse;
  width: 100%;
}

.management-container th,
.management-container td {
  border-bottom: 1px solid #eee;
  vertical-align: top;
  padding: 12px 15px;
}

.management-container tr:hover {
  background: #f9f9f9;
}

/* 调整操作列布局，确保横线正确显示 */
.management-container td:last-child {
  text-align: right;
  padding-right: 20px;
}

.management-container td:last-child button {
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

.form-group small {
  color: #999;
  font-size: 12px;
  display: block;
  margin-top: 4px;
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

.upload-area {
  border: 2px dashed #e0e0e0;
  border-radius: 8px;
  padding: 25px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.upload-area:hover {
  border-color: #d2691e;
  background-color: rgba(210, 105, 30, 0.05);
}

.upload-placeholder {
  color: #999;
  font-size: 14px;
}

.image-preview {
  position: relative;
  display: inline-block;
  margin-top: 10px;
}

.image-preview img {
  max-width: 200px;
  max-height: 200px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.btn-remove {
  position: absolute;
  top: -10px;
  right: -10px;
  background: #f56c6c;
  color: white;
  border: none;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  transition: all 0.3s ease;
}

.btn-remove:hover {
  background: #f78989;
  transform: scale(1.1);
}
</style>
