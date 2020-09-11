#import <UIKit/UIKit.h>
#import "CCHUIModuleContentViewController.h"

#import "../Helpers/ISColorWheel.h"

@interface CCHUIModuleContentViewController (Expanded)
    - (void) showExpanded;
    - (void) hideExpanded;
    - (void) setupExpandedViews;
    - (void) setupExpandedTimer;
    - (void) expandedTimerFire;
    - (void) sendBrightnessAndColor:(BOOL)updateColor;
@end
