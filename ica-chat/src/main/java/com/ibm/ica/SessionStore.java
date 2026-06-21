package com.ibm.ica;

import jakarta.enterprise.context.ApplicationScoped;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

@ApplicationScoped
public class SessionStore {

    // 最大1000セッションを保持（古いものから削除）
    private static final int MAX_SESSIONS = 1000;

    private final Map<String, Long> sessions = Collections.synchronizedMap(
        new LinkedHashMap<>(MAX_SESSIONS, 0.75f, true) {
            @Override
            protected boolean removeEldestEntry(Map.Entry<String, Long> eldest) {
                return size() > MAX_SESSIONS;
            }
        }
    );

    /** 新しいセッションIDを発行してサーバーに登録 */
    public String create() {
        String sessionId = UUID.randomUUID().toString();
        sessions.put(sessionId, System.currentTimeMillis());
        return sessionId;
    }

    /** サーバーが発行した正規のセッションIDか検証 */
    public boolean isValid(String sessionId) {
        return sessionId != null && sessions.containsKey(sessionId);
    }
}
