//
//  NSTStreetView.h
//  NSTStreetview
//
//  Copyright © 2019 Nester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
@import GoogleMaps;

@interface NSTStreetView : GMSPanoramaView <GMSPanoramaViewDelegate>
@property (nonatomic,copy) RCTDirectEventBlock onError;
@property (nonatomic,copy) RCTDirectEventBlock onSuccess;

@end
