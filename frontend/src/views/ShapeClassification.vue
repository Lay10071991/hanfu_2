<template>
  <div class="shape-classification-container">
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
          <li class="nav-item" @click="goToProfile">个人中心</li>
        </ul>
        <div class="user-info-vertical">
          <div class="user-name">欢迎，{{ username }}</div>
          <el-button type="text" @click="logout" class="logout-btn">退出</el-button>
        </div>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="container">
        <!-- 返回按钮 -->
        <div class="back-section">
          <el-button type="text" @click="$router.back()" class="back-btn">
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
        </div>

        <h2 class="page-title">汉服形制分类</h2>

        <!-- 基本形制介绍 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><Grid /></el-icon>
            四大基本形制
          </h3>
          <div class="shape-types">
            <div
              class="shape-type-card"
              v-for="shape in shapeTypes"
              :key="shape.name"
              @click="showDetail('shape', shape)"
            >
              <div class="shape-type-header">
                <h4>{{ shape.name }}</h4>
              </div>
              <div class="shape-type-content">
                <p>{{ shape.description }}</p>
                <div class="shape-details">
                  <div class="detail-item">
                    <span class="detail-label">流行时期：</span>
                    <span class="detail-value">{{ shape.period }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">主要特征：</span>
                    <span class="detail-value">{{ shape.characteristics }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 服饰部件介绍 -->
        <div class="section">
          <h3 class="section-title">
            <el-icon><SetUp /></el-icon>
            服饰部件详解
          </h3>
          <div class="components-grid">
            <div
              class="component-card"
              v-for="component in components"
              :key="component.name"
              @click="showDetail('component', component)"
            >
              <div class="component-icon">
                <el-icon><Goods /></el-icon>
              </div>
              <div class="component-info">
                <h4>{{ component.name }}</h4>
                <p>{{ component.description }}</p>
                <span class="component-type">{{ component.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 页脚 -->
    <div class="footer">
      <div class="container">
        <p>汉服文化交流平台</p>
        <p class="footer-subtitle">传承华夏衣冠，弘扬汉服文化</p>
      </div>
    </div>

    <!-- 弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentDetail.title"
      width="65%"
      :before-close="handleClose"
      class="detail-dialog"
      destroy-on-close
    >
      <div class="dialog-content">
        <!-- 详细简介 -->
        <div v-if="currentDetail.content" class="content-section">
          <div class="content-text">
            <p>{{ currentDetail.content }}</p>
          </div>
        </div>

        <!-- 图片展示区域 -->
        <div class="image-gallery" v-if="currentDetail.images && currentDetail.images.length > 0">
          <div class="image-grid">
            <div class="image-item" v-for="(image, index) in currentDetail.images" :key="index">
              <el-image
                :src="image.url"
                :alt="image.alt"
                fit="cover"
                class="detail-image"
                :preview-src-list="currentDetail.images.map((img) => img.url)"
                :initial-index="index"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                    <div>{{ image.alt }}</div>
                  </div>
                </template>
              </el-image>
              <div class="image-caption">{{ image.caption }}</div>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false" type="primary">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import {
  ArrowLeft,
  Histogram,
  Grid,
  SetUp,
  Goods,
  Picture,
  InfoFilled,
  Collection,
  Clock,
  Document,
} from "@element-plus/icons-vue";

const router = useRouter();
const username = ref("汉服爱好者");
const dialogVisible = ref(false);

// 当前显示的详情内容
const currentDetail = reactive({
  title: "",
  content: [],
  images: [],
});

// 基本形制数据 - 从后端加载
const shapeTypes = ref([]);

// 加载形制分类数据
const loadShapeTypes = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/shape-type/top4");
    if (response.ok) {
      const data = await response.json();
      shapeTypes.value = data;
    }
  } catch (error) {
    console.error("加载形制分类数据失败:", error);
    // 使用默认数据
    shapeTypes.value = [
      {
        name: "衣裳制",
        description: "上衣下裳的基本形制，最古老的汉服形式，象征天地秩序。",
        period: "先秦至明清",
        characteristics: "上下分裁、庄严正统、礼仪性强",
      },
      {
        name: "深衣制",
        description: "上下连属的服饰，将上衣下裳连为一体，体现深意。",
        period: "战国至明代",
        characteristics: "上下连属、端庄大方、适用广泛",
      },
      {
        name: "袍服制",
        description: "一体裁剪的长衣，便于活动，逐渐成为日常服饰。",
        period: "汉代以后",
        characteristics: "一体裁剪、便于活动、日常实用",
      },
      {
        name: "襦裙制",
        description: "上衣下裙的女装组合，历代款式变化丰富多样。",
        period: "历代流行",
        characteristics: "上衣下裙、款式多样、女性特色",
      },
    ];
  }
};

// 服饰部件数据 - 从后端加载
const components = ref([]);

// 加载服饰部件数据
const loadComponents = async () => {
  try {
    const response = await fetch("http://localhost:8082/api/component");
    if (response.ok) {
      const data = await response.json();
      components.value = data.map((item) => ({
        id: item.id,
        name: item.name,
        type: item.type,
        description: item.description,
      }));
    }
  } catch (error) {
    console.error("加载服饰部件数据失败:", error);
    // 使用默认数据
    components.value = [
      {
        id: 1,
        name: "衣",
        type: "上身服饰",
        description: "汉服的上身部分，包括各种款式的上衣。",
      },
      {
        id: 2,
        name: "裳",
        type: "下身服饰",
        description: "汉服的下身部分，主要指裙装。",
      },
      {
        id: 3,
        name: "袍",
        type: "一体服饰",
        description: "上下连属的长衣，有衬里的称袍。",
      },
      {
        id: 4,
        name: "衫",
        type: "一体服饰",
        description: "单层的长衣，无衬里的称衫。",
      },
      {
        id: 5,
        name: "襦",
        type: "上衣",
        description: "短上衣，通常与裙搭配穿着。",
      },
      {
        id: 6,
        name: "裙",
        type: "下裳",
        description: "下身穿着的裙装，款式多样。",
      },
      {
        id: 7,
        name: "裤",
        type: "下裳",
        description: "下身穿着的裤装，便于活动。",
      },
      {
        id: 8,
        name: "冠",
        type: "首服",
        description: "头上戴的冠帽，体现身份等级。",
      },
    ];
  }
};

// 详细内容数据
const detailContents = {
  shape: {
    衣裳制: {
      title: "衣裳制 - 基本形制",
      content: [
        "衣裳制是汉服最古老、最基本的形制，其特点是将上衣和下裳分开裁剪制作。",
        '这种形制源于古人对天地的崇拜，上衣象征天，下裳象征地，体现了"天人合一"的哲学思想。',
        "衣裳制在礼仪场合中具有重要地位，历代祭祀、朝会等重要场合多采用此形制。",
        "在具体款式上，上衣多为交领右衽，下裳则为裙或裤。上衣的长度一般到腰部，下裳则垂至脚踝。",
        "衣裳制的颜色搭配也有严格规定，天子穿玄衣纁裳（黑色上衣，红色下裳），象征天地。",
        "虽然在后世发展中出现了其他形制，但衣裳制始终保持着其正统地位，是汉服文化的核心代表。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20with%20separate%20top%20and%20bottom%2C%20ancient%20style%2C%20elegant%20design%2C%20historical%20costume&image_size=square_hd",
          alt: "衣裳制",
          caption: "上衣下裳的基本形制",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=hanfu%20ceremonial%20costume%2C%20ancient%20Chinese%20ritual%20clothing%2C%20black%20top%20and%20red%20bottom%2C%20traditional%20style&image_size=square_hd",
          alt: "玄衣纁裳",
          caption: "天子穿的玄衣纁裳",
        },
      ],
    },
    深衣制: {
      title: "深衣制 - 主要形制",
      content: [
        '深衣制是将上衣和下裳连为一体的服饰形制，体现了"深意"的文化内涵。',
        "这种形制在战国时期开始流行，后成为历代重要的服饰形式。深衣既保持了衣裳制的庄重，又便于活动。",
        '深衣在裁剪上讲究"续衽钩边"，即衣襟接长向后环绕，再用腰带系扎，形成独特的曲线美。',
        "深衣的长度一般到脚踝，袖子宽大，体现了汉服的飘逸之美。",
        "深衣制对后世服饰发展产生了深远影响，是现代汉服复兴中的重要形制之一。",
        "根据不同的用途和场合，深衣又分为曲裾深衣、直裾深衣等多种款式。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20deep%20robe%20(深衣)%2C%20ancient%20style%2C%20elegant%20design%2C%20long%20flowing%20robes%2C%20historical%20costume&image_size=square_hd",
          alt: "深衣制",
          caption: "上下连属的深衣形制",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=curved%20hem%20deep%20robe%20(曲裾深衣)%2C%20ancient%20Chinese%20hanfu%2C%20traditional%20style%2C%20elegant%20design&image_size=square_hd",
          alt: "曲裾深衣",
          caption: "曲裾深衣款式",
        },
      ],
    },
    袍服制: {
      title: "袍服制 - 日常形制",
      content: [
        "袍服制是一体裁剪的长衣，便于活动，逐渐成为日常服饰。",
        "这种形制在汉代以后开始流行，是对深衣制的简化和发展。",
        "袍服的特点是上衣和下裳连成一体，无明显的分界，穿着更加方便舒适。",
        "根据厚度和材质的不同，袍服可分为单袍、夹袍、棉袍等多种类型。",
        "袍服的款式多样，包括圆领袍、直领袍、交领袍等，适应不同的季节和场合。",
        "在唐代，圆领袍成为官员的常服，后来逐渐普及到民间，成为日常穿着的主要形式。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20robe%20(袍服)%2C%20ancient%20style%2C%20daily%20wear%2C%20elegant%20design%2C%20historical%20costume&image_size=square_hd",
          alt: "袍服制",
          caption: "一体裁剪的袍服形制",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=round%20collar%20robe%20(圆领袍)%2C%20ancient%20Chinese%20official%20costume%2C%20traditional%20style%2C%20elegant%20design&image_size=square_hd",
          alt: "圆领袍",
          caption: "唐代圆领袍款式",
        },
      ],
    },
    襦裙制: {
      title: "襦裙制 - 女性形制",
      content: [
        "襦裙制是上衣下裙的女装组合，历代款式变化丰富多样。",
        "这种形制是女性汉服的主要形式，由短上衣（襦）和裙子组成。",
        "襦裙的特点是上衣短小，裙子较长，体现了女性的柔美气质。",
        "根据裙子的位置不同，襦裙可分为齐胸襦裙、齐腰襦裙、高腰襦裙等多种款式。",
        "齐胸襦裙流行于隋唐时期，裙子系在胸部以上，显得身材修长；齐腰襦裙则是最常见的款式，裙子系在腰部。",
        "襦裙的颜色和纹样丰富多样，反映了不同时代的审美特点，是汉服文化中最具代表性的女装形制。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20ruqun%20(襦裙)%2C%20ancient%20style%2C%20female%20hanfu%2C%20elegant%20design%2C%20historical%20costume&image_size=square_hd",
          alt: "襦裙制",
          caption: "上衣下裙的襦裙形制",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=high%20waist%20ruqun%20(齐胸襦裙)%2C%20ancient%20Chinese%20female%20hanfu%2C%20traditional%20style%2C%20elegant%20design&image_size=square_hd",
          alt: "齐胸襦裙",
          caption: "隋唐时期的齐胸襦裙",
        },
      ],
    },
  },
  component: {
    衣: {
      title: "衣 - 上身服饰",
      content: [
        "衣是汉服的上身部分，包括各种款式的上衣。根据形制、用途的不同，衣有多种分类。",
        "常见的上衣包括襦、衫、袄等。襦为短上衣，衫为单层上衣，袄为有衬里的上衣。",
        "衣的领型有交领、直领、圆领等多种形式，袖型有广袖、窄袖、琵琶袖等变化。",
        "不同朝代、不同场合的衣在款式、色彩、纹样上都有严格的规定，体现了汉服的礼仪性。",
        "衣的长度从短至腰到长及膝下不等，根据季节和场合选择合适的款式。",
        "衣的纹样装饰丰富多样，常见的有云纹、龙纹、凤纹等，体现了穿着者的身份和地位。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20upper%20garment%20(衣)%2C%20elegant%20design%2C%20ancient%20style%2C%20historical%20costume&image_size=square_hd",
          alt: "上衣",
          caption: "汉服上衣样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20cross-collar%20upper%20garment%2C%20traditional%20style%2C%20elegant%20design&image_size=square_hd",
          alt: "交领衣",
          caption: "交领右衽的传统上衣",
        },
      ],
    },
    裳: {
      title: "裳 - 下身服饰",
      content: [
        "裳是汉服的下身部分，主要指裙装。在古代，裳是男女皆可穿着的下装。",
        "裳的款式多样，包括单片裙、多片裙、马面裙等。不同形制的裳在裁剪和穿着方式上各有特点。",
        "裳的长度、幅数、褶数等都有特定的文化含义，体现了古人的审美观念和社会规范。",
        "随着时代发展，裳的款式不断丰富，成为汉服文化中的重要组成部分。",
        "裳的穿着方式讲究层次，通常内穿衬裙，外罩主裙，体现了汉服的层次感。",
        "裳的色彩搭配讲究和谐，常与上衣形成对比或呼应，展现整体美感。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20skirt%20(裳)%2C%20elegant%20design%2C%20flowing%20fabric%2C%20ancient%20style&image_size=square_hd",
          alt: "下裳",
          caption: "汉服下裳样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20horse-face%20skirt%20(马面裙)%2C%20traditional%20style%2C%20pleated%20design&image_size=square_hd",
          alt: "马面裙",
          caption: "经典的马面裙款式",
        },
      ],
    },
    袍: {
      title: "袍 - 一体服饰",
      content: [
        "袍是上下连属的长衣，有衬里的称袍，是汉服中重要的服饰类型。",
        "袍的特点是保暖性好，适合秋冬季节穿着，也是正式场合的常见服饰。",
        "袍的款式包括直裾袍、曲裾袍等，不同款式适应不同的场合和身份。",
        "袍的长度一般到脚踝，袖子宽大，体现了汉服的庄重与大气。",
        "袍的颜色和纹样有严格的等级规定，不同品级的官员穿着不同颜色的袍服。",
        "袍的穿着方式讲究系带和配饰，体现了汉服的礼仪规范。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20robe%20(袍)%2C%20lined%20garment%2C%20elegant%20design%2C%20ancient%20style&image_size=square_hd",
          alt: "袍",
          caption: "汉服袍服样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20official%20robe%2C%20traditional%20court%20dress%2C%20elegant%20design&image_size=square_hd",
          alt: "官袍",
          caption: "传统官袍款式",
        },
      ],
    },
    衫: {
      title: "衫 - 单层服饰",
      content: [
        "衫是单层的长衣，无衬里的称衫，适合春夏季节穿着。",
        "衫的特点是轻薄透气，穿着舒适，是日常休闲的常见选择。",
        "衫的款式包括直领衫、交领衫等，面料多为丝绸、棉麻等轻薄材质。",
        "衫的长度变化多样，有长及脚踝的长衫，也有短至腰部的短衫。",
        "衫的颜色以素雅为主，常见的有白色、浅蓝、淡粉等清新色调。",
        "衫的穿着场合广泛，既可作为内衣，也可作为外衣，体现了汉服的实用性。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20unlined%20garment%20(衫)%2C%20light%20fabric%2C%20elegant%20design%2C%20summer%20style&image_size=square_hd",
          alt: "衫",
          caption: "汉服衫服样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20light%20summer%20robe%2C%20flowing%20silk%2C%20elegant%20design&image_size=square_hd",
          alt: "夏衫",
          caption: "轻薄透气的夏衫",
        },
      ],
    },
    襦: {
      title: "襦 - 短上衣",
      content: [
        "襦是短上衣，长度一般到腰部，通常与裙搭配穿着。",
        "襦的特点是短小精悍，便于活动，是女性日常穿着的主要上衣类型。",
        "襦的领型多为交领，也有对襟款式，袖子有窄袖和广袖之分。",
        "襦与裙的搭配形成了襦裙这一经典女装形制，历代款式变化丰富。",
        "襦的装饰精美，常在领口、袖口、下摆处绣有花纹，体现女性审美。",
        "襦的颜色选择丰富，可根据季节和场合搭配不同颜色的裙子。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20short%20upper%20garment%20(襦)%2C%20elegant%20design%2C%20ancient%20style%2C%20female%20costume&image_size=square_hd",
          alt: "襦",
          caption: "汉服襦衣样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20ruqun%20outfit%2C%20short%20top%20and%20skirt%2C%20traditional%20female%20dress&image_size=square_hd",
          alt: "襦裙搭配",
          caption: "襦裙经典搭配",
        },
      ],
    },
    裙: {
      title: "裙 - 下裳",
      content: [
        "裙是下身穿着的裙装，是女性汉服的重要组成部分。",
        "裙的款式多样，包括百褶裙、马面裙、月华裙等，每种都有独特的审美特点。",
        "裙的穿着位置有齐胸、齐腰、高腰之分，不同位置展现不同的身材比例。",
        "裙的面料多为丝绸、锦缎等，质地轻盈，行走时飘逸动人。",
        "裙的纹样装饰丰富，常见的有花卉、云纹、几何图案等。",
        "裙的色彩搭配讲究，常与上衣形成和谐或对比的视觉效果。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20skirt%20(裙)%2C%20elegant%20design%2C%20flowing%20fabric%2C%20female%20costume&image_size=square_hd",
          alt: "裙",
          caption: "汉服裙装样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20pleated%20skirt%2C%20traditional%20design%2C%20elegant%20flowing%20fabric&image_size=square_hd",
          alt: "百褶裙",
          caption: "优雅的百褶裙",
        },
      ],
    },
    裤: {
      title: "裤 - 下装",
      content: [
        "裤是下身穿着的裤装，便于活动，是实用的下装选择。",
        "古代的裤与现代有所不同，早期为无裆的胫衣，后发展为合裆裤。",
        "裤的款式包括长裤、短裤、灯笼裤等，适应不同的活动和场合。",
        "裤常穿在裙内作为衬裤，也可单独外穿，体现了汉服的层次感。",
        "裤的面料多为棉麻、丝绸等，注重舒适性和实用性。",
        "裤的系带设计便于调节松紧，适应不同身材和活动需求。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20trousers%20(裤)%2C%20loose%20design%2C%20comfortable%20fit%2C%20ancient%20style&image_size=square_hd",
          alt: "裤",
          caption: "汉服裤装样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20hanfu%20loose%20pants%2C%20traditional%20design%2C%20comfortable%20wear&image_size=square_hd",
          alt: "宽松裤",
          caption: "宽松舒适的汉服裤",
        },
      ],
    },
    冠: {
      title: "冠 - 首服",
      content: [
        "冠是头上戴的冠帽，是汉服首服的重要组成部分，体现身份等级。",
        "冠的种类繁多，包括冕冠、通天冠、进贤冠等，不同冠代表不同身份。",
        "冠的佩戴有严格的礼仪规范，不同场合佩戴不同的冠。",
        "冠的制作工艺精湛，常用金玉、珠宝等装饰，体现尊贵地位。",
        "冠与服饰的搭配讲究和谐，形成完整的礼仪装束。",
        "除冠外，首服还包括巾、帽等，适应不同场合和身份需求。",
      ],
      images: [
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=traditional%20Chinese%20hanfu%20crown%20(冠)%2C%20elegant%20design%2C%20ceremonial%20headwear%2C%20ancient%20style&image_size=square_hd",
          alt: "冠",
          caption: "汉服冠帽样式",
        },
        {
          url: "https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=Chinese%20imperial%20crown%20(冕冠)%2C%20ceremonial%20headwear%2C%20jade%20beads%2C%20traditional%20design&image_size=square_hd",
          alt: "冕冠",
          caption: "帝王冕冠",
        },
      ],
    },
  },
};

// 显示详情弹窗
const showDetail = async (type, item) => {
  try {
    if (type === "shape") {
      // 从后端获取形制详细信息
      const response = await fetch(`http://localhost:8082/api/shape-type/${item.id}`);
      if (response.ok) {
        const data = await response.json();
        // 解析特点（顿号分隔）
        const features = data.characteristics ? data.characteristics.split("、") : [];
        // 构建图片数组（1-2张）
        const images = [];
        if (data.image) {
          images.push({
            url: data.image,
            alt: data.name,
            caption: data.name,
          });
        }
        // 添加第二张图片
        images.push({
          url: `https://placehold.co/400x300/8B4513/FFFFFF?text=${encodeURIComponent(data.name + "展示")}`,
          alt: data.name + "展示",
          caption: data.name + "展示效果",
        });
        // 构建详细内容
        Object.assign(currentDetail, {
          title: data.name,
          description: data.description,
          period: data.period,
          features: features,
          content: data.content || "",
          images: images,
        });
        dialogVisible.value = true;
      } else {
        ElMessage.error("获取详细信息失败");
      }
    } else if (type === "component") {
      // 从后端获取服饰部件详细信息
      const response = await fetch(`http://localhost:8082/api/component/${item.id}`);
      if (response.ok) {
        const data = await response.json();
        // 构建图片数组（1-2张）
        const images = [];
        if (data.image) {
          images.push({
            url: data.image,
            alt: data.name,
            caption: data.name,
          });
        }
        // 添加第二张图片
        images.push({
          url: `https://placehold.co/400x300/8B4513/FFFFFF?text=${encodeURIComponent(data.name + "展示")}`,
          alt: data.name + "展示",
          caption: data.name + "展示效果",
        });
        // 构建详细内容
        Object.assign(currentDetail, {
          title: `${data.name} - ${data.type}`,
          description: data.description,
          period: "",
          features: data.type ? [data.type] : [],
          content: data.content || "",
          images: images,
        });
        dialogVisible.value = true;
      } else {
        ElMessage.error("获取详细信息失败");
      }
    }
  } catch (error) {
    console.error("获取详细信息失败:", error);
    // 如果后端接口不可用，使用默认数据
    const content = detailContents[type]?.[item.name];
    if (content) {
      Object.assign(currentDetail, {
        title: content.title,
        description: content.content?.[0] || "",
        period: "",
        features: [],
        content: content.content?.slice(1)?.join("\n") || "",
        images: content.images || [],
      });
      dialogVisible.value = true;
    } else {
      ElMessage.info("详细内容正在完善中...");
    }
  }
};

// 关闭弹窗
const handleClose = (done) => {
  done();
};

onMounted(async () => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  window.scrollTo(0, 0);

  // 加载形制分类数据
  await loadShapeTypes();

  // 加载服饰部件数据
  await loadComponents();
});

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "shop") {
    router.push("/shop-profile");
  } else {
    router.push("/profile");
  }
};

const logout = () => {
  localStorage.removeItem("isLoggedIn");
  localStorage.removeItem("username");
  localStorage.removeItem("gender");
  localStorage.removeItem("bio");
  localStorage.removeItem("role");
  ElMessage.success("退出登录成功");
  router.push("/login");
};
</script>

<style scoped>
.shape-classification-container {
  min-height: 100vh;
  background-color: #fef9f3; /* 修改为柔和的米白色背景 */
}

/* 复用头部样式 */
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

.nav-item:hover {
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

/* 主内容区样式 */
.main-content {
  padding: 30px 0;
  min-height: calc(100vh - 160px);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.back-section {
  margin-bottom: 20px;
}

.back-btn {
  color: #8b4513;
  font-size: 14px;
}

.back-btn:hover {
  color: #d2691e;
}

.page-title {
  font-size: 28px;
  margin-bottom: 30px;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
}

.section {
  background-color: white;
  border-radius: 8px;
  padding: 25px;
  margin-bottom: 25px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.section-title {
  font-size: 22px;
  margin-bottom: 20px;
  color: #8b4513;
  display: flex;
  align-items: center;
}

.section-title i {
  margin-right: 8px;
}

/* 概述内容样式 */
.overview-content {
  display: block;
}

.overview-text p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 15px;
  text-align: justify;
}

/* 朝代网格样式 */
.dynasty-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.dynasty-card {
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  padding: 20px;
  background: linear-gradient(135deg, #f9f5f0 0%, #f0e6d6 100%);
  cursor: pointer;
  transition: all 0.3s ease;
}

.dynasty-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 15px rgba(139, 69, 19, 0.15);
  border-color: #d4a76a;
}

.dynasty-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.dynasty-name {
  margin: 0;
  color: #8b4513;
  font-size: 18px;
}

.dynasty-period {
  font-size: 12px;
  color: #999;
  background-color: white;
  padding: 4px 8px;
  border-radius: 4px;
}

.dynasty-desc {
  margin: 0 0 12px 0;
  color: #666;
  line-height: 1.5;
  font-size: 14px;
}

.shape-features {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.feature-tag {
  background-color: #8b4513;
  color: white;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 11px;
}

/* 基本形制样式 */
.shape-types {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.shape-type-card {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 20px;
  background-color: #fafafa;
  cursor: pointer;
  transition: all 0.3s ease;
}

.shape-type-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 15px rgba(139, 69, 19, 0.15);
  border-color: #d4a76a;
}

.shape-type-header {
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.shape-type-header h4 {
  margin: 0;
  color: #8b4513;
  font-size: 16px;
}

.shape-type-content p {
  margin: 0 0 12px 0;
  color: #666;
  line-height: 1.5;
  font-size: 14px;
}

.shape-details {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.detail-item {
  display: flex;
  align-items: flex-start;
}

.detail-label {
  font-size: 12px;
  color: #999;
  min-width: 70px;
}

.detail-value {
  font-size: 12px;
  color: #666;
  flex: 1;
}

/* 服饰部件样式 */
.components-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.component-card {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 15px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  background-color: white;
  transition: all 0.3s ease;
  cursor: pointer;
}

.component-card:hover {
  border-color: #d4a76a;
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.1);
  transform: translateY(-2px);
}

.component-icon {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.component-info {
  flex: 1;
}

.component-info h4 {
  margin: 0 0 6px 0;
  color: #8b4513;
  font-size: 14px;
}

.component-info p {
  margin: 0 0 6px 0;
  color: #666;
  font-size: 12px;
  line-height: 1.4;
}

.component-type {
  font-size: 11px;
  color: #999;
  background-color: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
}

/* 弹窗样式 */
.detail-dialog {
  border-radius: 16px;
}

.detail-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
  padding: 20px;
  margin-right: 0;
}

.detail-dialog :deep(.el-dialog__title) {
  color: white;
  font-size: 22px;
  font-weight: 600;
}

.detail-dialog :deep(.el-dialog__headerbtn .el-dialog__close) {
  color: white;
}

.detail-dialog :deep(.el-dialog__headerbtn:hover .el-dialog__close) {
  color: #f0e6dc;
}

.dialog-content {
  max-height: 65vh;
  overflow-y: auto;
  padding: 10px 5px;
}

/* 区块标签样式 */
.section-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: #8b4513;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid #f0e6dc;
}

.section-label .el-icon {
  font-size: 18px;
}

/* 简介区域 */
.description-section {
  margin-bottom: 20px;
}

.description-text {
  font-size: 16px;
  line-height: 1.8;
  color: #555;
  text-align: justify;
  padding: 15px;
  background: #faf7f4;
  border-radius: 8px;
  border-left: 4px solid #d4a76a;
}

/* 流行时期 */
.period-section {
  margin-bottom: 20px;
}

.period-text {
  font-size: 15px;
  color: #666;
  padding: 10px 15px;
  background: #f5f5f5;
  border-radius: 6px;
  display: inline-block;
}

/* 特点区域 */
.features-section {
  margin-bottom: 20px;
}

.features-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.feature-tag {
  font-size: 14px;
  padding: 6px 12px;
  border-radius: 20px;
}

/* 详细内容区域 */
.content-section {
  margin-bottom: 20px;
}

.content-text {
  padding: 0 5px;
}

.content-text p {
  line-height: 1.9;
  color: #555;
  margin-bottom: 12px;
  text-align: justify;
  font-size: 16px;
}

/* 图片展示区域 */
.image-gallery {
  margin-top: 20px;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 15px;
}

.image-item {
  text-align: center;
}

.detail-image {
  width: 100%;
  height: 160px;
  border-radius: 8px;
  object-fit: cover;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.detail-image:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 16px rgba(139, 69, 19, 0.2);
}

.image-caption {
  margin-top: 10px;
  font-size: 13px;
  color: #666;
  text-align: center;
  font-weight: 500;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 160px;
  background: #f5f7fa;
  color: #909399;
  flex-direction: column;
  border-radius: 8px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}

/* 页脚样式 */
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

/* 响应式设计 */
@media (max-width: 768px) {
  .dynasty-grid {
    grid-template-columns: 1fr;
  }

  .shape-types {
    grid-template-columns: 1fr;
  }

  .components-grid {
    grid-template-columns: repeat(2, 1fr);
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

  .image-grid {
    grid-template-columns: 1fr;
  }

  .detail-dialog {
    width: 90% !important;
  }
}

@media (max-width: 480px) {
  .components-grid {
    grid-template-columns: 1fr;
  }
}
</style>
