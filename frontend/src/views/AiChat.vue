<template>
  <div class="ai-chat-container">
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
          <li class="nav-item active">AI问答</li>
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
        <h2 class="page-title">AI问答助手</h2>
        <p class="page-desc">
          我是汉服文化AI助手，可以回答关于汉服形制、穿搭、礼仪、面料等方面的问题～
        </p>

        <div class="chat-container">
          <div class="chat-messages" ref="chatMessagesRef">
            <div
              v-for="(msg, index) in chatMessages"
              :key="index"
              :class="['chat-message', msg.role === 'user' ? 'user-message' : 'ai-message']"
            >
              <div class="message-avatar">
                <span v-if="msg.role === 'user'">👤</span>
                <span v-else>🤖</span>
              </div>
              <div class="message-content">
                <div class="message-text" v-html="formatMessage(msg.content)"></div>
                <div class="message-time">{{ msg.time }}</div>
              </div>
            </div>
            <div v-if="aiLoading" class="chat-message ai-message">
              <div class="message-avatar"><span>🤖</span></div>
              <div class="message-content">
                <div class="message-text typing">思考中...</div>
              </div>
            </div>
          </div>

          <div class="chat-input-area">
            <div class="quick-questions">
              <span class="quick-label">快捷提问：</span>
              <el-tag
                v-for="q in quickQuestions"
                :key="q"
                size="small"
                class="quick-tag"
                @click="sendQuickQuestion(q)"
                >{{ q }}</el-tag
              >
            </div>
            <div class="chat-input-row">
              <el-input
                v-model="chatInput"
                placeholder="请输入您的汉服相关问题..."
                @keyup.enter="sendMessage"
                :disabled="aiLoading"
                size="large"
              />
              <el-button type="primary" @click="sendMessage" :loading="aiLoading" size="large"
                >发送</el-button
              >
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="footer">
      <div class="container">
        <p>汉服文化交流平台</p>
        <p class="footer-subtitle">传承华夏衣冠，弘扬汉服文化</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";

const router = useRouter();
const username = ref("");
const chatInput = ref("");
const aiLoading = ref(false);
const chatMessagesRef = ref(null);

function getCurrentTime() {
  const now = new Date();
  return `${now.getHours().toString().padStart(2, "0")}:${now.getMinutes().toString().padStart(2, "0")}`;
}

const chatMessages = ref([
  {
    role: "ai",
    content:
      "您好！我是汉服文化AI助手 🏮\n\n我可以为您解答以下方面的问题：\n\n🏛️ 朝代形制：各朝代汉服特点与区别\n👘 汉服分类：襦裙、袄裙、曲裾、直裾等\n🎀 穿搭技巧：日常穿搭、配饰搭配\n🙏 礼仪文化：传统礼仪、场合着装\n🧵 面料工艺：刺绣、织锦、印染等\n\n请随时向我提问吧～",
    time: getCurrentTime(),
  },
]);

const quickQuestions = ref([
  "襦裙是什么",
  "唐代汉服有哪些特点",
  "新手入门推荐",
  "汉服怎么保养",
  "马面裙的历史",
]);

onMounted(() => {
  const savedUsername = localStorage.getItem("username");
  if (savedUsername) {
    username.value = savedUsername;
  }
  loadMessagesFromStorage();
  scrollToBottom();
});

const formatMessage = (text) => {
  return text.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>").replace(/\n/g, "<br>");
};

const scrollToBottom = () => {
  nextTick(() => {
    if (chatMessagesRef.value) {
      chatMessagesRef.value.scrollTop = chatMessagesRef.value.scrollHeight;
    }
  });
};

const sendMessage = async () => {
  const question = chatInput.value.trim();
  if (!question || aiLoading.value) return;

  chatMessages.value.push({
    role: "user",
    content: question,
    time: getCurrentTime(),
  });
  chatInput.value = "";
  aiLoading.value = true;
  scrollToBottom();

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 30000);

    const response = await fetch("http://localhost:8082/api/ai/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ question }),
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    chatMessages.value.push({
      role: "ai",
      content: data.answer || "抱歉，暂时无法回答您的问题。",
      time: getCurrentTime(),
    });
    saveMessagesToStorage();
  } catch (error) {
    console.error("AI问答请求失败", error);
    let errorMessage = "网络异常，请稍后再试～";
    if (error.name === "AbortError") {
      errorMessage = "请求超时，请稍后再试～";
    }
    chatMessages.value.push({
      role: "ai",
      content: errorMessage,
      time: getCurrentTime(),
    });
  } finally {
    aiLoading.value = false;
    scrollToBottom();
  }
};

const sendQuickQuestion = (question) => {
  chatInput.value = question;
  sendMessage();
};

const saveMessagesToStorage = () => {
  try {
    localStorage.setItem("chatMessages", JSON.stringify(chatMessages.value));
  } catch (e) {
    console.error("保存消息失败", e);
  }
};

const loadMessagesFromStorage = () => {
  try {
    const saved = localStorage.getItem("chatMessages");
    if (saved) {
      chatMessages.value = JSON.parse(saved);
    }
  } catch (e) {
    console.error("加载消息失败", e);
  }
};

const clearChatHistory = () => {
  chatMessages.value = [
    {
      role: "ai",
      content:
        "您好！我是汉服文化AI助手 🏮\n\n我可以为您解答以下方面的问题：\n\n🏛️ 朝代形制：各朝代汉服特点与区别\n👘 汉服分类：襦裙、袄裙、曲裾、直裾等\n🎀 穿搭技巧：日常穿搭、配饰搭配\n🙏 礼仪文化：传统礼仪、场合着装\n🧵 面料工艺：刺绣、织锦、印染等\n\n请随时向我提问吧～",
      time: getCurrentTime(),
    },
  ];
  saveMessagesToStorage();
};

const goToProfile = () => {
  const role = localStorage.getItem("role");
  if (role === "2") {
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
.ai-chat-container {
  height: 100vh;
  background-color: #f5f5f5;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

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

.nav-item:hover,
.nav-item.active {
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
  flex: 1;
  padding: 20px 0;
  overflow: hidden;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  flex-direction: column;
  height: 100%;
}

.page-title {
  font-size: 24px;
  margin: 0 0 6px 0;
  color: #8b4513;
  border-left: 4px solid #d4a76a;
  padding-left: 12px;
  flex-shrink: 0;
}

.page-desc {
  color: #999;
  font-size: 13px;
  margin: 0 0 12px 0;
  flex-shrink: 0;
}

.chat-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  border: 1px solid #e8e8e8;
  border-radius: 12px;
  overflow: hidden;
  background: #f9f9f9;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  min-height: 0;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.chat-message {
  display: flex;
  gap: 10px;
  max-width: 80%;
}

.user-message {
  align-self: flex-end;
  flex-direction: row-reverse;
}

.ai-message {
  align-self: flex-start;
}

.message-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  flex-shrink: 0;
}

.user-message .message-avatar {
  background: #e8d5c0;
}

.ai-message .message-avatar {
  background: #d5e8d4;
}

.message-content {
  display: flex;
  flex-direction: column;
}

.message-text {
  padding: 12px 16px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.7;
  word-break: break-word;
}

.user-message .message-text {
  background: #8b4513;
  color: white;
  border-top-right-radius: 4px;
}

.ai-message .message-text {
  background: white;
  color: #333;
  border-top-left-radius: 4px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
}

.message-time {
  font-size: 11px;
  color: #bbb;
  margin-top: 4px;
  padding: 0 4px;
}

.user-message .message-time {
  text-align: right;
}

.typing {
  color: #999;
  font-style: italic;
}

.chat-input-area {
  padding: 14px 20px;
  background: white;
  border-top: 1px solid #e8e8e8;
}

.quick-questions {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  flex-wrap: wrap;
}

.quick-label {
  font-size: 12px;
  color: #999;
  white-space: nowrap;
}

.quick-tag {
  cursor: pointer;
  transition: all 0.3s;
}

.quick-tag:hover {
  background-color: #8b4513;
  color: white;
  border-color: #8b4513;
}

.chat-input-row {
  display: flex;
  gap: 10px;
}

.chat-input-row .el-button {
  background-color: #8b4513;
  border-color: #8b4513;
}

.chat-input-row .el-button:hover {
  background-color: #a0522d;
  border-color: #a0522d;
}

@media (max-width: 768px) {
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
  .chat-message {
    max-width: 90%;
  }
}

.footer {
  background: linear-gradient(135deg, #8b4513 0%, #d2691e 100%);
  color: white;
  text-align: center;
  padding: 20px 0;
  margin-top: 30px;
}
</style>
