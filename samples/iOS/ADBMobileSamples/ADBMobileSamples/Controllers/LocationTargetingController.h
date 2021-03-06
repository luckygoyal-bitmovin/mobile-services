/*************************************************************************

ADOBE SYSTEMS INCORPORATED
Copyright 2015 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTargetingController : UIViewController

@property (assign) IBOutlet UIView *backgroundView;
@property (assign) IBOutlet UITextView *textView;

@property (strong) CLLocation *seattle;
@property (strong) CLLocation *sanJose;
@property (strong) CLLocation *nyc;
@property (strong) CLLocation *dallas;
@property (strong) CLLocation *miami;

@end
