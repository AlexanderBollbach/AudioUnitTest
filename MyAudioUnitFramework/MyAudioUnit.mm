//
//  MyAudioUnit.m
//  AudioUnitV3Test1
//
//  Created by Alexander Bollbach on 7/19/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#import "MyAudioUnit.h"

#import "MyAudioUnitProc.hpp"

@interface MyAudioUnit ()

@property (nonatomic, strong) AUAudioUnitBus *outputBus;
@property (nonatomic, strong) AUAudioUnitBusArray *outputBusArray;


@end


@implementation MyAudioUnit {
    
    
    
    
    
    
    
    
    
}


- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError
{
    if (![super allocateRenderResourcesAndReturnError:outError])
    {
        return NO;
    }
    
  
    return YES;
}


- (void)deallocateRenderResources
{
    [super deallocateRenderResources];
    
    
}



- (AUInternalRenderBlock)internalRenderBlock
{
    /*
     Capture in locals to avoid ObjC member lookups. If "self" is captured in
     render, we're doing it wrong.
     */
    
    
    return ^AUAudioUnitStatus(
                              AudioUnitRenderActionFlags *actionFlags,
                              const AudioTimeStamp       *timestamp,
                              AVAudioFrameCount           frameCount,
                              NSInteger                   outputBusNumber,
                              AudioBufferList            *outputData,
                              const AURenderEvent        *realtimeEventListHead,
                              AURenderPullInputBlock      pullInputBlock)
    {
    
        return noErr;
    };
}

@end
