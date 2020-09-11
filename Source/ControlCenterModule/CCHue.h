#import <UIKit/UIKit.h>
#import "headers/ControlCenterUIKit/CCUIContentModule-Protocol.h"
#import "CCHUIModuleContentViewController.h"

@interface CCHue : NSObject <CCUIContentModule>
    @property (nonatomic, readonly) CCHUIModuleContentViewController* contentViewController;
    @property (nonatomic, readonly) UIViewController* backgroundViewController;
@end
