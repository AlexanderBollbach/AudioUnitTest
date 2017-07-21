//
//  MyAudioUnitProc.cpp
//  AudioUnitV3Test1
//
//  Created by Alexander Bollbach on 7/19/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#include "MyAudioUnitProc.hpp"

MyAudioUnitProc::MyAudioUnitProc() {
    
    outBufferListPtr = nullptr;
    phase = 0;
}


void MyAudioUnitProc::init(int channelCount, double inSampleRate)
{
    phase = 0;
}

void MyAudioUnitProc::setBuffers(AudioBufferList* outBufferList)
{
    outBufferListPtr = outBufferList;
}


void MyAudioUnitProc::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) {
    
    float * outL = (float *) outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float * outR = (float *) outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    for (AUAudioFrameCount i = 0; i < frameCount; ++i) {
        outL[i] = outR[i] = sin(phase);
    }
}
