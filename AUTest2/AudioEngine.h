//
//  AudioEngine.h
//  AUTest2
//
//  Created by Alexander Bollbach on 7/20/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//


@import Foundation;
@import AVFoundation;


@interface AudioEngine : NSObject

@property(nonatomic, assign)AudioUnit synth;
@property(nonatomic, strong)AUAudioUnit *synthAU;

typedef void(^completedAUSetup)(void);
- (void) setupAUWithComponentDescription:(AudioComponentDescription)componentDescription andCompletion:(completedAUSetup) completion;

@end
