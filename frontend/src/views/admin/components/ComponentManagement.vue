<template>
  <div class="component-management">
    <div class="header-actions">
      <el-button @click="loadData">刷新</el-button>
      <el-button type="primary" @click="showAddDialog">添加部件</el-button>
    </div>

    <el-table :data="components" style="width: 100%">
      <el-table-column type="index" label="序号" width="80" />
      <el-table-column prop="name" label="名称" width="100" />
      <el-table-column prop="type" label="类型" width="120" />
      <el-table-column prop="description" label="描述" show-overflow-tooltip />
      <el-table-column prop="sortOrder" label="排序" width="80" />
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
      width="700px"
    >
      <el-form :model="form" label-width="100px">
        <el-form-item label="名称">
          <el-input v-model="form.name" placeholder="请输入部件名称" />
        </el-form-item>
        <el-form-item label="类型">
          <el-select v-model="form.type" placeholder="请选择类型" style="width: 100%">
            <el-option label="上身服饰" value="上身服饰" />
            <el-option label="下身服饰" value="下身服饰" />
            <el-option label="一体服饰" value="一体服饰" />
            <el-option label="上衣" value="上衣" />
            <el-option label="下裳" value="下裳" />
            <el-option label="首服" value="首服" />
          </el-select>
        </el-form-item>
        <el-form-item label="描述">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="2"
            placeholder="请输入简短描述"
          />
        </el-form-item>
        <el-form-item label="详细内容">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="6"
            placeholder="请输入详细内容"
          />
        </el-form-item>
        <el-form-item label="图片URL">
          <el-input v-model="form.image" placeholder="请输入图片URL" />
        </el-form-item>
        <el-form-item label="排序号">
          <el-input-number v-model="form.sortOrder" :min="0" :max="100" />
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

const components = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('添加部件')
const form = ref({
  id: null,
  name: '',
  type: '',
  description: '',
  content: '',
  image: '',
  sortOrder: 0
})

const loadData = async () => {
  try {
    const response = await fetch(`${API_BASE}/component`)
    if (response.ok) {
      components.value = await response.json()
    }
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败')
  }
}

const showAddDialog = () => {
  dialogTitle.value = '添加部件'
  form.value = {
    id: null,
    name: '',
    type: '',
    description: '',
    content: '',
    image: '',
    sortOrder: 0
  }
  dialogVisible.value = true
}

const editItem = (row) => {
  dialogTitle.value = '编辑部件'
  form.value = { ...row }
  dialogVisible.value = true
}

const saveItem = async () => {
  try {
    const url = form.value.id 
      ? `${API_BASE}/component/${form.value.id}`
      : `${API_BASE}/component`
    
    const method = form.value.id ? 'PUT' : 'POST'
    
    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(form.value)
    })

    if (response.ok) {
      ElMessage.success(form.value.id ? '更新成功' : '添加成功')
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
    await ElMessageBox.confirm('确定要删除这个部件吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    const response = await fetch(`${API_BASE}/component/${id}`, {
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
.component-management {
  padding: 20px;
}

.header-actions {
  margin-bottom: 20px;
}
</style>
