/**
 * 图片URL处理工具函数
 * 统一处理前台所有图片URL,确保正确显示
 */

const API_BASE = 'http://localhost:8082';

/**
 * 图片类别配置
 * 对应后端存储的各个文件夹
 */
export const IMAGE_CATEGORIES = {
  FESTIVALS: 'festivals',           // 古代节俗礼仪
  EXHIBITIONS: 'exhibitions',       // 展览
  SHOP_HANFU: 'shop-hanfu',         // 汉服店铺
  ETIQUETTE: 'etiquette',           // 古代仪容仪态
  PATTERN_SYMBOLS: 'pattern-symbols', // 图案象征
  DYNASTY_SHAPES: 'dynasty-shapes', // 各朝代形制
  SHAPE_TYPES: 'shape-types',       // 基本形制分类
  CLOTHING_COMPONENTS: 'clothing-components', // 服饰部件
  FESTIVAL_ACTIVITIES: 'festival-activities', // 节庆雅集活动
  LECTURES: 'lectures',             // 讲座
  SHOP_DETAILS: 'shop-details',     // 店铺详情
  COMMUNITY_POSTS: 'community-posts' // 社区帖子
};

/**
 * 获取完整的图片URL
 * @param {string} url - 图片URL(可能是相对路径或完整URL)
 * @returns {string} 完整的图片URL
 */
export function getImageUrl(url) {
  if (!url) return '';

  // 如果已经是完整URL,直接返回
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }

  // 如果是相对路径,添加服务器地址
  // 确保路径以/开头
  const path = url.startsWith('/') ? url : `/${url}`;
  return `${API_BASE}${path}`;
}

/**
 * 获取图片的相对路径（用于存储到数据库）
 * @param {string} fullUrl - 完整URL
 * @returns {string} 相对路径
 */
export function getRelativePath(fullUrl) {
  if (!fullUrl) return '';

  // 如果已经是相对路径，直接返回
  if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
    return fullUrl.startsWith('/') ? fullUrl : `/${fullUrl}`;
  }

  // 从完整URL中提取相对路径
  try {
    const url = new URL(fullUrl);
    return url.pathname;
  } catch (e) {
    return fullUrl;
  }
}

/**
 * 批量处理图片URL数组
 * @param {Array} images - 图片数组
 * @param {string} urlField - URL字段名,默认为'url'
 * @returns {Array} 处理后的图片数组
 */
export function processImageArray(images, urlField = 'url') {
  if (!Array.isArray(images)) return [];

  return images.map(img => {
    if (typeof img === 'string') {
      return getImageUrl(img);
    }

    if (typeof img === 'object' && img[urlField]) {
      return {
        ...img,
        [urlField]: getImageUrl(img[urlField])
      };
    }

    return img;
  });
}

/**
 * 处理实体数据中的图片字段
 * @param {Object} entity - 实体对象
 * @param {string} imageField - 图片字段名，默认为'image'
 * @returns {Object} 处理后的实体对象
 */
export function processEntityImage(entity, imageField = 'image') {
  if (!entity) return entity;

  const processed = { ...entity };

  if (processed[imageField]) {
    processed[imageField] = getImageUrl(processed[imageField]);
  }

  return processed;
}

/**
 * 处理节日数据中的图片
 * @param {Object} festival - 节日对象
 * @returns {Object} 处理后的节日对象
 */
export function processFestivalImages(festival) {
  return processEntityImage(festival, 'image');
}

/**
 * 处理帖子数据中的图片
 * @param {Object} post - 帖子对象
 * @returns {Object} 处理后的帖子对象
 */
export function processPostImages(post) {
  if (!post) return post;

  const processed = { ...post };

  // 处理主图片
  if (processed.imageUrl || processed.image) {
    const mainImage = processed.imageUrl || processed.image;
    processed.image = getImageUrl(mainImage);
    processed.imageUrl = processed.image;
  }

  // 处理图片数组
  if (processed.images && Array.isArray(processed.images)) {
    processed.images = processImageArray(processed.images, 'url');
  } else if (processed.image) {
    // 如果没有images数组但有主图,创建images数组
    processed.images = [{ url: processed.image }];
  }

  return processed;
}

/**
 * 处理店铺数据中的图片
 * @param {Object} shop - 店铺对象
 * @returns {Object} 处理后的店铺对象
 */
export function processShopImages(shop) {
  if (!shop) return shop;

  const processed = { ...shop };

  // 处理店铺主图
  if (processed.image) {
    processed.image = getImageUrl(processed.image);
  }

  // 处理店铺logo
  if (processed.logo) {
    processed.logo = getImageUrl(processed.logo);
  }

  return processed;
}

/**
 * 处理活动数据中的图片
 * @param {Object} activity - 活动对象
 * @returns {Object} 处理后的活动对象
 */
export function processActivityImages(activity) {
  return processEntityImage(activity, 'image');
}

/**
 * 处理用户头像
 * @param {string} avatar - 头像URL
 * @returns {string} 处理后的头像URL
 */
export function processAvatar(avatar) {
  return getImageUrl(avatar);
}

/**
 * 验证文件是否为允许的图片格式
 * @param {File} file - 文件对象
 * @returns {boolean} 是否有效
 */
export function isValidImageFile(file) {
  if (!file) return false;

  const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
  const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];

  // 检查 MIME 类型
  if (allowedTypes.includes(file.type)) {
    return true;
  }

  // 检查文件扩展名
  const fileName = file.name.toLowerCase();
  return allowedExtensions.some(ext => fileName.endsWith(ext));
}

/**
 * 验证文件大小是否在限制内
 * @param {File} file - 文件对象
 * @param {number} maxSizeMB - 最大大小（MB），默认10MB
 * @returns {boolean} 是否有效
 */
export function isValidFileSize(file, maxSizeMB = 10) {
  if (!file) return false;

  const maxSizeBytes = maxSizeMB * 1024 * 1024;
  return file.size <= maxSizeBytes;
}

/**
 * 获取文件扩展名
 * @param {string} fileName - 文件名
 * @returns {string} 扩展名（不含点）
 */
export function getFileExtension(fileName) {
  if (!fileName || !fileName.includes('.')) {
    return '';
  }
  return fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
}

/**
 * 生成唯一的文件名
 * @param {string} originalName - 原始文件名
 * @returns {string} 唯一文件名
 */
export function generateUniqueFileName(originalName) {
  const timestamp = Date.now();
  const random = Math.random().toString(36).substring(2, 8);
  const extension = getFileExtension(originalName);
  return `${timestamp}_${random}.${extension}`;
}

/**
 * 压缩图片
 * @param {File} file - 图片文件
 * @param {Object} options - 压缩选项
 * @returns {Promise<Blob>} 压缩后的图片Blob
 */
export function compressImage(file, options = {}) {
  return new Promise((resolve, reject) => {
    const {
      maxWidth = 1920,
      maxHeight = 1080,
      quality = 0.8,
      type = 'image/jpeg'
    } = options;

    const reader = new FileReader();
    reader.onload = (e) => {
      const img = new Image();
      img.onload = () => {
        let { width, height } = img;

        // 计算缩放后的尺寸
        if (width > maxWidth || height > maxHeight) {
          const ratio = Math.min(maxWidth / width, maxHeight / height);
          width *= ratio;
          height *= ratio;
        }

        const canvas = document.createElement('canvas');
        canvas.width = width;
        canvas.height = height;

        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, width, height);

        canvas.toBlob(
          (blob) => {
            if (blob) {
              resolve(blob);
            } else {
              reject(new Error('图片压缩失败'));
            }
          },
          type,
          quality
        );
      };
      img.onerror = () => reject(new Error('图片加载失败'));
      img.src = e.target.result;
    };
    reader.onerror = () => reject(new Error('文件读取失败'));
    reader.readAsDataURL(file);
  });
}

/**
 * 创建FormData用于上传
 * @param {File} file - 文件对象
 * @param {Object} additionalData - 附加数据
 * @param {string} fileFieldName - 文件字段名，默认'image'
 * @returns {FormData} FormData对象
 */
export function createUploadFormData(file, additionalData = {}, fileFieldName = 'image') {
  const formData = new FormData();
  formData.append(fileFieldName, file);

  Object.keys(additionalData).forEach(key => {
    if (additionalData[key] !== undefined && additionalData[key] !== null) {
      formData.append(key, additionalData[key]);
    }
  });

  return formData;
}

export default {
  API_BASE,
  IMAGE_CATEGORIES,
  getImageUrl,
  getRelativePath,
  processImageArray,
  processEntityImage,
  processFestivalImages,
  processPostImages,
  processShopImages,
  processActivityImages,
  processAvatar,
  isValidImageFile,
  isValidFileSize,
  getFileExtension,
  generateUniqueFileName,
  compressImage,
  createUploadFormData
};
