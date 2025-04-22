/**
 * NSTStreetView.m
 * 
 * Street View component for React Native (iOS implementation)
 */

#import "NSTStreetView.h"

static const float TILT_THRESHOLD = 0.5;    // degrees
static const float BEARING_THRESHOLD = 0.5; // degrees
static const float ZOOM_THRESHOLD = 0.1;    // zoom level

@implementation NSTStreetView {
    float lastTilt;
    float lastBearing;
    float lastZoom;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize last values
        lastTilt = 0;
        lastBearing = 0;
        lastZoom = 0;
    }
    return self;
}

#pragma mark GMSPanoramaViewDelegate
- (void)panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate {
    if(_onError) {
        NSNumber *lat = [[NSNumber alloc] initWithDouble:coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc] initWithDouble:coordinate.longitude];
        NSDictionary *coord = @{@"latitude":lat,@"longitude":lng};
        NSMutableDictionary *errorData = [NSMutableDictionary dictionaryWithDictionary:@{@"coordinate":coord}];
        
        // Add error details if available
        if (error) {
            [errorData setObject:@(error.code) forKey:@"code"];
            [errorData setObject:error.localizedDescription forKey:@"message"];
            [errorData setObject:error.domain forKey:@"domain"];
        }
        
        _onError(errorData);
    }
}

- (void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama {
    // Handle panorama change event
    if (_onPanoramaChange && panorama != nil) {
        NSNumber *lat = [[NSNumber alloc] initWithDouble:panorama.coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc] initWithDouble:panorama.coordinate.longitude];
        NSDictionary *position = @{@"latitude":lat, @"longitude":lng};

        NSMutableDictionary *panoramaData = [NSMutableDictionary dictionary];
        [panoramaData setObject:position forKey:@"position"];

        // Add panorama ID if available
        if (panorama.panoramaID != nil) {
            [panoramaData setObject:panorama.panoramaID forKey:@"panoId"];
        }

        // Add links to nearby panoramas only if available
        if (panorama.links != nil && panorama.links.count > 0) {
            NSMutableArray *linksArray = [NSMutableArray array];
            for (GMSPanoramaLink *link in panorama.links) {
                NSMutableDictionary *linkData = [NSMutableDictionary dictionary];
                [linkData setObject:link.panoramaID forKey:@"panoId"];
                [linkData setObject:@(link.heading) forKey:@"bearing"];
                [linksArray addObject:linkData];
            }
            [panoramaData setObject:linksArray forKey:@"links"];
        }

        _onPanoramaChange(panoramaData);
    }
    
    // Keep existing success callback for backward compatibility
    if (_onSuccess && panorama != nil) {
        NSNumber *lat = [[NSNumber alloc] initWithDouble:panorama.coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc] initWithDouble:panorama.coordinate.longitude];
        NSDictionary *coord = @{@"latitude":lat, @"longitude":lng};
        _onSuccess(@{@"coordinate":coord});
    }
}

- (void)panoramaView:(GMSPanoramaView *)panoramaView didMoveCamera:(GMSPanoramaCamera *)camera {
    // Only send events if the callback is defined
    if (_onPovChange) {
        float tilt = camera.orientation.pitch;
        float bearing = camera.orientation.heading;
        float zoom = camera.zoom;

        // Check if change exceeds thresholds
        float bearingDiff = fabs(bearing - lastBearing);
        bearingDiff = MIN(bearingDiff, fabs(bearingDiff - 360));

        BOOL significantChange = 
            fabs(tilt - lastTilt) > TILT_THRESHOLD ||
            bearingDiff > BEARING_THRESHOLD ||
            fabs(zoom - lastZoom) > ZOOM_THRESHOLD;

        if (significantChange) {
            // Update last known values
            lastTilt = tilt;
            lastBearing = bearing;
            lastZoom = zoom;

            // Create POV data object
            NSDictionary *povData = @{
                @"tilt": @(tilt),
                @"bearing": @(bearing),
                @"zoom": @(zoom)
            };

            // Send the event
            _onPovChange(povData);
        }
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
    [self animateToCamera:camera animationDuration:1.0];
}

- (void)moveNearCoordinate:(CLLocationCoordinate2D)coordinate radius:(NSUInteger)radius {
    // Use the appropriate source based on outdoorOnly flag
    GMSPanoramaSource source = self.outdoorOnly ? kGMSPanoramaSourceOutside : kGMSPanoramaSourceDefault;

    // call the super implementation
    [super moveNearCoordinate:coordinate radius:radius source:source];
}

@end
