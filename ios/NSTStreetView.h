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
@property (nonatomic,copy) RCTDirectEventBlock onPanoramaChange;
@property (nonatomic,copy) RCTDirectEventBlock onPovChange;
@property (nonatomic, assign) BOOL outdoorOnly;
@property (nonatomic, assign) NSInteger lastRadius;

// Animate camera updates
- (void)animateToCameraPosition:(GMSPanoramaCamera *)camera;

@end
