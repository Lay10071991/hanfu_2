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
        <div class="modal-header">
          <h3>{{ isEdit ? "编辑节庆雅集" : "新增节庆雅集" }}</h3>
          <button class="close-btn" @click="closeDialog">×</button>
        </div>
        <div class="modal-body">
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
              <label>状态</label>
              <select v-model="form.status">
                <option value="upcoming">即将开始</option>
                <option value="ongoing">进行中</option>
                <option value="completed">已完成</option>
                <option value="cancelled">已取消</option>
              </select>
            </div>
            <div class="form-group">
              <label>最大参与人数</label>
              <input v-model.number="form.maxParticipants" type="number" />
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
                <div
                  v-if="!imagePreview"
                  class="upload-placeholder"
                  @click="$refs.fileInput.click()"
                >
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
              <button type="submit" class="btn-save">保存</button>
            </div>
          </form>
        </div>
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
        status: "upcoming",
        maxParticipants: 100,
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
        status: "upcoming",
        maxParticipants: 100,
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
    handleFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        this.uploading = true;
        const formData = new FormData();
        formData.append("file", file);

        fetch("http://localhost:8082/api/upload", {
          method: "POST",
          body: formData,
        })
          .then((response) => response.json())
          .then((data) => {
            this.form.image = data.filePath;
            this.imagePreview = data.filePath.replace(
              "backend/uploads/",
              "http://localhost:8082/uploads/",
            );
            this.uploading = false;
          })
          .catch((error) => {
            console.error("上传图片失败", error);
            this.uploading = false;
          });
      }
    },
    removeImage() {
      this.form.image = "";
      this.imagePreview = null;
    },
  },
};
</script>

<style scoped>
@import "./management-common.css";

.upload-area {
  margin-top: 8px;
}

.upload-placeholder {
  border: 2px dashed #ccc;
  border-radius: 4px;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  background-color: #f9f9f9;
  transition: all 0.3s ease;
}

.upload-placeholder:hover {
  border-color: #4caf50;
  background-color: #f0f8f0;
}

.image-preview {
  position: relative;
  display: inline-block;
  margin-top: 8px;
}

.image-preview img {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 4px;
}

.btn-remove {
  position: absolute;
  top: -10px;
  right: -10px;
  background-color: #f44336;
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
}

.btn-remove:hover {
  background-color: #d32f2f;
}
</style>
