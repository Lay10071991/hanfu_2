<template>
  <div class="management-container">
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
            <label>排序</label>
            <input v-model.number="form.sortOrder" type="number" min="1" />
          </div>
          <div class="form-group">
            <label>主图片</label>
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
        sortOrder: 1,
        image: "",
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
          this.items = await response.json();
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
        sortOrder: 1,
        image: "",
      };
      this.imagePreview = null;
      this.showDialog = true;
    },
    editItem(item) {
      this.isEdit = true;
      this.form = { ...item };
      this.imagePreview = item.image || null;
      this.showDialog = true;
    },
    closeDialog() {
      this.showDialog = false;
      this.imagePreview = null;
    },
    async saveItem() {
      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/hanfu-display/${this.form.id}`
          : "http://localhost:8082/api/hanfu-display";
        const method = this.isEdit ? "PUT" : "POST";

        const response = await fetch(url, {
          method,
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(this.form),
        });

        if (response.ok) {
          alert(this.isEdit ? "更新成功" : "添加成功");
          this.closeDialog();
          this.loadItems();
        } else {
          alert("保存失败");
        }
      } catch (error) {
        console.error("保存衣冠数据失败:", error);
        alert("保存失败");
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
        this.uploadImage(file);
      }
    },
    async uploadImage(file) {
      this.uploading = true;
      const formData = new FormData();
      formData.append("file", file);

      try {
        const response = await fetch("http://localhost:8082/api/upload", {
          method: "POST",
          body: formData,
        });

        if (response.ok) {
          const data = await response.json();
          this.form.image = data.url;
          this.imagePreview = data.url;
        }
      } catch (error) {
        console.error("上传图片失败:", error);
        alert("上传图片失败");
      } finally {
        this.uploading = false;
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
.management-container {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.header h2 {
  margin: 0;
  color: #8b4513;
}

.header-buttons {
  display: flex;
  align-items: center;
  gap: 10px;
}

.btn-refresh {
  padding: 8px 15px;
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
}

.table-container {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

th {
  background: #f5f5f5;
  font-weight: 600;
  color: #8b4513;
}

.btn-edit {
  background: #d4a76a;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 8px;
}

.btn-delete {
  background: #f56c6c;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  padding: 30px;
  border-radius: 8px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 600;
  color: #333;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-group small {
  color: #999;
  font-size: 12px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.btn-cancel {
  background: #909399;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
}

.upload-area {
  border: 2px dashed #ddd;
  border-radius: 4px;
  padding: 20px;
  text-align: center;
  cursor: pointer;
}

.upload-placeholder {
  color: #999;
}

.image-preview {
  position: relative;
  display: inline-block;
}

.image-preview img {
  max-width: 200px;
  max-height: 200px;
  border-radius: 4px;
}

.btn-remove {
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
}
</style>
