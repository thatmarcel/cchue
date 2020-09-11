#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>
#import <spawn.h>

#import "../Helpers/STHTTPRequest.h"
#import "../Helpers/CCHPrefs.h"
#import "../Helpers/CCHAlert.h"
#import "../Helpers/CCHLight.h"

@interface CCHSelectLightsController: UIViewController
    @property (retain) UITableView *tableView;
    @property (retain) UIActivityIndicatorView *activityIndicatorView;

    @property (retain) NSArray *allLights;
    @property (retain) NSArray *selectedLights;

    - (void) fetchLights;
    - (void) addActivityIndicatorView;
    - (void) addTableView;
@end
