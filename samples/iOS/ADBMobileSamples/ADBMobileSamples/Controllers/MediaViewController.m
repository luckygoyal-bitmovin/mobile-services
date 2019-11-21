/*************************************************************************

ADOBE SYSTEMS INCORPORATED
Copyright 2015 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "MediaViewController.h"
#import <AVKit/AVKit.h>
#import "ADBMobile.h"

#pragma mark - class constants
static NSString *const VIDEO_URL	= @"https://s7d2.scene7.com/is/content/mcmobile/new-building-AVS.m3u8";
static NSString *const MEDIA_NAME	= @"MyAdobe";
static NSString *const PLAYER_NAME	= @"MPMoviePlayer";
static NSString *const PLAYER_ID	= @"MPMoviePlayer1";
static NSString *const RATE_KEY    = @"rate";
static double const MEDIA_LENGTH	= 146;

@interface MediaViewController () {
AVPlayerViewController *movieViewController;
}

@end

@implementation MediaViewController

- (void) viewDidLoad {
    [super viewDidLoad];

	/*
	 * Adobe Tracking - Analytics
	 *
	 * call to trackState:data: for view states report
	 * trackState:data: increments the page view
	 */
	[ADBMobile trackState:@"Media Example" data:nil];
	
	// make our black background rounded
	_blackBackground.layer.cornerRadius = 5;
	_blackBackground.layer.masksToBounds = YES;
	
	[self configureMedia];
}

#pragma mark - UI action handlers
- (IBAction) btnPlayMedia:(id)sender {
	[self configureMediaTracking];
	
	// begin playing the media item
	[self playMedia];
}

- (IBAction) swTrackMilestonesChanged:(id)sender {
	if (_swTrackMilestones.on) { // adjust the rest of the switches to the correct state
		[_swTrackOffsetMilestones setOn:NO animated:YES];
		[_swSegmentByOffsetMilestones setOn:NO animated:YES];
		[_swTrackSeconds setOn:NO animated:YES];
	}
	else { // if milestones are off, turn off segmentByMilestones
		[_swSegmentByMilestones setOn:NO animated:YES];
	}
}

- (IBAction) swSegmentByMilestonesChanged:(id)sender {
	if (_swSegmentByMilestones.on) { // adjust the rest of the switches to the correct state
		[_swTrackMilestones setOn:YES animated:YES];
		[_swTrackOffsetMilestones setOn:NO animated:YES];
		[_swSegmentByOffsetMilestones setOn:NO animated:YES];
		[_swTrackSeconds setOn:NO animated:YES];
	}
}

- (IBAction) swTrackOffsetMilestonesChanged:(id)sender {
	if (_swTrackOffsetMilestones.on) { // adjust the rest of the switches to the correct state
		[_swTrackMilestones setOn:NO animated:YES];
		[_swSegmentByMilestones setOn:NO animated:YES];
		[_swTrackSeconds setOn:NO animated:YES];
	}
	else { // if offsetMilestones are off, turn off segmentByOffsetMilestones
		[_swSegmentByOffsetMilestones setOn:NO animated:YES];
	}
}

- (IBAction) swSegmentByOffsetMilestonesChanged:(id)sender {
	if (_swSegmentByOffsetMilestones.on) { // adjust the rest of the switches to the correct state
		[_swTrackOffsetMilestones setOn:YES animated:YES];
		[_swTrackMilestones setOn:NO animated:YES];
		[_swSegmentByMilestones setOn:NO animated:YES];
		[_swTrackSeconds setOn:NO animated:YES];
	}
}

- (IBAction) swTrackSecondsChanged:(id)sender {
	if (_swTrackSeconds.on) { // adjust the rest of the switches to the correct state
		[_swTrackMilestones setOn:NO animated:YES];
		[_swSegmentByMilestones setOn:NO animated:YES];
		[_swTrackOffsetMilestones setOn:NO animated:YES];
		[_swSegmentByOffsetMilestones setOn:NO animated:YES];
	}
}

#pragma mark - Media methods
// set up the movie player and notifications
- (void) configureMedia {
    NSURL *movieURL = [NSURL URLWithString:VIDEO_URL];
    AVPlayer *player = [AVPlayer playerWithURL:movieURL];
    movieViewController = [AVPlayerViewController new];
    movieViewController.player = player;
    
    [movieViewController.player addObserver:self forKeyPath:RATE_KEY options:0 context:nil];
    [self configureNotifications:movieViewController];
}

// set up the notifications we are intereseted in for tracking
- (void) configureNotifications:(AVPlayerViewController *) movieController {
    // this is where we will close our media item
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(mediaFinishedCallback:)
     name: AVPlayerItemDidPlayToEndTimeNotification
     object: nil];
}

// configure our tracking based on the switches from the UI
- (void) configureMediaTracking {
	ADBMediaSettings *mediaSettings = [ADBMobile mediaCreateSettingsWithName:MEDIA_NAME length:MEDIA_LENGTH playerName:PLAYER_NAME playerID:PLAYER_ID];
	if (_swTrackMilestones.on) {
		/*
		 * Adobe Tracking - Media
		 *
		 * sets the milestones that we would like to track on the ADBMediaSettings Object
		 */
		mediaSettings.milestones = @"25,50,75";
		if (_swSegmentByMilestones.on) {
			/*
			 * Adobe Tracking - Media
			 *
			 * sets that we would like to segment by the milestones on the ADBMediaSettings Object
			 */
			mediaSettings.segmentByMilestones = YES;
		}
	}
	else if (_swTrackOffsetMilestones.on) {
		/*
		 * Adobe Tracking - Media
		 *
		 * sets the offsetMilestones that we would like to track on the ADBMediaSettings Object
		 */
		mediaSettings.offsetMilestones = @"60,120";
		if (_swSegmentByOffsetMilestones.on) {
			/*
			 * Adobe Tracking - Media
			 *
			 * sets that we would like to segment by the offsetMilestones on the ADBMediaSettings Object
			 */
			mediaSettings.segmentByOffsetMilestones = YES;
		}
	}

	/*
	 * Adobe Tracking - Media
	 *
	 * opens the media item, preparing it for tracking
	 */
	[ADBMobile mediaOpenWithSettings:mediaSettings callback:nil];
}

// display and begin playing the media
- (void) playMedia {
    [self presentViewController:movieViewController animated:YES completion:^{
      [movieViewController.player play];
    }];
}

// this notifies us so we can close our media item
- (void) mediaFinishedCallback: (NSNotification*) notification {
	/*
	 * Adobe Tracking - Media
	 *
	 * closes the media item
	 * media item should recieve no more calls unless its a new open and play
	 */
	[ADBMobile mediaClose:MEDIA_NAME];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:RATE_KEY]) {
        if (movieViewController.player.rate == 0) {
            /*
             * Adobe Tracking - Media
             *
             * stops the media item
             * we need to stop here because we are no longer in a playing state
             */
            [ADBMobile mediaStop:MEDIA_NAME offset:movieViewController.player.currentTime.value];
        } else {
            /*
             * Adobe Tracking - Media
             *
             * sets the media item into a playing state
             * if this is the initial play, it begins the tracking and monitor for the media item
             */
            [ADBMobile mediaPlay:MEDIA_NAME offset: isnan(movieViewController.player.currentTime.value) ? 0.0 : movieViewController.player.currentTime.value];
        }
    }
}

@end
