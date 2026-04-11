<template>
  <div class="management-container hanfu-display">
    <div class="header">
      <h2>千载衣冠管理</h2>
      <div class="header-buttons">
        <button @click="loadItems" class="btn-refresh">刷新</button>
        <button @click="showAddDialog" class="btn-primary">新增衣冠</button>
      </div>
    </div>
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>名称</th>
            <th>描述</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.description ? item.description.substring(0, 30) + "..." : "-" }}</td>
            <td>
              <button @click="editItem(item)" class="btn-edit">编辑</button>
              <button @click="deleteItem(item.id)" class="btn-delete">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? "编辑衣冠" : "新增衣冠" }}</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>描述</label>
            <textarea v-model="form.description" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label>详细内容</label>
            <textarea v-model="form.content" rows="4" placeholder="请输入详细内容"></textarea>
          </div>

          <div class="form-group">
            <label>更多图片</label>
            <div class="upload-area">
              <input
                type="file"
                ref="filesInput"
                @change="handleFilesChange"
                accept="image/*"
                multiple
                style="display: none"
              />
              <div class="upload-placeholder" @click="$refs.filesInput.click()">
                <span>点击上传多张图片</span>
              </div>
            </div>
            <div v-if="form.images && form.images.length > 0" class="images-preview">
              <div v-for="(img, index) in form.images" :key="index" class="image-item">
                <img :src="img.preview || getImageUrl(img)" alt="预览图" />
                <button type="button" @click="removeImageByIndex(index)" class="btn-remove">
                  删除
                </button>
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
import { getImageUrl } from "../../../utils/imageHelper";
export default {
  name: "HanfuDisplayManagement",
  data() {
    return {
      items: [],
      showDialog: false,
      isEdit: false,
      uploading: false,
      imagePreview: null,
      form: {
        id: null,
        name: "",
        description: "",
        content: "",
        images: [],
      },
    };
  },
  mounted() {
    this.loadItems();
  },
  methods: {
    async loadItems() {
      try {
        const response = await fetch("http://localhost:8082/api/hanfu-display");
        if (response.ok) {
          const items = await response.json();
          // 加载每个衣冠的图片
          for (const item of items) {
            try {
              const imagesResponse = await fetch(
                `http://localhost:8082/api/hanfu-display/${item.id}/images`,
              );
              if (imagesResponse.ok) {
                const images = await imagesResponse.json();
                item.images = images.map((img) => img.imagePath);
              }
            } catch (error) {
              console.error(`加载衣冠 ${item.id} 的图片失败:`, error);
              item.images = [];
            }
          }
          this.items = items;
        } else {
          const errorText = await response.text();
          console.error("加载衣冠数据失败:", response.status, response.statusText, errorText);
          alert("加载数据失败: " + response.status + " " + response.statusText);
        }
      } catch (error) {
        console.error("加载衣冠数据失败:", error);
        alert("加载数据失败: " + error.message);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        name: "",
        description: "",
        content: "",
        images: [],
      };
      this.showDialog = true;
      // 阻止背景滚动
      document.body.style.overflow = "hidden";
    },
    editItem(item) {
      this.isEdit = true;
      this.form = { ...item };
      // 确保images数组存在
      if (!this.form.images) {
        this.form.images = [];
      }
      // 处理多张图片
      if (this.form.images && Array.isArray(this.form.images)) {
        this.form.images = this.form.images.map((img) => {
          if (typeof img === "string") {
            return {
              url: img,
              preview: getImageUrl(img),
            };
          }
          return img;
        });
      }
      // 处理主图片
      if (this.form.image) {
        this.imagePreview = getImageUrl(this.form.image);
      } else {
        this.imagePreview = null;
      }
      this.showDialog = true;
      // 阻止背景滚动
      document.body.style.overflow = "hidden";
    },
    closeDialog() {
      this.showDialog = false;
      // 清空图片数组
      if (this.form) {
        this.form.images = [];
      }
      // 恢复背景滚动
      document.body.style.overflow = "auto";
    },
    async saveItem() {
      try {
        this.uploading = true;

        // 准备保存的数据
        const saveData = { ...this.form };

        // 移除文件对象，只保留URL
        if (saveData.images && Array.isArray(saveData.images)) {
          saveData.images = saveData.images.map((img) => {
            if (typeof img === "object" && img.url) {
              return img.url;
            }
            return img;
          });
        }
        delete saveData.imageFile;

        const url = this.isEdit
          ? `http://localhost:8082/api/hanfu-display/${this.form.id}`
          : "http://localhost:8082/api/hanfu-display";
        const method = this.isEdit ? "PUT" : "POST";

        const response = await fetch(url, {
          method,
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(saveData),
        });

        if (response.ok) {
          const savedItem = await response.json();
          const imagePaths = [];

          // 上传主图片
          if (this.form.imageFile) {
            try {
              const imageUrl = await this.uploadImage(
                this.form.imageFile,
                "clothing_show",
                savedItem.id,
              );
              saveData.image = imageUrl;
              // 更新主图片
              await fetch(`http://localhost:8082/api/hanfu-display/${savedItem.id}`, {
                method: "PUT",
                headers: {
                  "Content-Type": "application/json",
                },
                body: JSON.stringify({ image: imageUrl }),
              });
            } catch (error) {
              console.error("上传主图片失败:", error);
              alert("上传主图片失败");
              return;
            }
          }

          // 上传多张图片
          if (this.form.images && this.form.images.length > 0) {
            try {
              for (let i = 0; i < this.form.images.length; i++) {
                const img = this.form.images[i];
                if (img.file) {
                  const imageUrl = await this.uploadImage(
                    img.file,
                    "clothing_show",
                    savedItem.id,
                    i + 1,
                  );
                  imagePaths.push(imageUrl);
                } else if (img.url) {
                  imagePaths.push(img.url);
                }
              }

              if (imagePaths.length > 0) {
                const imagesResponse = await fetch(
                  `http://localhost:8082/api/hanfu-display/${savedItem.id}/images`,
                  {
                    method: "POST",
                    headers: {
                      "Content-Type": "application/json",
                    },
                    body: JSON.stringify(imagePaths),
                  },
                );
                if (!imagesResponse.ok) {
                  console.error("保存图片失败");
                  alert("保存图片失败");
                  return;
                }
              }
            } catch (error) {
              console.error("保存图片失败:", error);
              alert("保存图片失败");
              return;
            }
          }

          alert(this.isEdit ? "更新成功" : "添加成功");
          this.closeDialog();
          this.loadItems();
        } else {
          alert("保存失败");
        }
      } catch (error) {
        console.error("保存衣冠数据失败:", error);
        alert("保存失败");
      } finally {
        this.uploading = false;
      }
    },
    async deleteItem(id) {
      if (!confirm("确定要删除这个衣冠吗？")) return;

      try {
        const response = await fetch(`http://localhost:8082/api/hanfu-display/${id}`, {
          method: "DELETE",
        });

        if (response.ok) {
          alert("删除成功");
          this.loadItems();
        } else {
          alert("删除失败");
        }
      } catch (error) {
        console.error("删除衣冠数据失败:", error);
        alert("删除失败");
      }
    },
    handleFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        this.previewImage(file, event.target, false);
      }
    },
    handleFilesChange(event) {
      const files = event.target.files;
      if (files && files.length > 0) {
        Array.from(files).forEach((file, index) => {
          this.previewImage(file, event.target, true, index);
        });
      }
    },
    previewImage(file, fileInput, isMultiple = false, index = 0) {
      // 创建预览
      const reader = new FileReader();
      reader.onload = (e) => {
        if (isMultiple) {
          // 处理多张图片
          this.form.images.push({
            file: file,
            preview: e.target.result,
          });
        } else {
          // 处理主图片
          this.form.imageFile = file;
          this.imagePreview = e.target.result;
        }
      };
      reader.readAsDataURL(file);

      // 清空文件输入框，确保可以选择相同的图片
      if (fileInput) {
        fileInput.value = "";
      }
    },
    async uploadImage(file, type, id, index = null) {
      const formData = new FormData();
      formData.append("file", file);
      formData.append("type", type);
      if (id) {
        formData.append("id", id);
        if (index !== null) {
          formData.append("index", index);
        }
      }

      try {
        const response = await fetch("http://localhost:8082/api/upload/image", {
          method: "POST",
          body: formData,
        });

        if (response.ok) {
          const data = await response.json();
          if (data.success) {
            return data.url;
          } else {
            throw new Error(data.message || "上传失败");
          }
        } else {
          throw new Error("上传失败");
        }
      } catch (error) {
        console.error("上传图片失败:", error);
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
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = "";
      }
    },
    async removeImageByIndex(index) {
      const img = this.form.images[index];
      if (img && (img.url || img)) {
        const url = img.url || img;
        try {
          const response = await fetch("http://localhost:8082/api/upload/image", {
            method: "DELETE",
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: `url=${encodeURIComponent(url)}`,
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

      // 从数组中移除图片
      this.form.images.splice(index, 1);
    },
  },
};
</script>

<style scoped>
@import "./management-common.css";

/* 修复表格横线不正确问题 */
.hanfu-display table {
  border-collapse: collapse;
  width: 100%;
}

.hanfu-display th,
.hanfu-display td {
  border-bottom: 1px solid #eee;
  vertical-align: top;
  padding: 12px 15px;
}

.hanfu-display tr:hover {
  background: #f9f9f9;
}

/* 调整操作列布局，确保横线正确显示 */
.hanfu-display td:last-child {
  text-align: right;
  padding-right: 20px;
}

.hanfu-display td:last-child button {
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

/* 多张图片预览样式 */
.images-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-top: 15px;
}

.image-item {
  position: relative;
  display: inline-block;
}

.image-item img {
  max-width: 120px;
  max-height: 120px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.image-item .btn-remove {
  position: absolute;
  top: -10px;
  right: -10px;
  background: #f56c6c;
  color: white;
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  transition: all 0.3s ease;
}

.image-item .btn-remove:hover {
  background: #f78989;
  transform: scale(1.1);
}
</style>
