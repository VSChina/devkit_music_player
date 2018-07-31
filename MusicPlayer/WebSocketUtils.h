#ifndef WEBSOCKET_UTILS
#define WEBSOCKET_UTILS
#include "Arduino.h"

static char *webAppUrl = "ws://demobotapp20180529011305.azurewebsites.net";
WebSocketClient *wsClient = NULL;
bool isWsConnected = false;
char websocketBuffer[4096];

void sendHeartbeat() {
    if ((int)(SystemTickCounterRead() - hb_interval_ms) < HEARTBEAT_INTERVAL) {
        return;
    }
    // Send haertbeart message
    printf(">>Heartbeat<<\n");
    int ret = wsClient -> send("heartbeat", 9, WS_Message_Text);
    if (ret < 0) {
        // Heartbeat failure, disconnet from WS
        return;
    }

    // Reset heartbeat
    hb_interval_ms = SystemTickCounterRead();
}

char *getWebSocketUrl() {
    char *url;
    url = (char*)malloc(300);

    if (url == NULL) {
        return NULL;
    }
    HTTPClient guidRequest = HTTPClient(HTTP_GET, "http://www.fileformat.info/tool/guid.htm?count=1&format=text&hyphen=true");
    const Http_Response *_response = guidRequest.send();
    if (_response == NULL) {
        printf("Guid generator HTTP request failed.\n");
        return NULL;
    }

    snprintf(url, 300, "%s/chat?nickName=%s", webAppUrl, _response -> body);
    // Serial.print("WebSocket server url: ");
    printf("%s\n", url);
    return url;
}

bool connectWebSocket() {
    Screen.clean();
    Screen.print(0, "Connect to WS...");

    char *webSocketServerUrl = getWebSocketUrl();
    if (wsClient == NULL) {
        wsClient = new WebSocketClient(webSocketServerUrl);
    }

    isWsConnected = wsClient -> connect();
    if (isWsConnected) {
        printf("connect WS successfully.\n");
        Screen.print(1, "connect WS successfully.");

        // Trigger heart beat immediately
        hb_interval_ms = -(HEARTBEAT_INTERVAL);
        sendHeartbeat();
        return true;
    } else {
        Screen.print(1, "Connect WS fail");
        printf("Connect WS fail\n");

        return false;
    }
}

void closeWebSocket() {
    if (wsClient -> close()) {
        delete wsClient;
        wsClient = NULL;
        isWsConnected = false;
    }
}

#endif