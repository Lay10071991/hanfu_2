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
              placeholder="例如：2025-02-01"
              @click="showDatePicker = true"
            />
            <!-- 自定义日期选择器 -->
            <div v-if="showDatePicker" class="date-picker-overlay" @click="showDatePicker = false">
              <div class="date-picker-content" @click.stop>
                <div class="date-picker-header">
                  <button @click="prevMonth" class="date-nav-btn">←</button>
                  <h3>{{ currentYear }}年{{ currentMonth + 1 }}月</h3>
                  <button @click="nextMonth" class="date-nav-btn">→</button>
                </div>
                <div class="date-picker-body">
                  <div class="date-weekdays">
                    <div v-for="day in weekdays" :key="day" class="weekday">{{ day }}</div>
                  </div>
                  <div class="date-days">
                    <div
                      v-for="day in days"
                      :key="day.date"
                      class="date-day"
                      :class="{
                        'date-day-selected': isSelected(day.date),
                        'date-day-other': day.isOtherMonth,
                      }"
                      @click="selectDate(day.date)"
                    >
                      {{ day.day }}
                    </div>
                  </div>
                </div>
                <div class="date-picker-footer">
                  <button @click="showDatePicker = false" class="date-btn">取消</button>
                  <button @click="confirmDate" class="date-btn date-btn-primary">确定</button>
                </div>
              </div>
            </div>
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
import { getImageUrl } from "../../../utils/imageHelper";
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
      // 日期选择器相关数据
      showDatePicker: false,
      currentYear: new Date().getFullYear(),
      currentMonth: new Date().getMonth(),
      selectedDate: null,
      weekdays: ["日", "一", "二", "三", "四", "五", "六"],
      days: [],
    };
  },
  mounted() {
    this.loadActivities();
    this.generateCalendar();
  },
  watch: {
    currentYear() {
      this.generateCalendar();
    },
    currentMonth() {
      this.generateCalendar();
    },
  },
  methods: {
    generateCalendar() {
      const firstDay = new Date(this.currentYear, this.currentMonth, 1);
      const lastDay = new Date(this.currentYear, this.currentMonth + 1, 0);
      const startDate = new Date(firstDay);
      startDate.setDate(startDate.getDate() - firstDay.getDay());

      const days = [];
      for (let i = 0; i < 42; i++) {
        const currentDate = new Date(startDate);
        currentDate.setDate(startDate.getDate() + i);
        days.push({
          date: currentDate,
          day: currentDate.getDate(),
          isOtherMonth: currentDate.getMonth() !== this.currentMonth,
        });
      }
      this.days = days;
    },
    prevMonth() {
      if (this.currentMonth === 0) {
        this.currentYear--;
        this.currentMonth = 11;
      } else {
        this.currentMonth--;
      }
    },
    nextMonth() {
      if (this.currentMonth === 11) {
        this.currentYear++;
        this.currentMonth = 0;
      } else {
        this.currentMonth++;
      }
    },
    selectDate(date) {
      this.selectedDate = new Date(date);
    },
    isSelected(date) {
      if (!this.selectedDate) return false;
      const selected = new Date(this.selectedDate);
      const current = new Date(date);
      return (
        selected.getFullYear() === current.getFullYear() &&
        selected.getMonth() === current.getMonth() &&
        selected.getDate() === current.getDate()
      );
    },
    confirmDate() {
      if (this.selectedDate) {
        const year = this.selectedDate.getFullYear();
        const month = String(this.selectedDate.getMonth() + 1).padStart(2, "0");
        const day = String(this.selectedDate.getDate()).padStart(2, "0");
        this.form.date = `${year}年${month}月${day}日`;
        this.showDatePicker = false;
      }
    },
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
      // 解析日期，设置选中日期
      if (activity.date) {
        const match = activity.date.match(/(\d{4})年(\d{2})月(\d{2})日/);
        if (match) {
          this.selectedDate = new Date(`${match[1]}-${match[2]}-${match[3]}`);
          this.currentYear = this.selectedDate.getFullYear();
          this.currentMonth = this.selectedDate.getMonth();
          this.generateCalendar();
        }
      }
      this.imagePreview = activity.image ? getImageUrl(activity.image) : null;
      this.showDialog = true;
    },
    async saveActivity() {
      try {
        this.uploading = true;

        // 准备保存的数据
        const saveData = { ...this.form };
        delete saveData.imageFile;

        const url = this.isEdit
          ? `http://localhost:8082/api/festival-activity/${this.form.id}`
          : "http://localhost:8082/api/festival-activity";

        const response = await fetch(url, {
          method: this.isEdit ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(saveData),
        });

        if (response.ok) {
          const savedItem = await response.json();
          const itemId = this.isEdit ? this.form.id : savedItem.id;

          // 上传图片
          if (this.form.imageFile) {
            try {
              const imageUrl = await this.uploadImage(
                this.form.imageFile,
                "festival_gathering",
                itemId,
              );
              // 更新图片
              await fetch(`http://localhost:8082/api/festival-activity/${itemId}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ image: imageUrl }),
              });
            } catch (error) {
              console.error("上传图片失败:", error);
              alert("上传图片失败");
              return;
            }
          }

          this.closeDialog();
          this.loadActivities();
        } else {
          alert("保存失败");
        }
      } catch (error) {
        console.error("保存节庆雅集失败", error);
        alert("保存失败");
      } finally {
        this.uploading = false;
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
      this.showDatePicker = false;
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
      if (!file) return;

      if (!file.type.startsWith("image/")) {
        alert("请选择图片文件");
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        alert("图片大小不能超过5MB");
        return;
      }

      this.previewImage(file, event.target);
    },
    previewImage(file, fileInput) {
      // 创建预览
      const reader = new FileReader();
      reader.onload = (e) => {
        this.form.imageFile = file;
        this.imagePreview = e.target.result;
      };
      reader.readAsDataURL(file);

      // 清空文件输入框，确保可以选择相同的图片
      if (fileInput) {
        fileInput.value = "";
      }
    },
    async uploadImage(file, type, id) {
      const formData = new FormData();
      formData.append("file", file);
      formData.append("type", type);
      if (id) {
        formData.append("id", id);
      }

      try {
        const response = await fetch("http://localhost:8082/api/upload/image", {
          method: "POST",
          body: formData,
        });

        const result = await response.json();

        if (result.success) {
          return result.url;
        } else {
          throw new Error(result.message || "上传失败");
        }
      } catch (error) {
        console.error("上传失败", error);
        throw error;
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

/* 日期选择器样式 */
.date-picker-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.date-picker-content {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  width: 300px;
  overflow: hidden;
}

.date-picker-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px;
  background-color: #f5f5f5;
  border-bottom: 1px solid #e0e0e0;
}

.date-nav-btn {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.date-nav-btn:hover {
  background-color: rgba(0, 0, 0, 0.1);
}

.date-picker-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.date-picker-body {
  padding: 16px;
}

.date-weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 8px;
  margin-bottom: 16px;
}

.weekday {
  text-align: center;
  font-size: 14px;
  font-weight: 600;
  color: #666;
}

.date-days {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 8px;
}

.date-day {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 14px;
}

.date-day:hover {
  background-color: #f0f0f0;
}

.date-day-selected {
  background-color: #d2691e;
  color: white;
}

.date-day-other {
  color: #ccc;
}

.date-picker-footer {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  padding: 16px;
  border-top: 1px solid #e0e0e0;
  background-color: #f5f5f5;
}

.date-btn {
  padding: 8px 16px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  background-color: white;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 14px;
}

.date-btn:hover {
  border-color: #d2691e;
  color: #d2691e;
}

.date-btn-primary {
  background-color: #d2691e;
  color: white;
  border-color: #d2691e;
}

.date-btn-primary:hover {
  background-color: #b85a1a;
  border-color: #b85a1a;
  color: white;
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
