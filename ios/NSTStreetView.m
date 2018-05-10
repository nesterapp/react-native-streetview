//
//  NSTStreetView.m
//  NSTStreetview
//
//  Created by Adam Jenkins on 2018-04-04.
//  Copyright © 2018 Nester. All rights reserved.
//

#import "NSTStreetView.h"

@implementation NSTStreetView

#pragma mark GMSPanoramaViewDelegate
- (void)panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate {
    if(_onError) {
        NSNumber *lat = [[NSNumber alloc] initWithDouble:coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc] initWithDouble:coordinate.longitude];
        NSDictionary *coord = @{@"latitude":lat,@"longitude":lng};
        _onError(@{@"coordinate":coord});
    }
}

- (void)panoramaViewDidFinishRendering:(GMSPanoramaView *)panoramaView
{
    if(_onSuccess) {
        NSNumber *lat = [[NSNumber alloc] initWithDouble:panoramaView.panorama.coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc] initWithDouble:panoramaView.panorama.coordinate.longitude];
        NSDictionary *coord = @{@"latitude":lat,@"longitude":lng};
        _onSuccess(@{@"coordinate":coord});
    }
}
@end
