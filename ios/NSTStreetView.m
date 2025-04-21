/**
 * NSTStreetView.m
 * 
 * Street View component for React Native (iOS implementation)
 */

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

- (void)animateToCameraPosition:(GMSPanoramaCamera *)camera {
    // Fix: Use the correct method name from GMSPanoramaView
    [self animateToCamera:camera animationDuration:1.0];
}

- (void)moveNearCoordinate:(CLLocationCoordinate2D)coordinate radius:(NSUInteger)radius {
    // Use the appropriate source based on outdoorOnly flag
    GMSPanoramaSource source = self.outdoorOnly ? kGMSPanoramaSourceOutside : kGMSPanoramaSourceDefault;
    
    // call the super implementation
    [super moveNearCoordinate:coordinate radius:radius source:source];
}

@end
