package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.EnableCaching;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/api/ai")
@CrossOrigin
@EnableCaching
public class AiChatController {

    private static final String ZHIPU_API_URL = "https://open.bigmodel.cn/api/paas/v4/chat/completions";
    private static final String API_KEY = "f304f38c6b7e40ef9df0dcfa466e52e1.2uec8dfmMumS7AC2";
    private static final String MODEL = "glm-4-flash";
    
    private final RestTemplate restTemplate;
    private final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION = TimeUnit.MINUTES.toMillis(30);

    public AiChatController() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(10000);
        factory.setReadTimeout(30000);
        this.restTemplate = new RestTemplate(factory);
    }

    @PostMapping("/chat")
    public Map<String, Object> chat(@RequestBody Map<String, String> request) {
        String question = request.getOrDefault("question", "").trim();
        Map<String, Object> response = new HashMap<>();

        if (question.isEmpty()) {
            response.put("answer", "请输入您想了解的汉服相关问题～");
            response.put("success", true);
            return response;
        }

        try {
            String answer = getAnswer(question);
            response.put("answer", answer);
            response.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("answer", "AI服务暂时不可用，请稍后再试～");
            response.put("success", false);
        }

        return response;
    }

    private String getAnswer(String question) {
        String cacheKey = question.toLowerCase().trim();
        
        CacheEntry cached = (CacheEntry) cache.get(cacheKey);
        if (cached != null && System.currentTimeMillis() - cached.timestamp < CACHE_DURATION) {
            return cached.answer;
        }

        String answer = callZhipuApi(question);
        cache.put(cacheKey, new CacheEntry(answer, System.currentTimeMillis()));
        return answer;
    }

    private String callZhipuApi(String question) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + API_KEY);

        Map<String, Object> systemMessage = new HashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content", "你是一个专业的汉服文化AI助手，专门回答关于汉服的各种问题。" +
                "你的知识涵盖：汉服的朝代形制（汉、唐、宋、明等）、汉服分类（襦裙、袄裙、曲裾、直裾、褙子、圆领袍等）、" +
                "穿搭技巧、配饰搭配、礼仪文化、面料工艺（刺绣、织锦、印染）、汉服保养、汉服活动等。" +
                "请用简洁、友好、专业的语气回答，适当使用emoji让回答更生动。" +
                "如果用户问的问题与汉服无关，请礼貌地引导用户提问汉服相关问题。" +
                "回答要简洁明了，控制在200字以内。");

        Map<String, Object> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", question);

        List<Map<String, Object>> messages = new ArrayList<>();
        messages.add(systemMessage);
        messages.add(userMessage);

        Map<String, Object> body = new HashMap<>();
        body.put("model", MODEL);
        body.put("messages", messages);
        body.put("temperature", 0.7);
        body.put("max_tokens", 512);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        @SuppressWarnings("unchecked")
        Map<String, Object> result = restTemplate.postForObject(ZHIPU_API_URL, entity, Map.class);

        if (result != null && result.containsKey("choices")) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> choices = (List<Map<String, Object>>) result.get("choices");
            if (!choices.isEmpty()) {
                @SuppressWarnings("unchecked")
                Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
                return (String) message.get("content");
            }
        }

        return "抱歉，暂时无法获取回答，请稍后再试～";
    }

    private static class CacheEntry {
        final String answer;
        final long timestamp;

        CacheEntry(String answer, long timestamp) {
            this.answer = answer;
            this.timestamp = timestamp;
        }
    }
}
