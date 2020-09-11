#import "CCHAlert.h"

@implementation CCHAlert
    + (void) showWithTitle:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)viewController {
        UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle: title
                                 message: message
                                 preferredStyle: UIAlertControllerStyleAlert];

        [alert addAction: [UIAlertAction
                                actionWithTitle: @"Dismiss"
                                style: UIAlertActionStyleDefault
                                handler: ^(UIAlertAction * action) { }]];

        [viewController presentViewController: alert animated: true completion: nil];
    }

    + (void) showPoppingWithTitle:(NSString*)title message:(NSString*)message onViewController:(UIViewController*)viewController {
        UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle: title
                                 message: message
                                 preferredStyle: UIAlertControllerStyleAlert];

        [alert addAction: [UIAlertAction
                                actionWithTitle: @"Dismiss"
                                style: UIAlertActionStyleDefault
                                handler: ^(UIAlertAction * action) {
                                    [viewController.navigationController popViewControllerAnimated: true];
                                }]];

        [viewController presentViewController: alert animated: true completion: nil];
    }
@end
