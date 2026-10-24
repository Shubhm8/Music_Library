package com.music.user.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.music.user.entity.Payment;
import com.music.user.entity.User;
import com.music.user.repository.PaymentRepository;
import com.music.user.repository.UserRepository;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Map;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RazorpayService {
    private final PaymentRepository payments;
    private final ObjectMapper mapper;
    private final HttpClient client = HttpClient.newHttpClient();
    private final String keyId;
    private final String keySecret;
    private final int pricePaise;
    private final String webhookSecret;
    private final UserRepository users;

    public RazorpayService(PaymentRepository payments, UserRepository users, ObjectMapper mapper,
            @Value("${razorpay.key-id:}") String keyId,
            @Value("${razorpay.key-secret:}") String keySecret,
            @Value("${premium.monthly-price-paise:9900}") int pricePaise,
            @Value("${razorpay.webhook-secret:}") String webhookSecret) {
        this.payments = payments; this.users = users; this.mapper = mapper; this.keyId = keyId;
        this.keySecret = keySecret; this.pricePaise = pricePaise;
        this.webhookSecret = webhookSecret;
    }

    public Map<String, Object> createOrder(User user) throws Exception {
        requireConfigured();
        String receipt = "premium_" + user.getUserId() + "_" + System.currentTimeMillis();
        String payload = mapper.writeValueAsString(Map.of("amount", pricePaise, "currency", "INR", "receipt", receipt));
        JsonNode order = request("POST", "/v1/orders", payload);
        Payment payment = new Payment();
        payment.setUserId(user.getUserId()); payment.setRazorpayOrderId(order.path("id").asText());
        payment.setAmountPaise(pricePaise); payments.save(payment);
        return Map.of("keyId", keyId, "orderId", payment.getRazorpayOrderId(), "amount", pricePaise,
                "currency", "INR", "plan", "PREMIUM_MONTHLY");
    }

    public int getPricePaise() { return pricePaise; }

    @Transactional
    public void handleWebhook(String body, String signature) throws Exception {
        if (webhookSecret.isBlank() || !MessageDigest.isEqual(hmac(body, webhookSecret).getBytes(StandardCharsets.UTF_8), signature.getBytes(StandardCharsets.UTF_8))) throw new IllegalArgumentException("Invalid webhook signature");
        JsonNode entity = mapper.readTree(body).path("payload").path("payment").path("entity");
        if (!"captured".equals(entity.path("status").asText())) return;
        Payment payment = payments.findByRazorpayOrderId(entity.path("order_id").asText()).orElseThrow(() -> new IllegalArgumentException("Unknown order"));
        if ("CAPTURED".equals(payment.getStatus())) return;
        payment.setRazorpayPaymentId(entity.path("id").asText()); payment.setStatus("CAPTURED");
        User user = users.findById(payment.getUserId()).orElseThrow();
        LocalDateTime start = user.getPremiumUntil() != null && user.getPremiumUntil().isAfter(LocalDateTime.now()) ? user.getPremiumUntil() : LocalDateTime.now();
        user.setPremiumUntil(start.plusDays(30));
    }

    @Transactional
    public void verifyAndActivate(User user, String orderId, String paymentId, String signature) throws Exception {
        Payment payment = payments.findByRazorpayOrderId(orderId).orElseThrow(() -> new IllegalArgumentException("Unknown order"));
        if (!payment.getUserId().equals(user.getUserId()) || !"CREATED".equals(payment.getStatus())) throw new IllegalArgumentException("Invalid order state");
        String expected = hmac(orderId + "|" + paymentId);
        if (!MessageDigest.isEqual(expected.getBytes(StandardCharsets.UTF_8), signature.getBytes(StandardCharsets.UTF_8))) throw new IllegalArgumentException("Invalid payment signature");
        if (!"captured".equals(request("GET", "/v1/payments/" + paymentId, null).path("status").asText())) throw new IllegalStateException("Payment is not captured");
        payment.setRazorpayPaymentId(paymentId); payment.setStatus("CAPTURED");
        LocalDateTime start = user.getPremiumUntil() != null && user.getPremiumUntil().isAfter(LocalDateTime.now()) ? user.getPremiumUntil() : LocalDateTime.now();
        user.setPremiumUntil(start.plusDays(30));
    }

    private JsonNode request(String method, String path, String body) throws Exception {
        HttpRequest.Builder request = HttpRequest.newBuilder(URI.create("https://api.razorpay.com" + path))
                .header("Authorization", "Basic " + Base64.getEncoder().encodeToString((keyId + ":" + keySecret).getBytes(StandardCharsets.UTF_8)))
                .header("Content-Type", "application/json");
        request.method(method, body == null ? HttpRequest.BodyPublishers.noBody() : HttpRequest.BodyPublishers.ofString(body));
        HttpResponse<String> response = client.send(request.build(), HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) throw new IllegalStateException("Razorpay request failed");
        return mapper.readTree(response.body());
    }
    private String hmac(String value) throws Exception { Mac mac = Mac.getInstance("HmacSHA256"); mac.init(new SecretKeySpec(keySecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256")); return java.util.HexFormat.of().formatHex(mac.doFinal(value.getBytes(StandardCharsets.UTF_8))); }
    private String hmac(String value, String secret) throws Exception { Mac mac = Mac.getInstance("HmacSHA256"); mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256")); return java.util.HexFormat.of().formatHex(mac.doFinal(value.getBytes(StandardCharsets.UTF_8))); }
    private void requireConfigured() { if (keyId.isBlank() || keySecret.isBlank()) throw new IllegalStateException("Razorpay is not configured"); }
}
