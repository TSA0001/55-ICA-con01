package com.ibm.ica;

import dev.langchain4j.service.MemoryId;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.smallrye.mutiny.Multi;
import jakarta.enterprise.context.ApplicationScoped;

// @ApplicationScoped にすることでリクエスト終了後もメモリが保持される
@RegisterAiService
@ApplicationScoped
public interface IcaChatService {

    @SystemMessage("あなたは親切で丁寧なAIアシスタントです。日本語で回答してください。")
    String chat(@MemoryId String sessionId, @UserMessage String message);

    @SystemMessage("あなたは親切で丁寧なAIアシスタントです。日本語で回答してください。")
    Multi<String> chatStream(@MemoryId String sessionId, @UserMessage String message);

}
