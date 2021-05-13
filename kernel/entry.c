#define VIDEO_MEMORY_START 0xb8000;

void entry() {
    char* video_memory = (char*) VIDEO_MEMORY_START;

    *video_memory = 'X';
}
