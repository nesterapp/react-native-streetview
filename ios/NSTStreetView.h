/**
 * NSTStreetView.h
 * 
 * Street View component for React Native (iOS implementation)
 */

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
@import GoogleMaps;

@interface NSTStreetView : GMSPanoramaView <GMSPanoramaViewDelegate>
@property (nonatomic,copy) RCTDirectEventBlock onError;
@property (nonatomic,copy) RCTDirectEventBlock onSuccess;
@property (nonatomic,copy) RCTDirectEventBlock onPanoramaChange;
@property (nonatomic,copy) RCTDirectEventBlock onPovChange;
@property (nonatomic) BOOL outdoorOnly;

// Animate camera updates
- (void)animateToCameraPosition:(GMSPanoramaCamera *)camera;

@end
