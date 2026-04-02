<template>
  <div class="management-container">
    <div class="header">
      <h2>店铺管理</h2>
      <button @click="showAddDialog" class="btn-primary">添加店铺</button>
    </div>

    <div v-if="shops.length === 0" class="empty-state">
      <p>暂无店铺信息，点击上方按钮添加店铺</p>
    </div>

    <div v-else class="shop-list">
      <div v-for="shop in shops" :key="shop.id" class="shop-card">
        <h3>{{ shop.name }}</h3>
        <p class="shop-desc">{{ shop.description }}</p>
        <div class="shop-info">
          <span>📍 {{ shop.address }}</span>
          <span>📞 {{ shop.contact }}</span>
          <span>⭐ {{ shop.averageRating || 0 }} ({{ shop.reviewCount || 0 }}条评价)</span>
        </div>
        <div class="shop-actions">
          <button @click="editShop(shop)" class="btn-edit">编辑</button>
          <button @click="deleteShop(shop.id)" class="btn-delete">删除</button>
        </div>
      </div>
    </div>

    <!-- 添加/编辑对话框 -->
    <div v-if="showDialog" class="modal" @click.self="closeDialog">
      <div class="modal-content">
        <h3>{{ isEdit ? "编辑店铺" : "添加店铺" }}</h3>
        <form @submit.prevent="saveShop">
          <div class="form-group">
            <label>店铺名称</label>
            <input v-model="form.name" required />
          </div>
          <div class="form-group">
            <label>店铺描述</label>
            <textarea v-model="form.description" rows="3"></textarea>
          </div>
          <div class="form-group">
            <label>店铺地址</label>
            <input v-model="form.address" />
          </div>
          <div class="form-group">
            <label>联系方式</label>
            <input v-model="form.contact" />
          </div>
          <div class="form-group">
            <label>价格区间</label>
            <select v-model="form.priceRange">
              <option value="普通档（0-400）">普通档（0-400）</option>
              <option value="中档（400-700）">中档（400-700）</option>
              <option value="中高档（700-1000）">中高档（700-1000）</option>
              <option value="高档（1000以上）">高档（1000以上）</option>
            </select>
          </div>
          <div class="form-group">
            <label>店铺图片</label>
            <div class="upload-area">
              <input
                type="file"
                ref="imageInput"
                @change="handleImageChange"
                accept="image/*"
                style="display: none"
              />
              <div
                v-if="!imagePreview"
                class="upload-placeholder"
                @click="$refs.imageInput.click()"
              >
                <span>点击上传店铺图片</span>
              </div>
              <div v-else class="image-preview">
                <img :src="imagePreview" alt="店铺图片" />
                <button type="button" @click="removeImage" class="btn-remove-img">删除</button>
              </div>
            </div>
            <small v-if="uploading" style="color: #666">上传中...</small>
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
  name: "ShopManagement",
  data() {
    return {
      shops: [],
      showDialog: false,
      isEdit: false,
      form: {
        id: null,
        name: "",
        description: "",
        address: "",
        contact: "",
        priceRange: "普通档（0-400）",
        image: "",
      },
      imagePreview: null,
      uploading: false,
    };
  },
  mounted() {
    this.loadShops();
  },
  methods: {
    loadShops() {
      const API_BASE = "http://localhost:8080/api";
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      if (!user.id) return;

      fetch(`${API_BASE}/shops?userId=${user.id}`)
        .then((response) => response.json())
        .then((data) => {
          this.shops = data;
        })
        .catch((error) => {
          console.error("加载店铺失败:", error);
        });
    },
    showAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        name: "",
        description: "",
        address: "",
        contact: "",
        priceRange: "普通档（0-400）",
        image: "",
      };
      this.imagePreview = null;
      this.showDialog = true;
    },
    editShop(shop) {
      this.isEdit = true;
      this.form = {
        ...shop,
        priceRange: shop.priceRange || shop.price_range || "普通档（0-400）",
      };
      this.imagePreview = shop.image || null;
      this.showDialog = true;
    },
    closeDialog() {
      this.showDialog = false;
    },
    handleImageChange(e) {
      const file = e.target.files[0];
      if (file) {
        this.uploading = true;
        const formData = new FormData();
        formData.append("file", file);

        fetch("http://localhost:8080/api/upload", {
          method: "POST",
          body: formData,
        })
          .then((response) => response.json())
          .then((data) => {
            this.form.image = data.url;
            this.imagePreview = data.url;
            this.uploading = false;
          })
          .catch((error) => {
            console.error("上传图片失败:", error);
            this.uploading = false;
          });
      }
    },
    removeImage() {
      this.form.image = "";
      this.imagePreview = null;
    },
    saveShop() {
      const API_BASE = "http://localhost:8080/api";
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      if (!user.id) return;

      const url = this.isEdit ? `${API_BASE}/shops/${this.form.id}` : `${API_BASE}/shops`;
      const method = this.isEdit ? "PUT" : "POST";

      const data = {
        ...this.form,
        price_range: this.form.priceRange,
        userId: user.id,
      };

      fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
      })
        .then((response) => response.json())
        .then(() => {
          this.showDialog = false;
          this.loadShops();
        })
        .catch((error) => {
          console.error("保存店铺失败:", error);
        });
    },
    deleteShop(shopId) {
      if (confirm("确定要删除这个店铺吗？")) {
        const API_BASE = "http://localhost:8080/api";

        fetch(`${API_BASE}/shops/${shopId}`, {
          method: "DELETE",
        })
          .then(() => {
            this.loadShops();
          })
          .catch((error) => {
            console.error("删除店铺失败:", error);
          });
      }
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

.btn-primary {
  background: #8b4513;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary:hover {
  background: #6b340e;
}

.empty-state {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.shop-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.shop-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.shop-card h3 {
  margin: 0 0 10px 0;
  color: #8b4513;
}

.shop-desc {
  margin: 0 0 15px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.4;
}

.shop-info {
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.shop-info span {
  display: block;
  margin-bottom: 5px;
}

.shop-actions {
  display: flex;
  gap: 10px;
}

.btn-edit,
.btn-delete {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-edit {
  background: #4caf50;
  color: white;
}

.btn-delete {
  background: #f44336;
  color: white;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  padding: 30px;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
}

.modal-content h3 {
  margin: 0 0 20px 0;
  color: #8b4513;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
}

.upload-area {
  border: 1px dashed #ddd;
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
  max-width: 100%;
  max-height: 200px;
  border-radius: 4px;
}

.btn-remove-img {
  position: absolute;
  top: -10px;
  right: -10px;
  background: #f44336;
  color: white;
  border: none;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  cursor: pointer;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.btn-cancel {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: white;
  cursor: pointer;
}

.btn-cancel:hover {
  background: #f5f5f5;
}
</style>
