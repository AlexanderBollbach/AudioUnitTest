
#import "MyAudioUnitAUViewController+AUAudioUnitFactory.h"

@implementation MyAudioUnitAUViewController (AUAudioUnitFactory)

- (MyAudioUnit *) createAudioUnitWithComponentDescription:(AudioComponentDescription) desc error:(NSError **)error
{
    self.audioUnit = [[MyAudioUnit alloc] initWithComponentDescription:desc error:error];
    return self.audioUnit;
}

@end
