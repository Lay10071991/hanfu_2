<template>
  <div class="management-container">
    <div class="header">
      <h2>图案象征管理</h2>
      <button @click="showAddDialog" class="btn-primary">新增图案</button>
    </div>
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>图案名称</th>
            <th>图片</th>
            <th>象征意义</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>
              <img
                v-if="item.image"
                :src="
                  item.image.startsWith('http://') || item.image.startsWith('https://')
                    ? item.image
                    : `http://localhost:8082${item.image}`
                "
                alt="图案图片"
                style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px"
              />
              <span v-else>-</span>
            </td>
            <td>{{ item.meaning }}</td>
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
        <h3>{{ isEdit ? "编辑图案" : "新增图案" }}</h3>
        <form @submit.prevent="saveItem">
          <div class="form-group">
            <label>图案名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>象征意义</label>
            <input v-model="form.meaning" required />
          </div>
          <div class="form-group">
            <label>图案图片</label>
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
            <label>图案描述</label>
            <textarea v-model="form.description" rows="4"></textarea>
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
  name: "PatternManagement",
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
        meaning: "",
        image: "",
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
        const response = await fetch("http://localhost:8082/api/pattern-symbol");
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
        meaning: "",
        image: "",
        description: "",
      };
      this.imagePreview = null;
      this.showDialog = true;
    },
    editItem(item) {
      this.isEdit = true;
      this.form = { ...item };
      // 处理图片预览URL
      if (item.image) {
        // 如果已经是完整URL,直接使用
        if (item.image.startsWith("http://") || item.image.startsWith("https://")) {
          this.imagePreview = item.image;
        } else {
          // 如果是相对路径,添加服务器地址
          this.imagePreview = `http://localhost:8082${item.image}`;
        }
      } else {
        this.imagePreview = null;
      }
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
    removeImage() {
      this.form.image = "";
      this.imagePreview = null;
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = "";
      }
    },
    async saveItem() {
      if (!this.form.image) {
        alert("请上传图案图片");
        return;
      }

      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/pattern-symbol/${this.form.id}`
          : "http://localhost:8082/api/pattern-symbol";

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
      if (confirm("确定要删除这个图案吗？")) {
        try {
          await fetch(`http://localhost:8082/api/pattern-symbol/${id}`, {
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
  },
};
</script>

<style scoped>
@import "./management-common.css";

.upload-area {
  margin-top: 8px;
}

.upload-placeholder {
  border: 2px dashed #ddd;
  border-radius: 8px;
  padding: 40px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
}

.upload-placeholder:hover {
  border-color: #8b4513;
  background: #f9f9f9;
}

.upload-placeholder span {
  color: #666;
  font-size: 14px;
}

.image-preview {
  position: relative;
  display: inline-block;
}

.image-preview img {
  max-width: 300px;
  max-height: 200px;
  border-radius: 8px;
  display: block;
}

.btn-remove {
  position: absolute;
  top: 10px;
  right: 10px;
  padding: 5px 10px;
  background: rgba(220, 53, 69, 0.9);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.btn-remove:hover {
  background: rgba(220, 53, 69, 1);
}

.form-group small {
  display: block;
  margin-top: 5px;
  color: #666;
  font-size: 12px;
}
</style>
