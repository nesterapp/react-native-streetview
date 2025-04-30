/**
 * NSTStreetViewManager.m
 * 
 * Street View component manager for React Native (iOS implementation)
 */

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTConvert+CoreLocation.h>
#import "NSTStreetView.h"
@import GoogleMaps;

@interface NSTStreetViewManager : RCTViewManager
@end

@implementation NSTStreetViewManager

RCT_EXPORT_MODULE()

RCT_CUSTOM_VIEW_PROPERTY(coordinate, CLLocationCoordinate2D, NSTStreetView) {
  if (json) {
    // Extract values
    CLLocationDegrees lat = [RCTConvert double:json[@"latitude"]];
    CLLocationDegrees lng = [RCTConvert double:json[@"longitude"]];
    
    // Get radius if specified, or use default
    NSInteger radius = json[@"radius"] ? [RCTConvert NSInteger:json[@"radius"]] : 50;
    
    // Save the radius first to make sure it's available for error handling
    view.lastRadius = radius;
    
    // Move to the location
    [view moveNearCoordinate:CLLocationCoordinate2DMake(lat, lng) radius:radius];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(pov, NSDictionary, NSTStreetView) {
  if (json == nil) return;
  
  // Extract values from pov object with defaults if values aren't provided
  float tilt = json[@"tilt"] ? [RCTConvert float:json[@"tilt"]] : 0;
  float bearing = json[@"bearing"] ? [RCTConvert float:json[@"bearing"]] : 0;
  float zoom = json[@"zoom"] ? [RCTConvert float:json[@"zoom"]] : 0;
  
  // Create camera
  GMSPanoramaCamera *camera = [GMSPanoramaCamera cameraWithHeading:bearing
                                                             pitch:tilt
                                                              zoom:zoom];
  
  // Animate to new camera position
  [view animateToCameraPosition:camera];
}

RCT_CUSTOM_VIEW_PROPERTY(outdoorOnly, BOOL, NSTStreetView) {
  if (json == nil) return;
  view.outdoorOnly = [RCTConvert BOOL:json];
}

RCT_EXPORT_VIEW_PROPERTY(allGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(streetNamesHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onPanoramaChange, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onPovChange, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(orientationGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(zoomGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(navigationGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(navigationLinksHidden, BOOL)

- (UIView *)view {
  NSTStreetView *panoView = [[NSTStreetView alloc] initWithFrame:CGRectZero];
  panoView.delegate = panoView;
  return panoView;
}

@end
