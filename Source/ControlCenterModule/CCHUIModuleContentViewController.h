#import <UIKit/UIKit.h>
#import "headers/ControlCenterUIKit/CCUIContentModuleContentViewController-Protocol.h"
#import "headers/ControlCenterUIKit/CCUIContentModuleContainerView.h"
#import "../Helpers/CCHLight.h"
#import "../Helpers/CCHSelectedLights.h"
#import "../Helpers/STHTTPRequest.h"
#import "../Helpers/ISColorWheel.h"

@interface CCHUIModuleContentViewController : UIViewController <CCUIContentModuleContentViewController>

    @property (nonatomic,readonly) CGFloat preferredExpandedContentHeight;
    @property (nonatomic,readonly) CGFloat preferredExpandedContentWidth;
    @property (nonatomic,readonly) BOOL providesOwnPlatter;

    @property (nonatomic, readonly) BOOL small;

    @property (nonatomic, strong) UIView *toggleContainerView;
    @property (nonatomic, strong) UIImageView *toggleImageView;
    @property (nonatomic, strong) UILabel *toggleLabel;
    @property (nonatomic, strong) UITapGestureRecognizer *toggleTapRecognizer;

    @property (nonatomic, strong) UIView *expandedContainerView;
    @property (nonatomic, strong) UILabel *expandedLabel;
    @property (nonatomic, strong) UISlider *expandedSlider;
    @property (nonatomic, strong) ISColorWheel *expandedColorWheel;

    @property (nonatomic, strong) NSTimer *expandedValuesChangedTimer;
    @property (nonatomic, strong) UIColor *expandedLastColor;
    @property (nonatomic) double expandedLastBrightness;

    @property (nonatomic, strong) CCHLight *light;

    @property (nonatomic) BOOL lightIsOn;
    @property (nonatomic) double lightBrightness; // 0.0 - 1.0

    @property (nonatomic, strong) NSString *bridgeIP;
    @property (nonatomic, strong) NSString *bridgeUsername;

    @property (nonatomic) BOOL networkRequestRunning;

    - (instancetype) initWithSmallSize:(BOOL)small;

    - (void) controlCenterWillPresent;

    - (void) setupToggleViews;

    - (void) toggleLightState;

    - (void) updateCornerRadius;

    - (void) loadInfo;

    - (void) refreshState;

    - (void) fetchLightState;

@end
