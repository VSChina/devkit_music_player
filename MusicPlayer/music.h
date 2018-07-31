#ifndef MUSIC_H
#define MUSIC_H
#include "mbed.h"
struct Music {
    long music_id;
    char* music_name = NULL;
    char* artist = NULL;
    int size;
};

void freeMusicObj(Music &music) {
    if (music.music_name != NULL)
        free(music.music_name);
    if (music.artist != NULL)
        free(music.artist);
}
#endif