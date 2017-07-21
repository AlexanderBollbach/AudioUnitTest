//
//  MyAudioUnit.m
//  AudioUnitV3Test1
//
//  Created by Alexander Bollbach on 7/19/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#import "MyAudioUnit.h"
#import "BufferedAudioBus.hpp"


@interface MyAudioUnit ()

@property (nonatomic, strong) AUAudioUnitBus *outputBus;
@property (nonatomic, strong) AUAudioUnitBusArray *outputBusArray;


@end


@implementation MyAudioUnit {
    
    BufferedOutputBus _outputBusBuffer;

    float phase;
}


- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription
                                     options:(AudioComponentInstantiationOptions)options
                                       error:(NSError **)outError
{
    self = [super initWithComponentDescription:componentDescription options:options error:outError];
    
    AVAudioFormat *defaultFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100. channels:2];
    
    if (self == nil)
    {
        return nil;
    }
   
    
    _outputBusBuffer.init(defaultFormat, 2);
    _outputBus = _outputBusBuffer.bus;

    // Create the input and output bus arrays.
    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];

    self.maximumFramesToRender = 512;
//
    return self;
}


- (AUAudioUnitBusArray *)outputBusses
{
    return _outputBusArray;
}


- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError
{
    if (![super allocateRenderResourcesAndReturnError:outError])
    {
        return NO;
    }
    
  _outputBusBuffer.allocateRenderResources(self.maximumFramesToRender);
    return YES;
}


- (void)deallocateRenderResources
{
    [super deallocateRenderResources];
    
    
}



- (AUInternalRenderBlock)internalRenderBlock
{
    return ^AUAudioUnitStatus(
                              AudioUnitRenderActionFlags *actionFlags,
                              const AudioTimeStamp       *timestamp,
                              AVAudioFrameCount           frameCount,
                              NSInteger                   outputBusNumber,
                              AudioBufferList            *outputData,
                              const AURenderEvent        *realtimeEventListHead,
                              AURenderPullInputBlock      pullInputBlock)
    {
    
        _outputBusBuffer.prepareOutputBufferList(outputData, frameCount, true);
        
        float* outL = (float*)outputData->mBuffers[0].mData;
        float* outR = (float*)outputData->mBuffers[1].mData;
        
        for (AUAudioFrameCount i = 0; i < frameCount; ++i)
        {
            outL[i] = outR[i] = sin(i * 0.2);
        }
    
        return noErr;
    };
}

@end
