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
        <div class="shop-header">
          <h3>{{ shop.name }}</h3>
          <div class="shop-actions">
            <button @click="editShop(shop)" class="btn-edit">编辑</button>
            <button @click="deleteShop(shop.id)" class="btn-delete">删除</button>
          </div>
        </div>
        <div class="shop-content">
          <div class="shop-image">
            <img :src="shop.image || 'https://via.placeholder.com/150'" alt="店铺图片" />
          </div>
          <div class="shop-details">
            <div class="shop-desc">{{ shop.description }}</div>
            <div class="shop-info">
              <div class="info-item">
                <span class="label">店铺地址：</span>
                <span class="value">{{ shop.address }}</span>
              </div>
              <div class="info-item">
                <span class="label">店铺电话：</span>
                <span class="value">{{ shop.contact }}</span>
              </div>
              <div class="info-item">
                <span class="label">店铺综合评分：</span>
                <span class="value"
                  >{{ shop.averageRating || 0 }} ({{ shop.reviewCount || 0 }}条评价)</span
                >
              </div>
            </div>
          </div>
        </div>
        <!-- 服务管理部分 -->
        <div class="service-management">
          <div class="service-header">
            <h4>服务项目</h4>
            <button @click="showAddServiceDialog(shop.id, shop)" class="btn-add-service">
              添加服务
            </button>
          </div>
          <div class="service-list">
            <div v-if="shop.services.length === 0" class="no-services">
              <p>暂无服务项目</p>
            </div>
            <div v-else v-for="service in shop.services" :key="service.id" class="service-item">
              <span>{{ service.serviceName }}</span>
              <div class="service-actions">
                <button @click="editService(service, shop)" class="btn-edit">编辑</button>
                <button @click="deleteService(service.id, shop)" class="btn-delete">删除</button>
              </div>
            </div>
          </div>
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

    <!-- 服务项目添加/编辑对话框 -->
    <div v-if="showServiceDialog" class="modal" @click.self="closeServiceDialog">
      <div class="modal-content">
        <h3>{{ isServiceEdit ? "编辑服务项目" : "添加服务项目" }}</h3>
        <form @submit.prevent="saveService">
          <div class="form-group">
            <label>服务名称</label>
            <input v-model="serviceForm.serviceName" required />
          </div>
          <div class="form-actions">
            <button type="button" @click="closeServiceDialog" class="btn-cancel">取消</button>
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
      // 服务管理相关状态
      selectedShopId: null,
      currentShop: null,
      showServiceDialog: false,
      isServiceEdit: false,
      serviceForm: {
        id: null,
        serviceName: "",
      },
    };
  },
  mounted() {
    this.loadShops();
  },
  methods: {
    loadShops() {
      const API_BASE = "http://localhost:8082/api";
      const user = JSON.parse(localStorage.getItem("user") || "{}");

      if (!user || !user.id) {
        return;
      }

      fetch(`${API_BASE}/shops?userId=${user.id}`)
        .then((response) => response.json())
        .then((data) => {
          // 为每个店铺添加services属性
          data.forEach((shop) => {
            shop.services = [];
          });
          this.shops = data;
          // 为每个店铺加载服务项目
          this.shops.forEach((shop) => {
            this.loadServices(shop);
          });
        })
        .catch((error) => {
          console.error("加载店铺失败:", error);
        });
    },
    loadServices(shop) {
      if (!shop || !shop.id) {
        return;
      }

      const API_BASE = "http://localhost:8082/api";
      const url = `${API_BASE}/shop-services/shop/${shop.id}`;

      fetch(url)
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          if (Array.isArray(data)) {
            shop.services = data;
          } else {
            shop.services = [];
          }
        })
        .catch((error) => {
          console.error("加载服务项目失败:", error);
          shop.services = [];
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

        fetch("http://localhost:8082/api/upload", {
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
      const API_BASE = "http://localhost:8082/api";
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
        const API_BASE = "http://localhost:8082/api";

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
    // 服务管理相关方法
    loadServices(shop) {
      if (!shop || !shop.id) {
        return;
      }

      // 添加调试信息到shop对象
      shop.serviceDebug = {
        loading: true,
        error: null,
        url: `http://localhost:8082/api/shop-services/shop/${shop.id}`,
        response: null,
      };

      console.log("加载服务项目 for shop:", shop.id, shop.name);
      const API_BASE = "http://localhost:8082/api";
      const url = `${API_BASE}/shop-services/shop/${shop.id}`;
      console.log("服务项目API路径:", url);

      // 手动测试API调用
      fetch(url)
        .then((response) => {
          console.log("服务项目响应状态:", response.status);
          shop.serviceDebug.responseStatus = response.status;
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          console.log("服务项目数据:", data);
          shop.serviceDebug.response = data;
          // 确保数据是数组
          if (Array.isArray(data)) {
            console.log("服务项目数量:", data.length);
            shop.services = data;
          } else {
            console.error("服务项目数据不是数组:", data);
            shop.services = [];
            shop.serviceDebug.error = "服务项目数据不是数组";
          }
        })
        .catch((error) => {
          console.error("加载服务项目失败:", error);
          shop.services = [];
          shop.serviceDebug.error = error.message;
        })
        .finally(() => {
          shop.serviceDebug.loading = false;
          console.log(
            "服务项目加载完成 for shop:",
            shop.id,
            shop.name,
            "服务项目数量:",
            shop.services.length,
          );
        });
    },
    showAddServiceDialog(shopId, shop) {
      this.selectedShopId = shopId;
      this.currentShop = shop;
      this.isServiceEdit = false;
      this.serviceForm = {
        id: null,
        serviceName: "",
      };
      this.showServiceDialog = true;
    },
    editService(service, shop) {
      this.isServiceEdit = true;
      this.serviceForm = { ...service };
      this.selectedShopId = shop.id;
      this.currentShop = shop;
      this.showServiceDialog = true;
    },
    closeServiceDialog() {
      this.showServiceDialog = false;
    },
    saveService() {
      const API_BASE = "http://localhost:8082/api";
      if (!this.selectedShopId || !this.currentShop) return;

      const url = this.isServiceEdit
        ? `${API_BASE}/shop-services/${this.serviceForm.id}`
        : `${API_BASE}/shop-services`;
      const method = this.isServiceEdit ? "PUT" : "POST";

      const data = {
        ...this.serviceForm,
        shopId: this.selectedShopId,
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
          this.showServiceDialog = false;
          this.loadServices(this.currentShop);
        })
        .catch((error) => {
          console.error("保存服务项目失败:", error);
        });
    },
    deleteService(serviceId, shop) {
      if (confirm("确定要删除这个服务项目吗？")) {
        const API_BASE = "http://localhost:8082/api";

        fetch(`${API_BASE}/shop-services/${serviceId}`, {
          method: "DELETE",
        })
          .then(() => {
            this.loadServices(shop);
          })
          .catch((error) => {
            console.error("删除服务项目失败:", error);
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
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #6b340e 0%, #b85a1a 100%);
  transform: translateY(-2px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.empty-state {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.shop-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.shop-card {
  background: white;
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  width: 100%;
}

.shop-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  background: #f9f9f9;
}

.shop-header h3 {
  margin: 0;
  color: #8b4513;
  font-size: 18px;
}

.shop-content {
  padding: 20px;
}

.shop-content {
  display: flex;
  gap: 20px;
}

.shop-image {
  flex: 0 0 150px;
  height: 150px;
  overflow: hidden;
  border-radius: 4px;
}

.shop-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.shop-details {
  flex: 1;
}

.shop-desc {
  margin: 0 0 15px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.4;
  min-height: 60px;
}

.shop-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.info-item {
  display: flex;
  align-items: center;
  font-size: 14px;
}

.info-item .label {
  font-weight: bold;
  color: #333;
  margin-right: 8px;
  min-width: 100px;
}

.info-item .value {
  color: #666;
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
  font-size: 14px;
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
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-group textarea {
  resize: vertical;
}

.image-preview {
  margin-top: 10px;
  max-width: 200px;
}

.image-preview img {
  width: 100%;
  border-radius: 4px;
}

.upload-btn {
  padding: 8px 16px;
  background: #f5f5f5;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
}

.upload-btn:hover {
  background: #e8e8e8;
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
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.btn-save {
  padding: 8px 16px;
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.empty-state {
  text-align: center;
  padding: 40px;
  color: #999;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* 服务管理样式 */
.service-management {
  border-top: 1px solid #eee;
  padding: 20px;
  margin-top: 20px;
}

.service-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.service-header h4 {
  margin: 0;
  color: #8b4513;
  font-size: 16px;
}

.btn-add-service {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.btn-add-service:hover {
  background: linear-gradient(135deg, #6b340e 0%, #b85a1a 100%);
  transform: translateY(-2px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.service-list {
  background: #f9f9f9;
  border-radius: 4px;
  padding: 15px;
}

.no-services {
  text-align: center;
  color: #666;
  padding: 20px;
}

.service-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  background: white;
  border-radius: 4px;
  margin-bottom: 10px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.service-item span {
  color: #333;
  font-size: 14px;
}

.service-actions {
  display: flex;
  gap: 8px;
}

.service-actions .btn-edit,
.service-actions .btn-delete {
  padding: 4px 8px;
  font-size: 12px;
}
</style>
