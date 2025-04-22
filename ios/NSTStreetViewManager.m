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

RCT_CUSTOM_VIEW_PROPERTY(coordinate, CLLocationCoordinate, NSTStreetView) {
  if (json == nil) return;

  NSInteger radius = [[json valueForKey:@"radius"] intValue];
  if(radius == 0){
    radius = 50;
  }

  [view moveNearCoordinate:[RCTConvert CLLocationCoordinate2D:json]
                    radius: radius];
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

// heading property for backward compatibility (will be deprecated)
RCT_CUSTOM_VIEW_PROPERTY(heading, CLLocationDegrees, NSTStreetView) {
  if (json == nil) return;
  
  // Preserve existing camera pitch and zoom if possible
  float pitch = view.camera ? view.camera.orientation.pitch : 0;  // Use orientation.pitch
  float zoom = view.camera ? view.camera.zoom : 0;
  
  // Create and set camera
  view.camera = [GMSPanoramaCamera cameraWithHeading:[RCTConvert CLLocationDegrees:json]
                                              pitch:pitch
                                               zoom:zoom];
}

RCT_CUSTOM_VIEW_PROPERTY(outdoorOnly, BOOL, NSTStreetView) {
  if (json == nil) return;
  view.outdoorOnly = [RCTConvert BOOL:json];
}

RCT_EXPORT_VIEW_PROPERTY(allGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(streetNamesHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onSuccess, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onPanoramaChange, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onPovChange, RCTDirectEventBlock);

- (UIView *)view {
  NSTStreetView *panoView = [[NSTStreetView alloc] initWithFrame:CGRectZero];
  panoView.delegate = panoView;
  return panoView;
}

@end
