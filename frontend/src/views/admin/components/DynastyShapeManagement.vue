<template>
  <div class="dynasty-shape-management">
    <div class="header-actions">
      <el-button @click="loadData">刷新</el-button>
      <el-button type="primary" @click="showAddDialog">添加形制</el-button>
    </div>

    <el-table :data="dynastyShapes" style="width: 100%">
      <el-table-column type="index" label="序号" width="80" />
      <el-table-column prop="name" label="名称" width="120" />
      <el-table-column prop="period" label="朝代时期" width="150" />
      <el-table-column prop="description" label="描述" show-overflow-tooltip />
      <el-table-column prop="features" label="特征" show-overflow-tooltip />
      <el-table-column label="操作" width="180">
        <template #default="{ row }">
          <el-button size="small" @click="editItem(row)">编辑</el-button>
          <el-button size="small" type="danger" @click="deleteItem(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="600px"
    >
      <el-form :model="form" label-width="100px">
        <el-form-item label="名称">
          <el-input v-model="form.name" placeholder="请输入形制名称" />
        </el-form-item>
        <el-form-item label="朝代时期">
          <el-input v-model="form.period" placeholder="请输入朝代时期" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="3"
            placeholder="请输入描述"
          />
        </el-form-item>
        <el-form-item label="特征">
          <el-input
            v-model="form.features"
            type="textarea"
            :rows="3"
            placeholder="请输入特征，用|分隔"
          />
        </el-form-item>
        <el-form-item label="图片URL">
          <el-input v-model="form.image" placeholder="请输入图片URL" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveItem">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const API_BASE = 'http://localhost:8082/api'

const dynastyShapes = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('添加形制')
const form = ref({
  id: null,
  name: '',
  period: '',
  description: '',
  features: '',
  image: ''
})

const loadData = async () => {
  try {
    const response = await fetch(`${API_BASE}/dynasty-shape`)
    if (response.ok) {
      dynastyShapes.value = await response.json()
    }
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败')
  }
}

const showAddDialog = () => {
  dialogTitle.value = '添加形制'
  form.value = {
    id: null,
    name: '',
    period: '',
    description: '',
    features: '',
    image: ''
  }
  dialogVisible.value = true
}

const editItem = (row) => {
  dialogTitle.value = '编辑形制'
  form.value = { ...row }
  dialogVisible.value = true
}

const saveItem = async () => {
  try {
    const url = form.value.id
      ? `${API_BASE}/dynasty-shape/${form.value.id}`
      : `${API_BASE}/dynasty-shape`
    const method = form.value.id ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(form.value)
    })

    if (response.ok) {
      ElMessage.success('保存成功')
      dialogVisible.value = false
      loadData()
    } else {
      ElMessage.error('保存失败')
    }
  } catch (error) {
    console.error('保存失败:', error)
    ElMessage.error('保存失败')
  }
}

const deleteItem = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除这条记录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    const response = await fetch(`${API_BASE}/dynasty-shape/${id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      ElMessage.success('删除成功')
      loadData()
    } else {
      ElMessage.error('删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.dynasty-shape-management {
  padding: 20px;
}

.header-actions {
  margin-bottom: 20px;
}
</style>
