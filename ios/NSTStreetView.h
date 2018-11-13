//
//  NSTStreetView.h
//  NSTStreetview
//
//  Created by Adam Jenkins on 2018-04-04.
//  Copyright © 2018 Nester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <GoogleMaps/GoogleMaps.h>

@interface NSTStreetView : GMSPanoramaView <GMSPanoramaViewDelegate>
@property (nonatomic,copy) RCTDirectEventBlock onError;
@property (nonatomic,copy) RCTDirectEventBlock onSuccess;

@end
