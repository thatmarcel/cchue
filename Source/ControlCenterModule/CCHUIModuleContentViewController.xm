#import "CCHUIModuleContentViewController.h"
#import "CCHUIModuleContentViewController+Expanded.h"

@implementation CCHUIModuleContentViewController
    @synthesize toggleContainerView;
    @synthesize toggleImageView;
    @synthesize toggleLabel;

    @synthesize expandedContainerView;
    @synthesize expandedLabel;
    @synthesize expandedSlider;
    @synthesize expandedColorWheel;

    @synthesize expandedValuesChangedTimer;
    @synthesize expandedLastColor;
    @synthesize expandedLastBrightness;

    @synthesize light;
    @synthesize lightIsOn;

    @synthesize networkRequestRunning;

    - (instancetype) initWithSmallSize:(BOOL)small {
        _small = small;
        return [self init];
    }

    - (instancetype) initWithNibName:(NSString*)name bundle:(NSBundle*)bundle {
        self = [super initWithNibName:name bundle:bundle];
        if (self) {
            self.view.clipsToBounds = true;
            self.view.layer.masksToBounds = true;

            [self setupToggleViews];
            [self setupExpandedViews];
            [self setupExpandedTimer];

            _preferredExpandedContentWidth = 280;
            _preferredExpandedContentHeight = 360;
        }

        return self;
    }

    - (void) updateCornerRadius {
        for (UIView* subview in [self.view.superview subviews]) {
            if ([subview isKindOfClass: %c(MTMaterialView)]) {
                self.view.layer.cornerRadius = subview.layer.cornerRadius;
            }
        }
    }

    - (void) loadInfo {
        if (self.light) {
            return;
        }

        CCUIContentModuleContainerView *containerView = (CCUIContentModuleContainerView*) [[[[[[self.view superview] superview] superview] superview] superview] superview];
        if (!containerView) { return; }

        NSString *moduleIdentifier = [containerView moduleIdentifier];

        NSString *lightIdentifier = [moduleIdentifier
                                        stringByReplacingOccurrencesOfString: @"com.thatmarcel.tweaks.cchue.modules."
                                        withString: @""];

        for (CCHLight *selectedLight in [CCHSelectedLights lights]) {
            if ([selectedLight.identifier isEqual: lightIdentifier]) {
                self.light = selectedLight;
            }
        }

        self.toggleLabel.text = self.light.name;
        self.expandedLabel.text = self.light.name;

        self.bridgeIP = [[CCHPrefs get] objectForKey: @"ip"];
        self.bridgeUsername = [[CCHPrefs get] objectForKey: @"username"];

        self.toggleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleLightState)];
        self.toggleTapRecognizer.numberOfTapsRequired = 1;
        [self.toggleContainerView addGestureRecognizer: self.toggleTapRecognizer];
        self.toggleContainerView.userInteractionEnabled = true;
    }

    - (void) setupToggleViews {
        self.toggleContainerView = [[UIView alloc] init];
        self.toggleContainerView.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addSubview: self.toggleContainerView];
        [self.toggleContainerView.topAnchor    constraintEqualToAnchor: self.view.topAnchor    constant: 0].active = true;
        [self.toggleContainerView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor constant: 0].active = true;
        [self.toggleContainerView.leftAnchor   constraintEqualToAnchor: self.view.leftAnchor   constant: 0].active = true;
        [self.toggleContainerView.rightAnchor  constraintEqualToAnchor: self.view.rightAnchor  constant: 0].active = true;
        self.toggleContainerView.backgroundColor = [UIColor clearColor];

        self.toggleImageView = [[UIImageView alloc] init];
        self.toggleImageView.translatesAutoresizingMaskIntoConstraints = false;
        [self.toggleContainerView addSubview: self.toggleImageView];
        [self.toggleImageView.topAnchor    constraintEqualToAnchor: self.toggleContainerView.topAnchor    constant: 8].active = true;
        [self.toggleImageView.rightAnchor  constraintEqualToAnchor: self.toggleContainerView.rightAnchor  constant: -8].active = true;
        [self.toggleImageView.widthAnchor  constraintEqualToConstant: 20].active = true;
        [self.toggleImageView.heightAnchor  constraintEqualToConstant: 20].active = true;
        self.toggleImageView.backgroundColor = [UIColor clearColor];

        self.toggleLabel = [[UILabel alloc] init];
        self.toggleLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.toggleContainerView addSubview: self.toggleLabel];
        [self.toggleLabel.bottomAnchor    constraintEqualToAnchor: self.toggleContainerView.bottomAnchor    constant: -8].active = true;
        [self.toggleLabel.leftAnchor      constraintEqualToAnchor: self.toggleContainerView.leftAnchor      constant: 10].active = true;
        [self.toggleLabel.rightAnchor     constraintEqualToAnchor: self.toggleContainerView.rightAnchor     constant: -8].active = true;
        self.toggleLabel.backgroundColor = [UIColor clearColor];


        self.toggleLabel.text = @"Loading";
        self.toggleLabel.numberOfLines = 2;
        self.toggleLabel.font = [UIFont systemFontOfSize: 12 weight: UIFontWeightBold];
        self.toggleLabel.textColor = [UIColor whiteColor];

        NSBundle *bundle = [[NSBundle alloc] initWithPath: @"/Library/ControlCenter/Bundles/CCHueControlCenterModule.bundle"];
        self.toggleImageView.tintColor = [UIColor whiteColor];
        self.toggleImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.toggleImageView.image = [[UIImage imageNamed: @"bulb" inBundle: bundle compatibleWithTraitCollection: nil]
                                                    imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    }

    - (void) refreshState {
        if (self.lightIsOn) {
            self.toggleContainerView.backgroundColor = [UIColor whiteColor];
            self.toggleLabel.textColor               = [UIColor blackColor];
            self.toggleImageView.tintColor           = [UIColor blackColor];

            if (self.lightBrightness) {
                self.expandedSlider.value = self.lightBrightness;
            }
        } else {
            self.toggleContainerView.backgroundColor = [UIColor clearColor];
            self.toggleLabel.textColor               = [UIColor whiteColor];
            self.toggleImageView.tintColor           = [UIColor whiteColor];

            self.expandedSlider.value = 0;
        }
    }

    - (void) fetchLightState {
        if (self.networkRequestRunning) {
            return;
        }

        self.networkRequestRunning = true;

        NSString *url = [NSString stringWithFormat: @"http://%@/api/%@/lights/%@", self.bridgeIP, self.bridgeUsername, self.light.identifier];
		STHTTPRequest *req = [STHTTPRequest requestWithURLString: url];

        req.completionDataBlock = ^(NSDictionary *headers, NSData *resData) {
            self.networkRequestRunning = false;

            NSError* jsonDecodingError;
			NSDictionary* resJson = (NSDictionary*) [NSJSONSerialization JSONObjectWithData: resData options: kNilOptions error: &jsonDecodingError];
			if (jsonDecodingError != nil || !resJson || ![resJson isKindOfClass: [NSDictionary class]]) {
                self.lightIsOn = false;
                self.lightBrightness = 0;
                [self refreshState];
				return;
			}

            self.lightIsOn = [((NSNumber*) resJson[@"state"][@"on"]) boolValue];
            self.lightBrightness = [((NSNumber*) resJson[@"state"][@"bri"]) doubleValue] / 254;
            [self refreshState];
		};

		req.errorBlock = ^(NSError *error) {
            self.networkRequestRunning = false;

            self.lightIsOn = false;
            self.lightBrightness = 0;
            [self refreshState];
		};

		[req startAsynchronous];
    }

    - (void) toggleLightState {
        if (self.networkRequestRunning) {
            return;
        }

        self.networkRequestRunning = true;

        NSString *url = [NSString stringWithFormat: @"http://%@/api/%@/lights/%@/state", self.bridgeIP, self.bridgeUsername, self.light.identifier];
		STHTTPRequest *req = [STHTTPRequest requestWithURLString: url];

        [req setHeaderWithName: @"content-type" value: @"application/json; charset=utf-8"];

		req.rawPOSTData = [[NSString stringWithFormat: @"{ \"on\": %@ }", self.lightIsOn ? @"false" : @"true"] dataUsingEncoding: NSUTF8StringEncoding];

        req.completionDataBlock = ^(NSDictionary *headers, NSData *resData) {
            self.networkRequestRunning = false;

            [self fetchLightState];
		};

		req.errorBlock = ^(NSError *error) {
            self.networkRequestRunning = false;

            [self fetchLightState];
		};

        req.HTTPMethod = @"PUT";

		[req startAsynchronous];
    }

    - (void) viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];

        [self updateCornerRadius];

        [self loadInfo];
        [self fetchLightState];
    }

    - (void) controlCenterWillPresent { }

    - (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

        if (size.width == self.preferredExpandedContentWidth && self.light) {
            [self showExpanded];
        } else {
            [self hideExpanded];
        }
    }

    - (BOOL) _canShowWhileLocked {
	    return true;
    }
@end
