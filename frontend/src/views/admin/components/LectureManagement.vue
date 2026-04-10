<template>
  <div class="management-container">
    <div class="header">
      <h2>讲座管理</h2>
      <div class="header-buttons">
        <button @click="loadLectures" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增讲座</button>
      </div>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>讲座标题</th>
            <th>地点</th>
            <th>开始时间</th>
            <th>结束时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(lecture, index) in lectures" :key="lecture.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ lecture.title }}</td>
            <td>{{ lecture.location }}</td>
            <td>{{ formatDateTime(lecture.startTime) }}</td>
            <td>{{ formatDateTime(lecture.endTime) }}</td>
            <td>
              <button @click="editLecture(lecture)" class="btn-edit">编辑</button>
              <button @click="deleteLecture(lecture.id)" class="btn-delete">删除</button>
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
        <h3>{{ isEdit ? "编辑讲座" : "新增讲座" }}</h3>
        <form @submit.prevent="saveLecture">
          <div class="form-group">
            <label>讲座标题</label>
            <input v-model="form.title" required />
          </div>
          <div class="form-group">
            <label>讲座描述</label>
            <textarea v-model="form.description" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label>讲座地点</label>
            <input v-model="form.location" required />
          </div>
          <div class="form-group">
            <label>开始时间</label>
            <input v-model="form.startTime" type="datetime-local" required />
          </div>
          <div class="form-group">
            <label>结束时间</label>
            <input v-model="form.endTime" type="datetime-local" required />
          </div>
          <div class="form-group">
            <label>讲座图片</label>
            <div class="upload-area">
              <input
                ref="fileInput"
                type="file"
                accept="image/*"
                style="display: none"
                @change="handleImageUpload"
              />
              <button type="button" class="btn-upload" @click="$refs.fileInput.click()">
                选择图片
              </button>
              <div v-if="imagePreview" class="image-preview">
                <img :src="imagePreview" alt="讲座图片" />
                <button type="button" class="btn-remove" @click="removeImage">移除</button>
              </div>
            </div>
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
  name: "LectureManagement",
  data() {
    return {
      lectures: [],
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
        startTime: "",
        endTime: "",
        image: "",
      },
      imagePreview: null,
    };
  },
  mounted() {
    this.loadLectures();
  },
  methods: {
    async loadLectures() {
      try {
        const response = await fetch("http://localhost:8082/api/lectures");
        const allLectures = await response.json();
        this.totalPages = Math.ceil(allLectures.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        this.lectures = allLectures.slice(start, start + this.pageSize);
      } catch (error) {
        console.error("加载讲座失败", error);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        title: "",
        description: "",
        location: "",
        startTime: "",
        endTime: "",
        image: "",
      };
      this.imagePreview = null;
      this.showDialog = true;
    },
    editLecture(lecture) {
      this.isEdit = true;
      this.form = {
        ...lecture,
        startTime: this.formatDateTimeForInput(lecture.startTime),
        endTime: this.formatDateTimeForInput(lecture.endTime),
      };
      this.imagePreview = lecture.image || null;
      this.showDialog = true;
    },
    async saveLecture() {
      try {
        // 先保存基本信息
        const url = this.isEdit
          ? `http://localhost:8082/api/lectures/${this.form.id}`
          : "http://localhost:8082/api/lectures";

        const response = await fetch(url, {
          method: this.isEdit ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        if (response.ok) {
          // 如果是新增，获取返回的ID
          if (!this.isEdit) {
            const newLecture = await response.json();
            this.form.id = newLecture.id;

            // 如果有图片，重新上传（使用新ID）
            if (this.imagePreview && this.imagePreview.startsWith("data:")) {
              // 触发重新上传
              const fileInput = this.$refs.fileInput;
              if (fileInput && fileInput.files && fileInput.files[0]) {
                await this.handleImageUpload({ target: { files: [fileInput.files[0]] } });

                // 更新讲座信息（包含图片路径）
                await fetch(`http://localhost:8082/api/lectures/${this.form.id}`, {
                  method: "PUT",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify(this.form),
                });
              }
            }
          }

          this.closeDialog();
          this.loadLectures();
        }
      } catch (error) {
        console.error("保存讲座失败", error);
      }
    },
    async deleteLecture(id) {
      if (confirm("确定要删除这个讲座吗？")) {
        try {
          await fetch(`http://localhost:8082/api/lectures/${id}`, {
            method: "DELETE",
          });
          this.loadLectures();
        } catch (error) {
          console.error("删除讲座失败", error);
        }
      }
    },
    closeDialog() {
      this.showDialog = false;
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
        this.loadLectures();
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.loadLectures();
      }
    },
    formatDateTime(datetime) {
      if (!datetime) return "-";
      const date = new Date(datetime);
      if (isNaN(date.getTime())) return "-";
      return date.toLocaleString("zh-CN", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      });
    },
    formatDateTimeForInput(datetime) {
      if (!datetime) return "";
      const date = new Date(datetime);
      if (isNaN(date.getTime())) return "";
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");
      return `${year}-${month}-${day}T${hours}:${minutes}`;
    },
    async handleImageUpload(event) {
      const file = event.target.files[0];
      if (file) {
        // 显示预览
        const reader = new FileReader();
        reader.onload = (e) => {
          this.imagePreview = e.target.result;
        };
        reader.readAsDataURL(file);

        // 上传文件
        try {
          const formData = new FormData();
          formData.append("file", file);
          formData.append("type", "talk");
          if (this.form.id) {
            formData.append("id", this.form.id);
          }

          // 上传到后端
          const response = await fetch("http://localhost:8082/api/upload/image", {
            method: "POST",
            body: formData,
          });

          if (response.ok) {
            const data = await response.json();
            this.form.image = data.url;
          } else {
            console.error("图片上传失败");
          }
        } catch (error) {
          console.error("上传错误:", error);
        }
      }
    },
    removeImage() {
      this.imagePreview = null;
      this.form.image = "";
      this.$refs.fileInput.value = "";
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

/* 图片上传区域样式 */
.upload-area {
  margin-top: 10px;
}

.btn-upload {
  background: #f5f5f5;
  color: #333;
  border: 1px solid #e0e0e0;
  padding: 8px 16px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.btn-upload:hover {
  background: #e0e0e0;
}

.image-preview {
  margin-top: 15px;
  position: relative;
  width: 200px;
  height: 150px;
  border: 2px dashed #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.image-preview img {
  max-width: 100%;
  max-height: 100%;
  object-fit: cover;
}

.btn-remove {
  position: absolute;
  top: 5px;
  right: 5px;
  background: rgba(255, 0, 0, 0.7);
  color: white;
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  font-size: 12px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.btn-remove:hover {
  background: rgba(255, 0, 0, 1);
}
</style>
