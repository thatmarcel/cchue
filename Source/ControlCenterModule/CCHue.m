#import "CCHue.h"
#import "headers/ControlCenterUIKit/ControlCenterUI-Structs.h"
#import <objc/runtime.h>

@implementation CCHue
    - (instancetype) init {
        if ((self = [super init])) {
            _contentViewController = [[CCHUIModuleContentViewController alloc] initWithSmallSize: false];
	    }
        return self;
    }

    - (CCUILayoutSize) moduleSizeForOrientation:(int)orientation {
        return (CCUILayoutSize){1, 1};
    }
@end
