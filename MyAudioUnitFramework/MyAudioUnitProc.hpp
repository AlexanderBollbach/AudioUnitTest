//
//  MyAudioUnitProc.h
//  AudioUnitV3Test1
//
//  Created by Alexander Bollbach on 7/19/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>

#ifndef MyAudioUnitProc_h
#define MyAudioUnitProc_h




class MyAudioUnitProc
{
public:

    
    MyAudioUnitProc();
    
    void init(int channelCount, double inSampleRate);
    void reset();
    void setBuffers(AudioBufferList* outBufferList);
   
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset);

    
private:
    float phase;
    AudioBufferList* outBufferListPtr;

};


#endif /* MyAudioUnitProc_h */
