# 图片管理API使用指南

## 1. 图片上传接口

### 1.1 通用图片上传
```
POST /api/image/upload/{category}
```

**参数说明：**
- `category`: 图片类别，可选值：
  - `festivals` - 古代节俗礼仪
  - `exhibitions` - 展览
  - `shop-hanfu` - 汉服店铺
  - `etiquette` - 古代仪容仪态
  - `pattern-symbols` - 图案象征
  - `dynasty-shapes` - 各朝代形制
  - `shape-types` - 基本形制分类
  - `clothing-components` - 服饰部件
  - `festival-activities` - 节庆雅集活动
  - `lectures` - 讲座
  - `shop-details` - 店铺详情
  - `community-posts` - 社区帖子

**请求参数：**
- `file` (MultipartFile, 必填): 图片文件

**响应示例：**
```json
{
  "success": true,
  "message": "图片上传成功",
  "path": "/festivals/a1b2c3d4.jpg",
  "url": "http://localhost:8082/festivals/a1b2c3d4.jpg"
}
```

### 1.2 自定义文件名上传
```
POST /api/image/upload/{category}/{customName}
```

**参数说明：**
- `customName`: 自定义文件名（不含扩展名）

## 2. 图片管理接口

### 2.1 删除图片
```
DELETE /api/image/delete?path={imagePath}
```

**参数说明：**
- `path`: 图片相对路径，如 `/festivals/yuanxiao.jpg`

### 2.2 检查图片是否存在
```
GET /api/image/exists?path={imagePath}
```

### 2.3 获取完整图片URL
```
GET /api/image/url?path={imagePath}
```

## 3. 节日管理接口（带图片管理示例）

### 3.1 创建节日（带图片）
```
POST /api/admin/festival/with-image
Content-Type: multipart/form-data
```

**请求参数：**
- `name` (String, 必填): 节日名称
- `date` (String, 必填): 节日日期
- `season` (String, 必填): 所属季节
- `description` (String, 必填): 节日描述
- `customs` (String, 可选): 节日习俗
- `image` (MultipartFile, 可选): 节日图片

### 3.2 更新节日（带图片更新）
```
PUT /api/admin/festival/{id}/with-image
Content-Type: multipart/form-data
```

**说明：** 上传新图片时会自动删除旧图片

### 3.3 仅更新节日图片
```
PUT /api/admin/festival/{id}/image
Content-Type: multipart/form-data
```

**请求参数：**
- `image` (MultipartFile, 必填): 新图片

### 3.4 删除节日
```
DELETE /api/admin/festival/{id}
```

**说明：** 删除节日时会同时删除关联的图片文件

## 4. 图片存储规则

### 4.1 存储路径
- 所有图片存储在 `frontend/public/` 下的对应类别文件夹中
- 例如：节日图片存储在 `frontend/public/festivals/`

### 4.2 数据库设计
- 数据库只存储图片的相对路径（如 `/festivals/yuanxiao.jpg`）
- 前端通过拼接基础URL访问完整图片路径

### 4.3 文件命名
- 默认使用UUID生成唯一文件名
- 支持自定义文件名（自动清理非法字符）

## 5. 支持的图片格式

- JPG / JPEG
- PNG
- GIF
- WebP

**文件大小限制：** 最大10MB

## 6. 异常处理

### 6.1 错误类型
- `IMAGE_ERROR`: 图片处理错误
- `FILE_SIZE_EXCEEDED`: 文件大小超限
- `IO_ERROR`: 文件操作失败
- `INVALID_ARGUMENT`: 参数错误
- `RUNTIME_ERROR`: 运行时错误
- `SYSTEM_ERROR`: 系统错误

### 6.2 错误响应格式
```json
{
  "success": false,
  "message": "错误描述",
  "errorType": "ERROR_TYPE"
}
```

## 7. 最佳实践

### 7.1 前端图片显示
```javascript
import { getImageUrl } from '@/utils/imageHelper';

// 在模板中使用
<img :src="getImageUrl(festival.image)" alt="节日图片">
```

### 7.2 前端图片上传
```javascript
import { isValidImageFile, isValidFileSize, createUploadFormData } from '@/utils/imageHelper';

// 验证文件
if (!isValidImageFile(file)) {
  alert('请选择有效的图片文件（jpg、png、gif、webp）');
  return;
}

if (!isValidFileSize(file, 10)) {
  alert('图片大小不能超过10MB');
  return;
}

// 创建FormData
const formData = createUploadFormData(file, {
  name: '元宵节',
  date: '正月十五',
  season: '春季'
});

// 上传
fetch('/api/admin/festival/with-image', {
  method: 'POST',
  body: formData
});
```

### 7.3 图片更新流程
1. 管理员选择新图片
2. 前端验证图片格式和大小
3. 调用更新接口（如 `PUT /api/admin/festival/{id}/with-image`）
4. 后端自动删除旧图片并保存新图片
5. 更新数据库中的图片路径
6. 返回更新后的数据

## 8. 配置说明

### 8.1 后端配置（application.yml）
```yaml
image:
  upload:
    base-path: E:/hanfu-cultural-platform-3/.../frontend/public
    allowed-extensions: jpg,jpeg,png,gif,webp
    max-size: 10
  access:
    base-url: http://localhost:8082
```

### 8.2 前端配置（imageHelper.js）
```javascript
const API_BASE = 'http://localhost:8082';
```
