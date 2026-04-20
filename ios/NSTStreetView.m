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

        // Initialize radius and outdoorOnly defaults
        _lastRadius = 50;  // Default radius
        _outdoorOnly = NO; // Default outdoor setting

        self.delegate = self; // Set delegate to self to receive callbacks
    }
    return self;
}

#pragma mark GMSPanoramaViewDelegate
- (void)panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate {
    if(_onError) {
        NSNumber *lat = [[NSNumber alloc] initWithDouble:coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc] initWithDouble:coordinate.longitude];
        NSDictionary *coord = @{@"latitude":lat,@"longitude":lng};

        // Create a structured error payload similar to Android
        NSMutableDictionary *errorData = [NSMutableDictionary dictionaryWithDictionary:@{
            @"coordinate": coord
        }];

        // Add error message and details
        NSString *message = @"No panorama found at the specified location";

        // Add error details if available
        if (error) {
            message = [NSString stringWithFormat:@"%@: %@", message, error.localizedDescription];
            [errorData setObject:@(error.code) forKey:@"code"];
        }
        
        // Use the stored property instead of trying to access it from panorama
        if (self.outdoorOnly) {
            message = [NSString stringWithFormat:@"%@. You have 'outdoorOnly' enabled", message];

            if (self.lastRadius < 100) {
                message = [NSString stringWithFormat:@"%@ and a small search radius (%ldm)", message, (long)self.lastRadius];
            }

            message = [NSString stringWithFormat:@"%@. Try disabling 'outdoorOnly' or increasing the radius.", message];
        } else if (self.lastRadius < 50) {
            message = [NSString stringWithFormat:@"%@. Try increasing the search radius (currently %ldm).", message, (long)self.lastRadius];
        }

        [errorData setObject:message forKey:@"message"];
        [errorData setObject:@(self.outdoorOnly) forKey:@"outdoorOnly"];
        [errorData setObject:@(self.lastRadius) forKey:@"radius"];

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


- (void)animateToCameraPosition:(GMSPanoramaCamera *)camera {
    [self animateToCamera:camera animationDuration:1.0];
}

- (void)moveNearCoordinate:(CLLocationCoordinate2D)coordinate radius:(NSUInteger)radius {
    // Store the radius for error reporting
    _lastRadius = radius;

    // Use the appropriate source based on outdoorOnly flag
    GMSPanoramaSource source = self.outdoorOnly ? kGMSPanoramaSourceOutside : kGMSPanoramaSourceDefault;

    // call the panorama move method
    [super moveNearCoordinate:coordinate radius:radius source:source];
}

#pragma mark - Teardown

// Two distinct use-after-free bugs exist inside the Google Maps iOS SDK
// (tested against GoogleMaps 9.x) when a GMSPanoramaView is released while
// the user is interacting with it:
//
//   1. RENDER PATH — GMSPanoramaView drives rendering via an internal
//      CADisplayLink. If the view is released before the next vsync, the
//      display link can fire one more -drawFrame into a half-torn-down
//      render graph, crashing at
//      GMSx_geo_imagery_viewer::core::Photo::Traverse.
//
//   2. TILE PATH — GMSRocketTileService dispatches tile downloads on a
//      background queue and does NOT cancel in-flight requests when the
//      view is torn down. When a tile response returns after release, the
//      completion block dereferences a freed
//      GMSx_geo_imagery_viewer::api::RequestContainer, crashing at
//      RequestContainer::OnComplete on a com.apple.root.background-qos
//      dispatch queue.
//
// We mitigate both here:
//
//   • Hiding the view and nil-ing the delegate + RCTDirectEventBlock
//     callbacks causes GMS to invalidate its CADisplayLink and ensures no
//     late delegate callback lands on a dying view or dead JS emitter.
//     This fixes (1).
//
//   • A keep-alive capture for 2s past removal keeps `self` — and
//     therefore GMS's internal RequestContainer owned by this view —
//     alive long enough for any pending tile fetch to complete against a
//     valid object instead of freed memory. This fixes (2). 2s covers a
//     normal tile round-trip; stale requests that take longer will time
//     out cleanly inside GMS.
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        self.hidden = YES;
        self.delegate = nil;
        _onError = nil;
        _onPanoramaChange = nil;
        _onPovChange = nil;

        NSTStreetView *keepAlive = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(2.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            (void)keepAlive;
        });
    }
    [super willMoveToWindow:newWindow];
}

- (void)dealloc {
    // Defensive: the delegate is typically weak, but explicit nil-out here
    // guarantees no in-flight GMS delegate callback dereferences `self` while
    // it is being deallocated.
    self.delegate = nil;
}

@end
