#include "mbed.h"
#include "AZ3166WiFi.h"
#include "Arduino.h"
#include "http_client.h"
#include "AudioClassV2.h"
#include "stm32412g_discovery_audio.h"
#include "RingBuffer.h"
#include "SystemTickCounter.h"
#include "WebSocketClient.h"
#include "AzureIotHub.h"
#include "mbed_memory_status.h"
#include "DevKitMQTTClient.h"
#include "OledDisplay.h"
#include "parson.h"
#include "music.h"
#include "utils.h"
#include "WebSocketUtils.h"

const int SAMPLE_RATE = 8000;
const int SAMPLE_BIT_DEPTH = 16;

static AudioClass &Audio = AudioClass::getInstance();
RingBuffer ringBuffer(RING_BUFFER_SIZE);
char readBuffer[AUDIO_CHUNK_SIZE];
static char emptyAudio[AUDIO_CHUNK_SIZE];

static long playProgress = 0;
static long musicNumberPlayed = 0;
bool receivedNewIDFromHub = false;
bool firstTimeStart = true;

char *sendMsg = NULL;
bool startPlay = false;
Music current_music;
Music next_music;

#define STOP_WORD_IDX 5
#define PLAY_WORD_IDX 3
#define JUMP_WORD_IDX 2

void initWiFi() {
    Screen.print("IoT DevKit\r\n \r\nConnecting...\r\n");

    if (WiFi.begin() == WL_CONNECTED) {
        IPAddress ip = WiFi.localIP();
        Screen.print(1, ip.get_address());
        hasWifi = true;
        Screen.print(2, "Running... \r\n");
    } else {
        Screen.print(1, "No Wi-Fi\r\n ");
    }
}

void play() {
    printf("start playing %s\n", current_music.music_name);
    enterPlayingState();
    Audio.startPlay(playCallback);
    startPlay = true;
}

void stop() {
    printf("stop()\n");
    Audio.stopPlaying();
    Audio.writeToPlayBuffer(emptyAudio, AUDIO_CHUNK_SIZE);
    startPlay = false;
}

void playCallback(void) {
    if (ringBuffer.use() < AUDIO_CHUNK_SIZE) {
        Audio.writeToPlayBuffer(emptyAudio, AUDIO_CHUNK_SIZE);
        return;
    }
    ringBuffer.get((uint8_t*)readBuffer, AUDIO_CHUNK_SIZE);
    Audio.writeToPlayBuffer(readBuffer, AUDIO_CHUNK_SIZE);
}

void setResponseBodyCallback(const char *data, size_t dataSize) {
    while (ringBuffer.available() < dataSize) {
        delay(10);
    }

    ringBuffer.put((uint8_t*) data, dataSize);
    if (ringBuffer.use() > RING_BUFFER_SIZE * PLAY_DELAY_RATE && startPlay == false) {
        play();
    }
}

static void HubMessageCallback(const char *message, int len)
{
    printf("HubMessageCallback\n");
    JSON_Value *root_value;
    root_value = json_parse_string(message);
    JSON_Object *root_object = json_value_get_object(root_value);
    JSON_Object *next_musicObj = json_object_get_object(root_object, "next");
    JSON_Object *current_musicObj = json_object_get_object(root_object, "current");
    if (next_musicObj != NULL) {
        freeMusicObj(next_music);
        next_music.music_id = json_object_get_number(next_musicObj, "music_id");
        next_music.music_name = strdup(json_object_get_string(next_musicObj, "music_name"));
        next_music.artist = strdup(json_object_get_string(next_musicObj, "artist"));
        next_music.size = json_object_get_number(next_musicObj, "size");
    }
    if (current_musicObj != NULL) {
        freeMusicObj(current_music);
        current_music.music_id = json_object_get_number(current_musicObj, "music_id");
        current_music.music_name = strdup(json_object_get_string(current_musicObj, "music_name"));
        current_music.artist = strdup(json_object_get_string(current_musicObj, "artist"));
        current_music.size = json_object_get_number(current_musicObj, "size");
    }
    printf("%s\n", current_music.music_name);
    delete message;
    json_value_free(root_value);
    receivedNewIDFromHub = true;
}

void enterIdleState() {
    status = INIT_STATE;
    Screen.clean();
    Screen.print(0, "Press A to start...");
}

void enterGetIDState() {
    status = GETID_STATE;
    Screen.clean();
    Screen.print(0, "Connecting to Hub...");
}
void enterReceiveIDState() {
    status = RECEVINGID_STATE;
    Screen.clean();
    Screen.print(0, "Receiving new music info...");
}

void enterRequestingMusicState() {
    status = REQUESTING_MUSIC_STATE;
    Screen.clean();
    Screen.print(0, "Requesting...");
}

void enterReceivingState() {
    status = RECEIVING_STATE;
    Screen.clean();
    Screen.print(0, "Receiving...");
}

void enterPlayingState() {
    status = PLAYING_STATE;
    Screen.clean();
    Screen.print(0, "Playing...");
    Screen.print(1, current_music.music_name);
    Screen.print(2, "Next:");
    Screen.print(3, next_music.music_name);
}
bool playComplete = true;
void enterJumpNextState() {
    Screen.clean();
    Screen.print(0, "Jumping to next");
    playComplete = true;
    enterGetIDState();
}
void enterStopState() {
    status = STOP_STATE;
    Screen.print(0, "Stopped...");
}
void getMusicBuffer(long musicID) {
    memcpy(websocketBuffer, &musicID, sizeof(long));
    memcpy(websocketBuffer + sizeof(long), &playProgress, sizeof(long));
    wsClient -> send(websocketBuffer, sizeof(long) * 2, WS_Message_Binary, true);
}
void setup() {
    Screen.init();
    Screen.print(0, "IoT DevKit");
    Screen.print(2, "Initializing...");

    Screen.print(3, " > Serial");
    //Serial.begin(115200);
    Serial1.begin(115200);
    // Initialize the WiFi module
    Screen.print(3, " > WiFi");
    hasWifi = false;
    initWiFi();
    if (!hasWifi) {
        return;
    }
    DevKitMQTTClient_SetOption(OPTION_MINI_SOLUTION_NAME, "SmartRadio");
    DevKitMQTTClient_SetMessageCallback(HubMessageCallback);
    DevKitMQTTClient_Init(true);
    memset(emptyAudio, 0x0, AUDIO_CHUNK_SIZE);
    pinMode(USER_BUTTON_A, INPUT);
    pinMode(USER_BUTTON_B, INPUT);
    if (!isWsConnected) {
        isWsConnected = connectWebSocket();
    }
    if (!isWsConnected) return;
    enterIdleState();
    // Audio.format(SAMPLE_RATE, SAMPLE_BIT_DEPTH);
}

void loop() {
    if (hasWifi) {
        doWork();
    }
}

void doWork() {
    switch (status) {
        // Idle
    case INIT_STATE:
        {
            buttonAState = digitalRead(USER_BUTTON_A);
            if (buttonAState == LOW) {
                enterGetIDState();
            }
            break;
        }
    // Get ID state
    case GETID_STATE:
        {
            if (!isWsConnected) {
                isWsConnected = connectWebSocket();
            }
            receivedNewIDFromHub = false;
            musicNumberPlayed++;
            if (sendMsg != NULL)
                free(sendMsg);
            if (firstTimeStart) {
                sendMsg = strdup("{\"firstTime\":true}");
                firstTimeStart = false;
            } else {
                const char* payLoadFormat = "{\"music_id\":%d, \"play_progress\":%f}";
                float playRatio = (float)playProgress / (float)current_music.size;
                printf("Play_progress:%f = %d / %d", playRatio, playProgress, current_music.size);
                int strSize = sprintf(NULL, payLoadFormat, current_music.music_id, playRatio);
                sendMsg = (char*)malloc(strSize + 1);
                sprintf(sendMsg, payLoadFormat, current_music.music_id, playRatio);
                freeMusicObj(current_music);
                current_music.music_id = next_music.music_id;
                current_music.music_name = strdup(next_music.music_name);
                current_music.artist = strdup(next_music.artist);
                current_music.size = next_music.size;
            }
            
            if (DevKitMQTTClient_SendEvent(sendMsg)) {
                printf("Request send to iothub success\n");
            }
            enterReceiveIDState();
            break;
        }
    case RECEVINGID_STATE:
        {
            DevKitMQTTClient_Check(false);
            if (receivedNewIDFromHub) {
                printf("Song id is sent to WS Server.\n");
                enterRequestingMusicState();
                playProgress = 0;
            }
            break;
        }
        // Receiving and playing
    case REQUESTING_MUSIC_STATE:
        {
            while (Serial1.read() != -1) {
                
            }
            getMusicBuffer(current_music.music_id);
            printf("Play progress:%d\n", playProgress);
            bool isEndOfMessage = false;
            WebSocketReceiveResult *recvResult = NULL;
            int len = 0;
            printf("Receiving message\n");
            printf("Total music played: %d\n", musicNumberPlayed);
            
            while (!isEndOfMessage) { 
                int incomingByte = Serial1.read();
                if (incomingByte == STOP_WORD_IDX) {
                // if (digitalRead(USER_BUTTON_A) == LOW) {
                //     do {
                //     } while (digitalRead(USER_BUTTON_A) == LOW);
                    enterStopState();
                    stop();
                    playComplete = false;
                    break;
                } 
                else if (incomingByte == JUMP_WORD_IDX) {
                // else if (digitalRead(USER_BUTTON_B) == LOW) {
                //     do {
                //     } while (digitalRead(USER_BUTTON_B) == LOW);
                    stop();
                    enterJumpNextState();
                    break;
                } else {
                    recvResult = wsClient -> receive(websocketBuffer, sizeof(websocketBuffer));
                    if (recvResult != NULL && recvResult -> length > 0) {
                        len = recvResult -> length;
                        isEndOfMessage = recvResult -> isEndOfMessage;
                        setResponseBodyCallback(websocketBuffer, len);
                        playProgress += len;
                    } else {
                        printf("Receive NULL, resend request\n");
                        if (connectWebSocket()) {
                            printf("reconnect success\n");
                        }
                        playComplete = false;
                        break;
                    }
                }
            };
            memset(websocketBuffer, 0, sizeof(websocketBuffer));
            
            if (!playComplete) break;
            while (ringBuffer.use() >= AUDIO_CHUNK_SIZE) {
                printf("delaying\n");
                ringBuffer.get((uint8_t*)readBuffer, AUDIO_CHUNK_SIZE);
            }
            closeWebSocket();
            delete recvResult;
            enterGetIDState();
            break;
        }
    case STOP_STATE:
        {
            int incomingByte = Serial1.read();
            if (incomingByte == PLAY_WORD_IDX) {
                printf("Restart\n");
                enterRequestingMusicState();
                break;
            }
            else if (incomingByte == JUMP_WORD_IDX) {
                closeWebSocket();
                enterJumpNextState();
                break;
            }
            break;
        }

    }
}