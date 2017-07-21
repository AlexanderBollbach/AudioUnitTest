//
//  MainViewController.m
//  AUInstrument
//
//  Created by Eric on 4/18/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "TestVC.h"

@import AudioUnit;
#import <MyAudioUnitFramework/MyAudioUnitFramework.h>

#import "AudioEngine.h"



@interface TestVC ()
{
    AudioEngine *_audioEngine;
    
    
}


@property (strong, nonatomic) MyAudioUnitAUViewController *myAudioUnitViewController;



@property (strong, nonatomic) IBOutlet UIView *auContainerView;


@end

@implementation TestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
//    [self embedPlugInView];
    
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Generator;
    desc.componentSubType = 0x77617665; /*'wave'*/
    desc.componentManufacturer = 0x44656d6f; /*'Demo'*/
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    
    [AUAudioUnit registerSubclass:MyAudioUnit.self asComponentDescription:desc name:@"MyAudioUnit" version:1];
    
    _audioEngine = [[AudioEngine alloc] init];
    [_audioEngine setupAUWithComponentDescription:desc andCompletion:^{
        
    }];
}

- (void) embedPlugInView
{
    NSURL *builtInPlugInsURL = [[NSBundle mainBundle] builtInPlugInsURL];
    NSURL *pluginURL = [builtInPlugInsURL URLByAppendingPathComponent:(@"MyAudioUnitExtension.appex")];
    NSBundle *appExtensionBundle = [[NSBundle alloc] initWithURL:pluginURL];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainInterface" bundle:appExtensionBundle];
    
    self.myAudioUnitViewController = [storyboard instantiateInitialViewController];
    
    UIView *view = self.myAudioUnitViewController.view;
    if (view)
    {
        [self addChildViewController:self.myAudioUnitViewController];
        view.frame = self.auContainerView.bounds;
        
        [self.auContainerView addSubview:view];
        [self.myAudioUnitViewController didMoveToParentViewController:self];
    }
}





@end
