//
//  NSTStreetViewManager.m
//  react-native-streetview
//
//  Created by Amit Palomo on 26/04/2017.
//  Copyright © 2017 Nester.co.il.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTConvert+CoreLocation.h>

@import GoogleMaps;

@interface NSTStreetViewManager : RCTViewManager
@end

@implementation NSTStreetViewManager

RCT_EXPORT_MODULE()

RCT_CUSTOM_VIEW_PROPERTY(coordinate, CLLocationCoordinate, GMSPanoramaView) {
  if (json == nil) return;

  [view moveNearCoordinate:[RCTConvert CLLocationCoordinate2D:json]];
}

RCT_EXPORT_VIEW_PROPERTY(allGesturesEnabled, BOOL)

- (UIView *)view {
  GMSPanoramaView *panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
  return panoView;
}

@end
