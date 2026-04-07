<template>
  <div class="management-container">
    <div class="header">
      <h2>店铺管理</h2>
      <div class="header-buttons">
        <button @click="loadShops" class="btn-refresh">刷新</button>
      </div>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>序号</th>
            <th>店铺名称</th>
            <th>地址</th>
            <th>联系方式</th>
            <th>平均评分</th>
            <th>评价数</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(shop, index) in shops" :key="shop.id">
            <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
            <td>{{ shop.name }}</td>
            <td>{{ shop.address }}</td>
            <td>{{ shop.contact }}</td>
            <td>{{ shop.averageRating || 0 }}</td>
            <td>{{ shop.reviewCount || 0 }}</td>
            <td>
              <button @click="deleteShop(shop.id)" class="btn-delete">删除</button>
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
  </div>
</template>

<script>
export default {
  name: "ShopManagement",
  data() {
    return {
      shops: [],
      currentPage: 1,
      pageSize: 10,
      totalPages: 1,
    };
  },
  mounted() {
    this.loadShops();
  },
  methods: {
    async loadShops() {
      try {
        const response = await fetch("http://localhost:8082/api/shops");
        const allShops = await response.json();
        this.totalPages = Math.ceil(allShops.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        this.shops = allShops.slice(start, start + this.pageSize);
      } catch (error) {
        console.error("加载店铺失败", error);
      }
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        name: "",
        description: "",
        image: "",
        address: "",
        contact: "",
      };
      this.imagePreview = null;
      this.showDialog = true;
    },
    editShop(shop) {
      this.isEdit = true;
      this.form = { ...shop };
      // 处理图片预览URL
      if (shop.image) {
        if (shop.image.startsWith("http://") || shop.image.startsWith("https://")) {
          this.imagePreview = shop.image;
        } else {
          this.imagePreview = `http://localhost:8082${shop.image}`;
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
        alert("上传失败，请重试");
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
    async saveShop() {
      if (!this.form.image) {
        alert("请上传店铺图片");
        return;
      }

      try {
        const url = this.isEdit
          ? `http://localhost:8082/api/shops/${this.form.id}`
          : "http://localhost:8082/api/shops";

        await fetch(url, {
          method: this.isEdit ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        alert(this.isEdit ? "店铺更新成功" : "店铺添加成功");
        this.closeDialog();
        this.loadShops();
      } catch (error) {
        console.error("保存店铺失败", error);
        alert("保存失败，请重试");
      }
    },
    async deleteShop(id) {
      if (confirm("确定要删除这个店铺吗？")) {
        try {
          await fetch(`http://localhost:8082/api/shops/${id}`, {
            method: "DELETE",
          });
          this.loadShops();
        } catch (error) {
          console.error("删除店铺失败", error);
        }
      }
    },
    closeDialog() {
      this.showDialog = false;
      this.imagePreview = null;
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
        this.loadShops();
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.loadShops();
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
