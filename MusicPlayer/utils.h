#ifndef UTILS_H
#define UTILS_H
#include "Arduino.h"

#define HEARTBEAT_INTERVAL 60000
#define RING_BUFFER_SIZE 32000
#define PLAY_DELAY_RATE 0.1

#define INIT_STATE 0
#define GETID_STATE 1
#define REQUESTING_MUSIC_STATE 2
#define RECEIVING_STATE 3
#define PLAYING_STATE 4
#define STOP_STATE 5
#define RECONNECT_STATE 6
#define RECEVINGID_STATE 7

static bool hasWifi;
static int buttonAState;
static int buttonBState;
static volatile int status;
static uint64_t hb_interval_ms;

static char raw_audio_buffer[AUDIO_CHUNK_SIZE];

#endif