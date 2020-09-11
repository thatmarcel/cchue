#import "CCHUIModuleContentViewController+Expanded.h"

@implementation CCHUIModuleContentViewController (Expanded)
    - (void) showExpanded {
        self.toggleContainerView.hidden = true;
        self.expandedContainerView.hidden = false;
    }

    - (void) hideExpanded {
        self.toggleContainerView.hidden = false;
        self.expandedContainerView.hidden = true;
    }

    - (void) setupExpandedViews {
        self.expandedContainerView = [[UIView alloc] init];
        self.expandedContainerView.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addSubview: self.expandedContainerView];
        [self.expandedContainerView.topAnchor    constraintEqualToAnchor: self.view.topAnchor    constant: 0].active = true;
        [self.expandedContainerView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor constant: 0].active = true;
        [self.expandedContainerView.leftAnchor   constraintEqualToAnchor: self.view.leftAnchor   constant: 0].active = true;
        [self.expandedContainerView.rightAnchor  constraintEqualToAnchor: self.view.rightAnchor  constant: 0].active = true;
        self.expandedContainerView.backgroundColor = [UIColor clearColor];

        self.expandedLabel = [[UILabel alloc] init];
        self.expandedLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.expandedContainerView addSubview: self.expandedLabel];
        [self.expandedLabel.topAnchor    constraintEqualToAnchor: self.expandedContainerView.topAnchor constant: 32].active = true;
        [self.expandedLabel.leftAnchor   constraintEqualToAnchor: self.expandedContainerView.leftAnchor   constant: 32].active = true;
        [self.expandedLabel.rightAnchor  constraintEqualToAnchor: self.expandedContainerView.rightAnchor  constant: -32].active = true;
        self.expandedContainerView.backgroundColor = [UIColor clearColor];

        self.expandedColorWheel = [[ISColorWheel alloc] init];
        self.expandedColorWheel.translatesAutoresizingMaskIntoConstraints = false;
        [self.expandedContainerView addSubview: self.expandedColorWheel];
        [self.expandedColorWheel.topAnchor    constraintEqualToAnchor: self.expandedLabel.bottomAnchor         constant: 32].active = true;
        [self.expandedColorWheel.leftAnchor   constraintEqualToAnchor: self.expandedContainerView.leftAnchor   constant: 70].active = true;
        [self.expandedColorWheel.rightAnchor  constraintEqualToAnchor: self.expandedContainerView.rightAnchor  constant: -70].active = true;
        [self.expandedColorWheel.heightAnchor constraintEqualToAnchor: self.expandedColorWheel.widthAnchor  constant: 0].active = true;
        self.expandedColorWheel.backgroundColor = [UIColor clearColor];

        self.expandedSlider = [[UISlider alloc] init];
        self.expandedSlider.translatesAutoresizingMaskIntoConstraints = false;
        [self.expandedContainerView addSubview: self.expandedSlider];
        [self.expandedSlider.topAnchor    constraintEqualToAnchor: self.expandedColorWheel.bottomAnchor    constant: 32].active = true;
        [self.expandedSlider.leftAnchor   constraintEqualToAnchor: self.expandedContainerView.leftAnchor   constant: 32].active = true;
        [self.expandedSlider.rightAnchor  constraintEqualToAnchor: self.expandedContainerView.rightAnchor  constant: -32].active = true;
        self.expandedSlider.backgroundColor = [UIColor clearColor];

        self.expandedLabel.text = @"Loading";
        self.expandedLabel.numberOfLines = 0;
        self.expandedLabel.font = [UIFont systemFontOfSize: 30 weight: UIFontWeightHeavy];
        self.expandedLabel.textColor = [UIColor whiteColor];

        self.expandedColorWheel.borderWidth = 0;

        self.expandedContainerView.hidden = true;

        self.expandedSlider.minimumValue = 0.0;
        self.expandedSlider.maximumValue = 1.0;
        self.expandedSlider.value = 0.5;
        self.expandedSlider.minimumTrackTintColor = [UIColor whiteColor];
    }

    - (void) setupExpandedTimer {
        self.expandedValuesChangedTimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                target: self
                                                selector: @selector(expandedTimerFire)
                                                userInfo: nil
                                                repeats: true];
    }

    - (void) expandedTimerFire {
        if (self.networkRequestRunning || !self.bridgeIP || self.expandedContainerView.hidden) {
            return;
        }

        if (![self.expandedColorWheel.currentColor isEqual: self.expandedLastColor]) {
            [self sendBrightnessAndColor: true];
            self.expandedLastColor = self.expandedColorWheel.currentColor;
            self.expandedLastBrightness = self.expandedSlider.value;
            return;
        }

        if (self.expandedSlider.value != self.expandedLastBrightness) {
            self.expandedLastColor = self.expandedColorWheel.currentColor;
            self.expandedLastBrightness = self.expandedSlider.value;
            [self sendBrightnessAndColor: false];
        }
     }

     - (void) sendBrightnessAndColor:(BOOL)updateColor {
        self.networkRequestRunning = true;

        NSString *url = [NSString stringWithFormat: @"http://%@/api/%@/lights/%@/state", self.bridgeIP, self.bridgeUsername, self.light.identifier];
 		STHTTPRequest *req = [STHTTPRequest requestWithURLString: url];

        [req setHeaderWithName: @"content-type" value: @"application/json; charset=utf-8"];

 		if (updateColor) {
            CGFloat hue;
            CGFloat saturation;
            CGFloat brightness;
            CGFloat alpha;
            [self.expandedColorWheel.currentColor getHue: &hue saturation: &saturation brightness: &brightness alpha: &alpha];
            hue *= 65535;
            saturation *= 254;
            req.rawPOSTData = [[NSString
                                    stringWithFormat: @"{ \"on\": %@, \"bri\": %@, \"sat\": %@, \"hue\": %@ }",
                                    self.expandedSlider.value > 0 ? @"true" : @"false",
                                    @((int) (self.expandedSlider.value * 254)),
                                    @((int) saturation),
                                    @((int) hue)] dataUsingEncoding: NSUTF8StringEncoding];
        } else {
            req.rawPOSTData = [[NSString
                                    stringWithFormat: @"{ \"on\": %@, \"bri\": %@ }",
                                    self.expandedSlider.value > 0 ? @"true" : @"false",
                                    @((int) (self.expandedSlider.value * 254))] dataUsingEncoding: NSUTF8StringEncoding];
        }

        req.completionDataBlock = ^(NSDictionary *headers, NSData *resData) {
            self.networkRequestRunning = false;
 		};

 		req.errorBlock = ^(NSError *error) {
            self.networkRequestRunning = false;
 		};

        req.HTTPMethod = @"PUT";

 		[req startAsynchronous];

        self.lightBrightness = self.expandedSlider.value;
        self.lightIsOn = self.expandedSlider.value > 0;
        [self refreshState];
     }
@end
