<template>
  <div class="shop-profile-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="nav-container">
        <div class="logo">汉服文化交流平台</div>
        <ul class="nav-menu">
          <li class="nav-item" @click="$router.push('/knowledge')">汉服知识库</li>
          <li class="nav-item" @click="$router.push('/culture')">传统文化学习</li>
          <li class="nav-item" @click="$router.push('/activity')">汉服活动召集</li>
          <li class="nav-item" @click="$router.push('/shop-evaluation')">汉服店铺测评</li>
          <li class="nav-item" @click="$router.push('/community')">社区互动</li>
          <li class="nav-item" @click="$router.push('/ai-chat')">AI问答</li>
          <li class="nav-item active">个人中心</li>
        </ul>
        <div class="user-info-vertical">
          <div class="user-name">欢迎，{{ shopInfo.shopName }}</div>
          <el-button type="text" @click="logout" class="logout-btn">退出</el-button>
        </div>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="container">
        <h2 class="page-title">店铺管理中心</h2>

        <div class="profile-layout">
          <!-- 左侧菜单 -->
          <div class="sidebar">
            <el-menu
              :default-active="activeMenu"
              class="profile-menu"
              @select="handleMenuSelect"
            >
              <el-menu-item index="info">
                <el-icon><Shop /></el-icon>
                <span>店铺信息</span>
              </el-menu-item>
              <el-menu-item index="products">
                <el-icon><Box /></el-icon>
                <span>商品管理</span>
              </el-menu-item>
              <el-menu-item index="reviews">
                <el-icon><ChatDotSquare /></el-icon>
                <span>评价管理</span>
              </el-menu-item>
              <el-menu-item index="statistics">
                <el-icon><DataAnalysis /></el-icon>
                <span>数据统计</span>
              </el-menu-item>
            </el-menu>
          </div>

          <!-- 右侧内容 -->
          <div class="content">
            <!-- 店铺信息 -->
            <div v-if="activeMenu === 'info'" class="section">
              <div class="shop-header">
                <div class="shop-avatar-section">
                  <el-avatar :size="100" :src="shopInfo.logo" shape="square" />
                  <div class="shop-basic-info">
                    <h3>{{ shopInfo.shopName }}</h3>
                    <div class="shop-rating">
                      <el-rate v-model="shopInfo.rating" disabled show-score text-color="#ff9900" />
                      <span class="review-count">({{ shopInfo.reviewCount }}条评价)</span>
                    </div>
                    <p class="shop-tags">
                      <el-tag v-for="tag in shopInfo.tags" :key="tag" size="small" type="info">{{ tag }}</el-tag>
                    </p>
                  </div>
                </div>
                <el-button type="primary" @click="showEditDialog">修改信息</el-button>
              </div>

              <div class="shop-details">
                <h4>店铺简介</h4>
                <p class="shop-description">{{ shopInfo.description }}</p>

                <div class="detail-grid">
                  <div class="detail-item">
                    <label>联系人：</label>
                    <span>{{ shopInfo.contactPerson }}</span>
                  </div>
                  <div class="detail-item">
                    <label>联系电话：</label>
                    <span>{{ shopInfo.phone }}</span>
                  </div>
                  <div class="detail-item">
                    <label>邮箱：</label>
                    <span>{{ shopInfo.email }}</span>
                  </div>
                  <div class="detail-item">
                    <label>地址：</label>
                    <span>{{ shopInfo.address }}</span>
                  </div>
                  <div class="detail-item">
                    <label>营业时间：</label>
                    <span>{{ shopInfo.businessHours }}</span>
                  </div>
                  <div class="detail-item">
                    <label>注册时间：</label>
                    <span>{{ shopInfo.registerTime }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 商品管理 -->
            <div v-else-if="activeMenu === 'products'" class="section">
              <div class="section-header">
                <h3 class="content-title">商品管理</h3>
                <el-button type="primary" @click="showAddProductDialog">添加商品</el-button>
              </div>
              <div class="products-list">
                <div class="product-item" v-for="product in products" :key="product.id">
                  <div class="product-img">
                    <el-image :src="product.image" fit="cover" />
                  </div>
                  <div class="product-info">
                    <h4>{{ product.name }}</h4>
                    <p class="product-price">¥{{ product.price }}</p>
                    <p class="product-desc">{{ product.description }}</p>
                    <div class="product-actions">
                      <el-button size="small" @click="editProduct(product)">编辑</el-button>
                      <el-button size="small" type="danger" @click="deleteProduct(product.id)">删除</el-button>
                    </div>
                  </div>
                </div>
              </div>
              <el-empty v-if="products.length === 0" description="暂无商品" />
            </div>

            <!-- 评价管理 -->
            <div v-else-if="activeMenu === 'reviews'" class="section">
              <h3 class="content-title">评价管理</h3>
              <div class="reviews-list">
                <div class="review-item" v-for="review in shopReviews" :key="review.id">
                  <div class="review-header">
                    <span class="review-user">{{ review.user }}</span>
                    <el-rate v-model="review.rating" disabled size="small" />
                    <span class="review-time">{{ review.time }}</span>
                  </div>
                  <p class="review-content">{{ review.content }}</p>
                  <div class="review-actions">
                    <el-button size="small" type="text" @click="replyReview(review)">回复</el-button>
                  </div>
                  <div class="review-reply" v-if="review.reply">
                    <strong>商家回复：</strong>
                    <span>{{ review.reply }}</span>
                  </div>
                </div>
              </div>
              <el-empty v-if="shopReviews.length === 0" description="暂无评价" />
            </div>

            <!-- 数据统计 -->
            <div v-else-if="activeMenu === 'statistics'" class="section">
              <h3 class="content-title">数据统计</h3>
              <div class="stats-grid">
                <div class="stat-card">
                  <div class="stat-value">{{ statistics.totalSales }}</div>
                  <div class="stat-label">总销量</div>
                </div>
                <div class="stat-card">
                  <div class="stat-value">{{ statistics.totalRevenue }}</div>
                  <div class="stat-label">总收入(元)</div>
                </div>
                <div class="stat-card">
                  <div class="stat-value">{{ statistics.averageRating }}</div>
                  <div class="stat-label">平均评分</div>
                </div>
                <div class="stat-card">
                  <div class="stat-value">{{ statistics.reviewCount }}</div>
                  <div class="stat-label">评价数量</div>
                </div>
              </div>

              <div class="chart-section">
                <h4>近7日销量趋势</h4>
                <!-- 这里可以添加图表组件 -->
                <div class="chart-placeholder">
                  <el-empty description="图表组件开发中" :image-size="100" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 修改信息对话框 -->
    <el-dialog v-model="editDialogVisible" title="修改店铺信息" width="600px">
      <el-form :model="editForm" label-width="100px">
        <el-form-item label="店铺名称">
          <el-input v-model="editForm.shopName" />
        </el-form-item>
        <el-form-item label="店铺简介">
          <el-input v-model="editForm.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="店铺图片">
          <div class="upload-area">
            <input 
              type="file" 
              ref="logoInput" 
              @change="handleLogoChange" 
              accept="image/*"
              style="display: none"
            />
            <div v-if="!logoPreview" class="upload-placeholder" @click="$refs.logoInput.click()">
              <span>点击上传店铺图片</span>
            </div>
            <div v-else class="image-preview-shop">
              <img :src="logoPreview" alt="店铺图片" />
              <button type="button" @click="removeLogo" class="btn-remove">删除</button>
            </div>
          </div>
          <small v-if="uploading" style="color: #666; font-size: 12px;">上传中...</small>
        </el-form-item>
        <el-form-item label="联系人">
          <el-input v-model="editForm.contactPerson" />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="editForm.phone" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="editForm.email" />
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="editForm.address" />
        </el-form-item>
        <el-form-item label="营业时间">
          <el-input v-model="editForm.businessHours" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveShopInfo">保存</el-button>
      </template>
    </el-dialog>

    <!-- 添加商品对话框 -->
    <el-dialog v-model="productDialogVisible" :title="isEditingProduct ? '编辑商品' : '添加商品'" width="500px">
      <el-form :model="productForm" label-width="80px">
        <el-form-item label="商品名称">
          <el-input v-model="productForm.name" />
        </el-form-item>
        <el-form-item label="价格">
          <el-input-number v-model="productForm.price" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="productForm.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="图片">
          <el-upload
            action="#"
            list-type="picture-card"
            :auto-upload="false"
            :on-change="handleProductImageChange"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="productDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveProduct">保存</el-button>
      </template>
    </el-dialog>

    <!-- 页脚 -->
    <div class="footer">
      <div class="container">
        <p>汉服文化交流平台</p>
        <p class="footer-subtitle">传承华夏衣冠，弘扬汉服文化</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Shop, Box, ChatDotSquare, DataAnalysis, Plus } from '@element-plus/icons-vue'

const router = useRouter()
const activeMenu = ref('info')
const editDialogVisible = ref(false)
const productDialogVisible = ref(false)
const isEditingProduct = ref(false)
const uploading = ref(false)
const logoPreview = ref(null)

const shopInfo = ref({
  shopName: '汉服专卖店',
  logo: 'https://placehold.co/100/8b4513/FFFFFF?text=店铺',
  rating: 4.5,
  reviewCount: 128,
  description: '专注于传统汉服制作与销售，致力于传承和弘扬中华传统文化。我们提供各朝代风格的汉服，从秦汉到明清，从常服到礼服，满足不同场合的穿着需求。',
  tags: ['唐宋风', '定制', '高品质', '传统工艺'],
  contactPerson: '张经理',
  phone: '138-0013-8000',
  email: 'contact@hanfu-shop.com',
  address: '北京市东城区传统文化街88号',
  businessHours: '09:00-18:00',
  registerTime: '2022-05-01'
})

const editForm = reactive({
  shopName: '',
  description: '',
  contactPerson: '',
  phone: '',
  email: '',
  address: '',
  businessHours: ''
})

const productForm = reactive({
  name: '',
  price: 0,
  description: '',
  image: ''
})

const products = ref([
  {
    id: 1,
    name: '唐代齐胸襦裙',
    price: 299.00,
    description: '经典唐代风格，精美刺绣',
    image: 'https://placehold.co/100x120/FFE4E1/000000?text=唐装'
  },
  {
    id: 2,
    name: '明代道袍',
    price: 399.00,
    description: '明代文人雅士常服，儒雅大方',
    image: 'https://placehold.co/100x120/E6E6FA/000000?text=明装'
  }
])

const shopReviews = ref([
  {
    id: 1,
    user: '汉服爱好者',
    rating: 5,
    time: '2023-11-15',
    content: '衣服质量很好，做工精细，客服态度也很棒！',
    reply: '感谢您的认可，我们会继续努力提供更好的产品和服务！'
  },
  {
    id: 2,
    user: '传统文化研究者',
    rating: 4,
    time: '2023-11-10',
    content: '复原度很高，细节处理得很到位，值得推荐。'
  }
])

const statistics = ref({
  totalSales: 156,
  totalRevenue: '45,680',
  averageRating: 4.5,
  reviewCount: 128
})

onMounted(() => {
  const savedShopName = localStorage.getItem('shopName')
  if (savedShopName) {
    shopInfo.value.shopName = savedShopName
  }

  // 初始化编辑表单
  Object.assign(editForm, shopInfo.value)
})

const handleMenuSelect = (index) => {
  activeMenu.value = index
}

const showEditDialog = () => {
  // 处理图片预览
  if (shopInfo.value.logo) {
    if (shopInfo.value.logo.startsWith('http://') || shopInfo.value.logo.startsWith('https://')) {
      logoPreview.value = shopInfo.value.logo
    } else {
      logoPreview.value = `http://localhost:8082${shopInfo.value.logo}`
    }
  } else {
    logoPreview.value = null
  }
  editDialogVisible.value = true
}

const handleLogoChange = async (event) => {
  const file = event.target.files[0]
  if (!file) return

  if (!file.type.startsWith('image/')) {
    ElMessage.warning('请选择图片文件')
    return
  }

  if (file.size > 5 * 1024 * 1024) {
    ElMessage.warning('图片大小不能超过5MB')
    return
  }

  uploading.value = true

  try {
    const formData = new FormData()
    formData.append('file', file)

    const response = await fetch('http://localhost:8082/api/upload/image', {
      method: 'POST',
      body: formData
    })

    const result = await response.json()

    if (result.success) {
      editForm.logo = result.url
      logoPreview.value = `http://localhost:8082${result.url}`
      ElMessage.success('图片上传成功')
    } else {
      ElMessage.error(result.message || '上传失败')
    }
  } catch (error) {
    console.error('上传失败', error)
    ElMessage.error('上传失败，请重试')
  } finally {
    uploading.value = false
  }
}

const removeLogo = () => {
  editForm.logo = ''
  logoPreview.value = null
  const fileInput = document.querySelector('input[type="file"]')
  if (fileInput) {
    fileInput.value = ''
  }
}

const saveShopInfo = () => {
  Object.assign(shopInfo.value, editForm)
  localStorage.setItem('shopName', editForm.shopName)
  ElMessage.success('店铺信息更新成功')
  editDialogVisible.value = false
}

const showAddProductDialog = () => {
  isEditingProduct.value = false
  Object.assign(productForm, {
    name: '',
    price: 0,
    description: '',
    image: ''
  })
  productDialogVisible.value = true
}

const editProduct = (product) => {
  isEditingProduct.value = true
  Object.assign(productForm, product)
  productDialogVisible.value = true
}

const handleProductImageChange = (file) => {
  productForm.image = file.url
}

const saveProduct = () => {
  if (!productForm.name || !productForm.price) {
    ElMessage.warning('请填写商品名称和价格')
    return
  }

  if (isEditingProduct.value) {
    // 更新商品
    const index = products.value.findIndex(p => p.id === productForm.id)
    if (index !== -1) {
      products.value[index] = { ...productForm }
    }
    ElMessage.success('商品更新成功')
  } else {
    // 添加新商品
    const newProduct = {
      ...productForm,
      id: Date.now()
    }
    products.value.push(newProduct)
    ElMessage.success('商品添加成功')
  }

  productDialogVisible.value = false
}

const deleteProduct = (productId) => {
  ElMessageBox.confirm('确定要删除这个商品吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    products.value = products.value.filter(p => p.id !== productId)
    ElMessage.success('商品删除成功')
  })
}

const replyReview = (review) => {
  ElMessageBox.prompt('请输入回复内容', '回复评价', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputPattern: /.+/,
    inputErrorMessage: '回复内容不能为空'
  }).then(({ value }) => {
    review.reply = value
    ElMessage.success('回复成功')
  })
}

const logout = () => {
  localStorage.removeItem('isLoggedIn')
  localStorage.removeItem('username')
  localStorage.removeItem('shopName')
  localStorage.removeItem('role')
  ElMessage.success('退出登录成功')
  router.push('/login')
}
</script>

<style scoped>
.shop-profile-container {
  min-height: 100vh;
  background-color: #f5f5f5;
}

/* 复用头部和页脚样式 */
.header {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.nav-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.logo {
  font-size: 20px;
  font-weight: bold;
  white-space: nowrap;
}

.nav-menu {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  white-space: nowrap;
  flex-wrap: nowrap;
}

.nav-item {
  margin: 0 15px;
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 4px;
  transition: background-color 0.3s;
  font-size: 14px;
  white-space: nowrap;
}

.nav-item:hover, .nav-item.active {
  background-color: rgba(255, 255, 255, 0.2);
}

.user-info-vertical {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  white-space: nowrap;
}

.user-name {
  font-size: 14px;
  margin-bottom: 4px;
  color: white;
}

.logout-btn {
  color: white;
  padding: 0;
  font-size: 12px;
  height: auto;
}

.logout-btn:hover {
  color: #ffd04b;
  background-color: transparent;
}

.main-content {
  padding: 30px 0;
  min-height: calc(100vh - 160px);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.page-title {
  font-size: 28px;
  margin-bottom: 20px;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

.profile-layout {
  display: grid;
  grid-template-columns: 250px 1fr;
  gap: 20px;
}

.sidebar {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.profile-menu {
  border: none;
  border-radius: 8px;
}

.profile-menu .el-menu-item {
  height: 60px;
  line-height: 60px;
  border-bottom: 1px solid #f0f0f0;
}

.profile-menu .el-menu-item:last-child {
  border-bottom: none;
}

.profile-menu .el-menu-item.is-active {
  background-color: #f8f0e8;
  color: #8b4513;
  border-right: 3px solid #8b4513;
}

.content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.section {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.shop-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}

.shop-avatar-section {
  display: flex;
  align-items: flex-start;
  gap: 20px;
}

.shop-basic-info h3 {
  margin: 0 0 10px 0;
  color: #8b4513;
  font-size: 24px;
}

.shop-rating {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.review-count {
  font-size: 14px;
  color: #666;
}

.shop-tags {
  margin: 0;
}

.shop-details h4 {
  margin: 0 0 15px 0;
  color: #8b4513;
  font-size: 18px;
}

.shop-description {
  margin: 0 0 20px 0;
  line-height: 1.6;
  color: #666;
}

.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px;
}

.detail-item {
  display: flex;
  align-items: center;
}

.detail-item label {
  width: 80px;
  font-weight: bold;
  color: #333;
  flex-shrink: 0;
}

.detail-item span {
  color: #666;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.content-title {
  margin: 0;
  color: #8b4513;
  font-size: 20px;
  border-left: 4px solid #d4a76a;
  padding-left: 10px;
}

.products-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.product-item {
  display: flex;
  gap: 15px;
  padding: 15px;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  background-color: #fafafa;
}

.product-img {
  width: 100px;
  height: 120px;
  border-radius: 4px;
  overflow: hidden;
  flex-shrink: 0;
}

.product-info {
  flex: 1;
}

.product-info h4 {
  margin: 0 0 8px 0;
  color: #8b4513;
}

.product-price {
  margin: 0 0 8px 0;
  font-size: 18px;
  font-weight: bold;
  color: #e6a23c;
}

.product-desc {
  margin: 0 0 10px 0;
  color: #666;
  line-height: 1.4;
}

.product-actions {
  display: flex;
  gap: 10px;
}

.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.review-item {
  padding: 15px;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  background-color: #fafafa;
}

.review-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}

.review-user {
  font-weight: bold;
  color: #8b4513;
}

.review-time {
  margin-left: auto;
  font-size: 12px;
  color: #999;
}

.review-content {
  margin: 0 0 10px 0;
  line-height: 1.5;
}

.review-actions {
  margin-bottom: 8px;
}

.review-reply {
  padding: 10px;
  background-color: #f0f8ff;
  border-radius: 4px;
  border-left: 3px solid #1890ff;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  opacity: 0.9;
}

.chart-section {
  border-top: 1px solid #f0f0f0;
  padding-top: 20px;
}

.chart-section h4 {
  margin: 0 0 15px 0;
  color: #8b4513;
}

.chart-placeholder {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #fafafa;
  border-radius: 6px;
  border: 1px dashed #ddd;
}

.footer {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  text-align: center;
  padding: 20px 0;
}

.footer-subtitle {
  font-size: 12px;
  opacity: 0.8;
  margin-top: 5px;
}

/* 图片上传样式 */
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
  border-color: #8B4513;
  background: #f9f9f9;
}

.upload-placeholder span {
  color: #666;
  font-size: 14px;
}

.image-preview-shop {
  position: relative;
  display: inline-block;
}

.image-preview-shop img {
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

@media (max-width: 768px) {
  .profile-layout {
    grid-template-columns: 1fr;
  }

  .nav-container {
    flex-direction: column;
    gap: 10px;
  }

  .nav-menu {
    flex-wrap: wrap;
    justify-content: center;
  }

  .nav-item {
    margin: 5px;
    font-size: 12px;
  }

  .shop-header {
    flex-direction: column;
    gap: 15px;
  }

  .shop-avatar-section {
    align-self: flex-start;
  }

  .detail-grid {
    grid-template-columns: 1fr;
  }

  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
