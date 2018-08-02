#include <stdio.h>
#include <math.h>
#include <vector>
#include "SimpleTimer.h"
#include "Arduino.h"
#include "OledDisplay.h"
#include "AudioClassV2.h"
#include "featurizer.h"
#include "classifier.h"
#include "SystemTickCounter.h"

AudioClass& Audio = AudioClass::getInstance();

int lastButtonAState;
int buttonAState;

enum AppState 
{
  APPSTATE_Init,
  APPSTATE_Error,
  APPSTATE_Recording
};

extern "C" {
  void clock_gettime(clock_t clock, struct timespec* tm)
  {
    uint64_t now = SystemTickCounterRead();
    tm->tv_sec = now / 1000;
    tm->tv_nsec = (now - 1000 * tm->tv_sec) * 1000000;
  }
}

static AppState appstate;

// These numbers need to match the compiled ELL models.
const int SAMPLE_RATE = 8000;
const int SAMPLE_BIT_DEPTH = 16;
const int FEATURIZER_INPUT_SIZE = 256;
const int FRAME_RATE = 33; // assumes a "shift" of 256 and 256/8000 = 0.032ms per frame.
const int FEATURIZER_OUTPUT_SIZE = 40;
const int CLASSIFIER_OUTPUT_SIZE = 6;

static int scaled_input_buffer_pos = 0;
static float scaled_input_buffer[FEATURIZER_INPUT_SIZE]; // raw audio converted to float

const int MAX_FEATURE_BUFFERS = 10; // set to buffer up to 1 second of audio in circular buffer
static float featurizer_input_buffers[MAX_FEATURE_BUFFERS][FEATURIZER_INPUT_SIZE]; // input to featurizer
static int featurizer_input_buffer_read = -1; // next read pos
static int featurizer_input_buffer_write = 0; // next write pos
static int dropped_frames = 0;
static float featurizer_output_buffer[FEATURIZER_OUTPUT_SIZE]; // 40 channels
static float classifier_output_buffer[CLASSIFIER_OUTPUT_SIZE]; // 31 classes

const float PREDICT_PROB_THRESHOLD = 0.95;

#define SMOOTHING 0
#if SMOOTHING
const int SMOOTHING_WINDOW_SIZE = 3;
static float smoothing_window[SMOOTHING_WINDOW_SIZE][CLASSIFIER_OUTPUT_SIZE];
static int smoothing_window_pos = 0;
#else
const int SMOOTHING_WINDOW_SIZE = 1;
#endif
static int raw_audio_count = 0;
static char raw_audio_buffer[AUDIO_CHUNK_SIZE];
static int prediction_count = 0;
static int last_prediction = 0;
static int last_confidence = 0;
static int predictionVar = 0;
int next(int pos){
  pos++;
  if (pos == MAX_FEATURE_BUFFERS){
    pos = 0;
  }
  return pos;
}
static const char* const categories[] = {
    "background_noise",
    "back_ground",
    "go",
    "on",
    "unknown",
    "stop"
};

#define STOP_WORD_IDX 2
#define PLAY_WORD_IDX 3
#define JUMP_WORD_IDX 5

int getPredictWordId(int x) {
  if (x == 2) return JUMP_WORD_IDX;
  if (x == 3) return PLAY_WORD_IDX;
  if (x == 5) return STOP_WORD_IDX;
  return 0;
}

bool isPlaying = true;
/// <summary> This class implements the Energy Normalization algorithm described in the following paper:
/// https://pdfs.semanticscholar.org/b442/f1b5d766d7db4916c7c32f9558cf2ce77ea5.pdf. </summary>
class EnergyNormalizer
{
  bool _initialized = false; 
  float _ePrevious = 0; // previous energy level
  float _ePeakSilent = 0; // energy peak for silence at n-th frame
  float _ePeakVoice = 0; // energy peak for voice activity at n-th frame
  float _gammaUpSilent = 0.85; // gamma to use when energy is rising but no voice activity
  float _gammaDownSilent = 0.95; // gamma to use when energy is falling, still no voice activity
  float _gammaUpVad = 0.80;  // gamma to use when energy is rising with voice activity
  float _gammaDownVad = 0.90; // gamma to use when energy is falling with voice activity
  float _minimum = 0.01; // silence
  float _maxEnergy = 0.5;
  int _vad = 0; // voice activity detected
  int _count = 0;
  int _delay = 0; // hold VAD for this minimum number of frames 
  double _gain = 0;
  double _epn = 0;

  public:
    EnergyNormalizer(float fps)
    {
      _delay = fps / 10; // 100 ms delay is good.
      reset();
    }

    void reset(){
      _ePrevious = _ePeakSilent = _ePeakVoice = 0;
      _initialized = false;
      _vad = 0;
      _count = 0;
      _gain = 0;
      _epn = 0;
    }
    
    /// <summary> process new energy level 'e'  </summary>
    float process(float e)
    {
        float peak = e;
        if (!_initialized || e <= _minimum)
        {
            _ePeakVoice = e;
            _ePeakSilent = e;
            _initialized = true;
        }
        else
        {
            float gamma_voice = 0;
            float gamma_silence = 0;
            if (e > _ePrevious) // energy is rising
            {
                gamma_voice = _gammaUpVad;
                gamma_silence = _gammaUpSilent;
            }
            else
            {
                gamma_voice = _gammaDownVad;
                gamma_silence = _gammaDownSilent;
            }
            _ePeakVoice = gamma_voice * _ePeakVoice + (1 - gamma_voice) * e;
            _ePeakSilent = gamma_silence * _ePeakSilent + (1 - gamma_silence) * e;
            if (_ePeakVoice > _ePeakSilent || (_vad && _count < _delay))
            {
                // voice activity detected
                peak = _ePeakVoice;
                _vad = 1;
                _count++;                
            }
            else 
            {
                peak = _ePeakSilent;
                _vad = 0;
                _count = 0;
            }
        }
        _ePrevious = e;
        return peak;
    }

    void apply_gain(float* buffer, int len)
    {
      // get the mean energy
      float e = 0;
      float maximum = 0;
      for(int i = 0; i < len; i++)
      {
        float f = buffer[i];
        e += abs(f);
        if (f > maximum) {
          maximum = f;
        }
      }
      e /= len;
      
      float ePn = this->process(e);
      int signal = this->getVad();
      float gain = 1;
      if (ePn != 0)
      {
        gain = 1 / ePn;
        if (gain * maximum > _maxEnergy)
        {
          gain = _maxEnergy / maximum; // avoid clipping.
        }
      }

      _gain = gain;
      _epn = ePn;

      for (int i = 0; i < len; ++i)
      {
        buffer[i] *= gain;
      }
    }

    int getVad() { return _vad; }
    double getGain() { return _gain; }
    double getEpn() { return _epn; }
};

EnergyNormalizer normalizer(FRAME_RATE);

void setup(void)
{
  SimpleTimer::init();
  appstate = APPSTATE_Init;
  stop_recording();
  Serial.begin(115200);
  Serial1.begin(115200);
  // Initialize the button pin as a input
  pinMode(USER_BUTTON_A, INPUT);
  lastButtonAState = digitalRead(USER_BUTTON_A);
  int filter_size = mfcc_GetInputSize();
  if (filter_size != FEATURIZER_INPUT_SIZE)
  {
    Serial.printf("Featurizer input size %d is not equal to %d\n", filter_size, FEATURIZER_INPUT_SIZE);
    show_error("Featurizer Error");
  }
  else 
  {
    int model_size = model_GetInputSize();
    if (model_size != FEATURIZER_OUTPUT_SIZE)
    {
      Serial.printf("Classifier input size %d is not equal to %d\n", model_size, FEATURIZER_OUTPUT_SIZE);
      show_error("Classifier Error");
    }
    else {

      int model_output_size = model_GetOutputSize();
      if (model_output_size != CLASSIFIER_OUTPUT_SIZE)
      {
        Serial.printf("Classifier output size %d is not equal to %d\n", model_output_size, CLASSIFIER_OUTPUT_SIZE);
        show_error("Classifier Error");
      }
    }
  }

  #if SMOOTHING
  for(int i = 0; i < SMOOTHING_WINDOW_SIZE; i++)
  {
    for (int j = 0; j < CLASSIFIER_OUTPUT_SIZE; j++)
    {
        smoothing_window[i][j] = 0;
    }
  }
  #endif

  // do a warm up.  
  SimpleTimer timer;
  timer.start();

  // give it a whirl !!
  mfcc_Filter(nullptr, featurizer_input_buffers[0], featurizer_output_buffer);

  // classifier
  model_Predict(nullptr, featurizer_output_buffer, classifier_output_buffer);

  timer.stop();
  Serial.printf("Setup predict took %f ms\n", timer.milliseconds());
}

void show_error(const char* msg) 
{
  Screen.clean();
  Screen.print(0, msg);
  appstate = APPSTATE_Error;
}

void check_buttons()
{
  buttonAState = digitalRead(USER_BUTTON_A);
  if (buttonAState == LOW && lastButtonAState == HIGH)
  {
    if (appstate == APPSTATE_Recording)
    {
      stop_recording();
      appstate = APPSTATE_Init;
    }
    else 
    {
      start_recording();
      appstate = APPSTATE_Recording;
    }
  }
  lastButtonAState = buttonAState;
}

void loop(void)
{
  if (appstate != APPSTATE_Error)
  {
    printIdleMessage();
    while (1)
    {
      check_buttons();
    
      if (dropped_frames > 0) {
        Serial.printf("%d dropped frames\n", dropped_frames);        
        dropped_frames = 0;
      }
      // process all the buffered input frames
      while(next(featurizer_input_buffer_read) != featurizer_input_buffer_write)
      {
        featurizer_input_buffer_read = next(featurizer_input_buffer_read);
        process_audio(featurizer_input_buffers[featurizer_input_buffer_read]);
        
        check_buttons();
      }
      delay(10);
    }
  }
  delay(100);
}

void process_audio(float* featurizer_input_buffer)
{
  // looks like <chrono> doesn't work, rats...
  SimpleTimer timer;
  timer.start();

  // mfcc transform
  mfcc_Filter(nullptr, featurizer_input_buffer, featurizer_output_buffer);

  normalizer.apply_gain(featurizer_output_buffer, FEATURIZER_OUTPUT_SIZE);
  
  // classifier
  model_Predict(nullptr, featurizer_output_buffer, classifier_output_buffer);

  float max = -1;
  int argmax = 0;
  
#if SMOOTHING
  // posterior smoothing...
  for (int j = 0; j < CLASSIFIER_OUTPUT_SIZE; j++)
  {
      float v = classifier_output_buffer[j];
      smoothing_window[smoothing_window_pos][j] = v;
      classifier_output_buffer[j] = 0;
  }        
  
  for (int i = 0; i < SMOOTHING_WINDOW_SIZE; i++)
  {
    for (int j = 0; j < CLASSIFIER_OUTPUT_SIZE; j++)
    {
      float v = smoothing_window[i][j];
      classifier_output_buffer[j] += v;
    }
  }  
  smoothing_window_pos++;
  if (smoothing_window_pos == SMOOTHING_WINDOW_SIZE)
  {
    smoothing_window_pos = 0; // wrap around
  }
#endif

  // argmax over predictions.
  for (int j = 0; j < CLASSIFIER_OUTPUT_SIZE; j++)
  {
      float v = classifier_output_buffer[j];
      if (v > max) {
        max = v;
        argmax = j;
      }      
  }

  timer.stop();
  float elapsed = timer.milliseconds();

  max /= SMOOTHING_WINDOW_SIZE;

  Serial.printf("Prediction %d is %d:%s (%.2f) (e=%f, vad=%d, gain=%f) in %d ms\r\n", prediction_count++, argmax, categories[argmax], max, normalizer.getEpn(), normalizer.getVad(), normalizer.getGain(), (int)elapsed);
  
  if (argmax != 0 && max > PREDICT_PROB_THRESHOLD) {
    predictionVar = argmax;
    if (last_prediction != argmax) {
      if (max > last_confidence)
      {
        last_prediction = argmax;
        Serial1.write(getPredictWordId(argmax));
        Serial1.write((unsigned char)0);

      } else if (last_confidence > 0) {
        // provides a way to track best prediction for a little window in time.
        last_confidence -= 0.01;
      }
    }
    last_confidence = max;
  }

}

void printIdleMessage()
{
  int model_size = model_GetInputSize();
  char buffer[10];
  itoa(model_size, buffer, 10);
}

void audio_callback()
{
  // this is called when Audio class has a buffer full of audio, the buffer is size AUDIO_CHUNK_SIZE (512)  
  Audio.readFromRecordBuffer(raw_audio_buffer, AUDIO_CHUNK_SIZE);
  raw_audio_count++;
  
  char* curReader = &raw_audio_buffer[0];
  char* endReader = &raw_audio_buffer[AUDIO_CHUNK_SIZE];
  while(curReader < endReader)
  {
    if (SAMPLE_BIT_DEPTH == 16)
    {
      // We are getting 512 samples, but with dual channel 16 bit audio this means we are 
      // getting 512/4=128 readings after converting to mono channel floating point values.
      // Our featurizer expects 256 readings, so it will take 2 callbacks to fill the featurizer
      // input buffer.
      int bytesPerSample = 2;
      
      // convert to mono
      int16_t sample = *((int16_t *)curReader);
      curReader += bytesPerSample * 2; // skip right channel (not the best but it works for now)

      scaled_input_buffer[scaled_input_buffer_pos] = (float)sample / 32768.0f;
      scaled_input_buffer_pos++;
      
      if (scaled_input_buffer_pos == FEATURIZER_INPUT_SIZE)
      {
        scaled_input_buffer_pos = 0;
        if (next(featurizer_input_buffer_write) == featurizer_input_buffer_read)
        {
          dropped_frames++; // dropping frame on the floor since classifier is still processing this buffer
        }
        else 
        {
          memcpy(featurizer_input_buffers[featurizer_input_buffer_write], scaled_input_buffer, FEATURIZER_INPUT_SIZE * sizeof(float));        
          featurizer_input_buffer_write = next(featurizer_input_buffer_write);
        }
      }
    }
  }
}

void stop_recording()
{
  Audio.stop();
  Screen.clean();
  Serial.println("stop recording");
  Screen.print(0, "Locked...");
  Screen.print(1, "Press A to unlock", true);
}

void start_recording()
{
  // Re-config the audio data format
  Serial.println("start recording");
  Screen.clean();
  Screen.print(0, "Recording...");
  Screen.print(1, "Press A to lock", true);
  // Start to record audio data
  Audio.startRecord(audio_callback);
}
