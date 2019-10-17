//
//  NSTStreetViewManager.m
//  react-native-streetview
//
//  Created by Amit Palomo on 26/04/2017.
//  Copyright © 2019 Nester.co.il.
//

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

RCT_CUSTOM_VIEW_PROPERTY(heading, CLLocationDegrees, NSTStreetView) {
  if (json == nil) return;
  view.camera = [GMSPanoramaCamera cameraWithHeading:[RCTConvert CLLocationDegrees:json] pitch:0 zoom:1];
}

RCT_EXPORT_VIEW_PROPERTY(allGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onSuccess, RCTDirectEventBlock);

- (UIView *)view {
  NSTStreetView *panoView = [[NSTStreetView alloc] initWithFrame:CGRectZero];
  panoView.delegate = panoView;
  return panoView;
}

@end
