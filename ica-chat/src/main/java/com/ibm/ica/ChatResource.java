package com.ibm.ica;

import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.Map;

import org.eclipse.microprofile.faulttolerance.Fallback;
import org.eclipse.microprofile.faulttolerance.Retry;
import org.eclipse.microprofile.faulttolerance.Timeout;

import io.quarkus.runtime.Quarkus;
import io.smallrye.mutiny.Multi;

@Path("/api/chat")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ChatResource {

    @Inject
    IcaChatService chatService;

    @Inject
    SessionStore sessionStore;

    public record UserMessage(String message, String sessionId) {}

    /** セッション発行エンドポイント（ページロード時に呼ぶ） */
    @GET
    @Path("/session")
    public Response newSession() {
        String sessionId = sessionStore.create();
        return Response.ok(Map.of("sessionId", sessionId)).build();
    }

    /** 通常レスポンス（リトライ・タイムアウト・フォールバック付き） */
    @POST
    @Retry(maxRetries = 2, delay = 500)
    @Timeout(value = 120000)
    @Fallback(fallbackMethod = "chatFallback")
    public Response chat(UserMessage input) {
        if (!sessionStore.isValid(input.sessionId())) {
            return Response.status(403)
                .entity(Map.of("error", "無効なセッションです。ページを再読み込みしてください。"))
                .build();
        }
        String content = chatService.chat(input.sessionId(), input.message());
        return Response.ok(Map.of("content", content, "sessionId", input.sessionId())).build();
    }

    public Response chatFallback(UserMessage input) {
        return Response.status(503).entity(
            Map.of("error", "AIサービスに接続できませんでした。しばらく待ってから再試行してください。")
        ).build();
    }

    /** ストリーミングレスポンス */
    @POST
    @Path("/stream")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public Multi<String> chatStream(UserMessage input) {
        if (!sessionStore.isValid(input.sessionId())) {
            return Multi.createFrom().failure(
                new SecurityException("無効なセッションです。ページを再読み込みしてください。")
            );
        }
        return chatService.chatStream(input.sessionId(), input.message());
    }

    @POST
    @Path("/shutdown")
    public Response shutdown() {
        new Thread(() -> {
            try { Thread.sleep(300); } catch (InterruptedException ignored) {}
            Quarkus.asyncExit(0);
        }).start();
        return Response.ok(Map.of("message", "サーバーを停止します")).build();
    }
}
