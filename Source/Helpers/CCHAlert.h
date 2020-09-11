#import <UIKit/UIKit.h>

@interface CCHAlert: NSObject
    + (void) showWithTitle:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)viewController;
    + (void) showPoppingWithTitle:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)viewController;
@end
