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
@property (nonatomic, readwrite) AUParameterTree *parameterTree;


@end



@implementation MyAudioUnit {
    
    BufferedOutputBus _outputBusBuffer;

    float phase;
}


@synthesize parameterTree = _parameterTree;

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

    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];
    
    
    
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_IsReadable | kAudioUnitParameterFlag_DisplayLogarithmic;
    AUParameter * frequencyParameter = [AUParameterTree createParameterWithIdentifier:@"Frequency"
                                                                         name:@"Frequency"
                                                                      address:0
                                                                          min:5
                                                                          max:1000 unit:kAudioUnitParameterUnit_Hertz
                                                                     unitName:nil
                                                                        flags: flags
                                                                 valueStrings:nil
                                                          dependentParameters:nil];
    
    frequencyParameter.value = 500;
    
    _parameterTree = [AUParameterTree createTreeWithChildren:@[
                                                               frequencyParameter
                                                               ]];

    
    
    // implementorValueObserver is called when a parameter changes value.
    _parameterTree.implementorValueObserver = ^(AUParameter *param, AUValue value) {
    
        NSLog(@"%f", param.value);
    };
    
    // implementorValueProvider is called when the value needs to be refreshed.
    _parameterTree.implementorValueProvider = ^(AUParameter *param) {
        return frequencyParameter.value; // ? recursiony??
    };
    
    // A function to provide string representations of parameter values.
    _parameterTree.implementorStringFromValueCallback = ^(AUParameter *param, const AUValue *__nullable valuePtr) {
        AUValue value = valuePtr == nil ? param.value : *valuePtr;
        
        switch (param.address) {
            case 0:
                return [NSString stringWithFormat:@"%.3f", value];
            default:
                return @"?";
        }
    
    };
    
    
    
    
    
    self.maximumFramesToRender = 512;

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
            outL[i] = outR[i] = sin(phase);
            phase += 0.04;
        }
    
        return noErr;
    };
}

@end
