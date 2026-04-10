<template>
  <div class="management-container">
    <div class="header">
      <h2>节庆雅集管理</h2>
      <div class="header-buttons">
        <button @click="loadActivities" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增节庆雅集</button>
      </div>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>活动标题</th>
            <th>活动日期</th>
            <th>活动地点</th>
            <th>活动图片</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(activity, index) in activities" :key="activity.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ activity.title }}</td>
            <td>{{ activity.date || "-" }}</td>
            <td>{{ activity.location }}</td>
            <td>
              <img
                v-if="activity.image"
                :src="activity.image.replace('backend/uploads/', 'http://localhost:8082/uploads/')"
                alt="活动图片"
                style="width: 50px; height: 50px; object-fit: cover"
              />
              <span v-else>-</span>
            </td>
            <td>
              <button @click="editActivity(activity)" class="btn-edit">编辑</button>
              <button @click="deleteActivity(activity.id)" class="btn-delete">删除</button>
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
        <h3>{{ isEdit ? "编辑节庆雅集" : "新增节庆雅集" }}</h3>
        <form @submit.prevent="saveActivity">
          <div class="form-group">
            <label>活动标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>活动描述</label>
            <textarea v-model="form.description" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label>活动地点</label>
            <input v-model="form.location" required />
          </div>
          <div class="form-group">
            <label>活动日期</label>
            <input
              v-model="form.date"
              type="text"
              required
              placeholder="例如：2025-02-01 至 2025-02-02"
            />
          </div>
          <div class="form-group">
            <label>活动图片</label>
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
  name: "FestivalActivityManagement",
  data() {
    return {
      activities: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        title: "",
        description: "",
        location: "",
        date: "",
        organizerId: 1,
        image: "",
      },
      imagePreview: null,
      uploading: false,
    };
  },
  mounted() {
    this.loadActivities();
  },
  methods: {
    async loadActivities() {
      try {
        const response = await fetch("http://localhost:8082/api/festival-activity");
        const allActivities = await response.json();
        this.totalPages = Math.ceil(allActivities.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        this.activities = allActivities.slice(start, start + this.pageSize);
      } catch (error) {
        console.error("加载节庆雅集失败", error);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        title: "",
        description: "",
        location: "",
        date: "",
        organizerId: 1,
        image: "",
      };
      this.imagePreview = null;
      this.showDialog = true;
    },
    editActivity(activity) {
      this.isEdit = true;
      this.form = { ...activity };
      this.imagePreview = activity.image || null;
      this.showDialog = true;
    },
    async saveActivity() {
      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/festival-activity/${this.form.id}`
          : "http://localhost:8082/api/festival-activity";

        await fetch(url, {
          method: this.isEdit ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        this.closeDialog();
        this.loadActivities();
      } catch (error) {
        console.error("保存节庆雅集失败", error);
      }
    },
    async deleteActivity(id) {
      if (confirm("确定要删除这个节庆雅集吗？")) {
        try {
          await fetch(`http://localhost:8082/api/festival-activity/${id}`, {
            method: "DELETE",
          });
          this.loadActivities();
        } catch (error) {
          console.error("删除节庆雅集失败", error);
        }
      }
    },
    closeDialog() {
      this.showDialog = false;
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
        this.loadActivities();
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.loadActivities();
      }
    },
    formatDateTime(datetime) {
      return new Date(datetime).toLocaleString("zh-CN");
    },
    formatDateTimeForInput(datetime) {
      const date = new Date(datetime);
      return date.toISOString().slice(0, 16);
    },
    formatDateRange(startTime, endTime) {
      try {
        const start = new Date(startTime);
        const end = new Date(endTime);
        if (isNaN(start.getTime()) || isNaN(end.getTime())) {
          return "-";
        }
        const startStr = start.toLocaleDateString("zh-CN");
        const endStr = end.toLocaleDateString("zh-CN");
        return startStr === endStr ? startStr : `${startStr} 至 ${endStr}`;
      } catch (error) {
        return "-";
      }
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
        formData.append("type", "festival_gathering");
        if (this.form.id) {
          formData.append("id", this.form.id);
        }

        const response = await fetch("http://localhost:8082/api/upload/image", {
          method: "POST",
          body: formData,
        });

        const result = await response.json();

        if (result.success) {
          this.form.image = result.url;
          this.imagePreview = `http://localhost:8082${result.url}`;
        } else {
          alert(result.message || "上传失败");
        }
      } catch (error) {
        console.error("上传失败", error);
        alert("上传失败,请重试");
      } finally {
        this.uploading = false;
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
