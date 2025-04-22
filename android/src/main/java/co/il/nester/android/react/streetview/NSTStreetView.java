/**
 * NSTStreetView.java
 * 
 * Street View component for React Native (Android implementation)
 */

package co.il.nester.android.react.streetview;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.google.android.gms.maps.OnStreetViewPanoramaReadyCallback;
import com.google.android.gms.maps.StreetViewPanorama;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.StreetViewPanoramaView;
import com.google.android.gms.maps.model.StreetViewPanoramaCamera;
import com.google.android.gms.maps.model.StreetViewPanoramaLocation;
import com.google.android.gms.maps.model.StreetViewSource;

import android.content.Context;

public class NSTStreetView extends StreetViewPanoramaView implements OnStreetViewPanoramaReadyCallback {

    private StreetViewPanorama panorama;
    private Boolean allGesturesEnabled = true;
    private Boolean streetNamesHidden = false;
    private LatLng coordinate = null;
    // default values
    private int radius = 50;
    private float tilt = 0;
    private float bearing = 0;
    private Integer zoom = 0;
    private Boolean started = false;
    private Boolean outdoorOnly = false;

    // Properties for listeners existence check
    private boolean hasPovChangeListener = false;
    private boolean hasPanoramaChangeListener = false;
    private boolean hasErrorListener = false;
    private boolean hasSuccessListener = false;

    // Properties for tracking and thresholds
    private double lastTilt = 0;
    private double lastBearing = 0; 
    private double lastZoom = 0;
    private final double TILT_THRESHOLD = 0.5;    // degrees
    private final double BEARING_THRESHOLD = 0.5; // degrees
    private final double ZOOM_THRESHOLD = 0.1;    // zoom level

    public NSTStreetView(Context context) {
        super(context);
        super.onCreate(null);
        super.onResume();
        super.getStreetViewPanoramaAsync(this);
    }

    private final Runnable measureAndLayout = new Runnable() {
        @Override
        public void run() {
          measure(
              MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY),
              MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY));
          layout(getLeft(), getTop(), getRight(), getBottom());
        }
      };

    @Override
    public void requestLayout() {
      super.requestLayout();

      // Required for correct requestLayout
      // H/T https://github.com/facebook/react-native/issues/4990#issuecomment-180415510
      post(measureAndLayout);
    }

    @Override
    public void onStreetViewPanoramaReady(StreetViewPanorama panorama) {
        this.panorama = panorama;
        this.panorama.setPanningGesturesEnabled(allGesturesEnabled);
        this.panorama.setStreetNamesEnabled(!streetNamesHidden);

        Context context = getContext();
        ReactContext reactContext = (ReactContext)context;

        // Listener for camera (POV) changes
        this.panorama.setOnStreetViewPanoramaCameraChangeListener(new StreetViewPanorama.OnStreetViewPanoramaCameraChangeListener() {
            @Override
            public void onStreetViewPanoramaCameraChange(StreetViewPanoramaCamera camera) {
                // Only send the event if someone is listening for onPovChange
                if (hasPovChangeListener) {
                    // Check if change exceeds thresholds
                    double bearing1 = Math.abs(camera.bearing - lastBearing);
                    double bearing2 = Math.abs(camera.bearing - lastBearing + 360);
                    double bearing3 = Math.abs(camera.bearing - lastBearing - 360);

                    // Use nested Math.min calls to get the minimum of three values
                    double minBearingDiff = Math.min(Math.min(bearing1, bearing2), bearing3);
                    boolean bearingChanged = minBearingDiff > BEARING_THRESHOLD;

                    boolean significantChange = 
                        Math.abs(camera.tilt - lastTilt) > TILT_THRESHOLD ||
                        bearingChanged ||
                        Math.abs(camera.zoom - lastZoom) > ZOOM_THRESHOLD;

                    if (significantChange) {
                        // Update last known values
                        lastTilt = camera.tilt;
                        lastBearing = camera.bearing;
                        lastZoom = camera.zoom;

                        WritableMap povData = Arguments.createMap();
                        povData.putDouble("tilt", camera.tilt);
                        povData.putDouble("bearing", camera.bearing);
                        povData.putDouble("zoom", camera.zoom);

                        reactContext.getJSModule(RCTEventEmitter.class)
                            .receiveEvent(getId(), "onPovChange", povData);
                    }
                }
            }
        });

        // Listener for panorama changes
        panorama.setOnStreetViewPanoramaChangeListener(new StreetViewPanorama.OnStreetViewPanoramaChangeListener() {
            @Override
            public void onStreetViewPanoramaChange(StreetViewPanoramaLocation location) {
                ReactContext reactContext = (ReactContext) getContext();

                if (location != null) {
                    // Only create position data if we need it
                    WritableMap position = null;

                    // Send panorama change event only if listener exists
                    if (hasPanoramaChangeListener) {
                        WritableMap panoramaData = Arguments.createMap();
                        panoramaData.putString("panoId", location.panoId);

                        position = Arguments.createMap();
                        position.putDouble("latitude", location.position.latitude);
                        position.putDouble("longitude", location.position.longitude);
                        panoramaData.putMap("position", position);

                        reactContext.getJSModule(RCTEventEmitter.class)
                            .receiveEvent(getId(), "onPanoramaChange", panoramaData);
                    }
                    
                    // Keep existing onSuccess for backward compatibility, but only if listener exists
                    if (hasSuccessListener) {
                        WritableMap successData;
                        if (position != null) {
                            // Reuse the position object we created above
                            successData = position;
                        } else {
                            successData = Arguments.createMap();
                            successData.putDouble("latitude", location.position.latitude);
                            successData.putDouble("longitude", location.position.longitude);
                        }
                        reactContext.getJSModule(RCTEventEmitter.class)
                            .receiveEvent(getId(), "onSuccess", successData);
                    }
                } else if (hasErrorListener) {
                    // Create minimal error payload with useful diagnostics
                    WritableMap errorData = Arguments.createMap();
                    String errorMessage = "No panorama found at the specified location";
                    
                    // Add helpful suggestions based on current settings
                    if (outdoorOnly) {
                        errorMessage += ". You have 'outdoorOnly' enabled";
                        
                        if (radius < 100) {
                            errorMessage += " and a small search radius (" + radius + "m)";
                        }
                        
                        errorMessage += ". Try disabling 'outdoorOnly' or increasing the radius.";
                    } else if (radius < 50) {
                        errorMessage += ". Try increasing the search radius (currently " + radius + "m).";
                    }
                    
                    errorData.putString("message", errorMessage);
                    
                    if (coordinate != null) {
                        // Include coordinates in a flattened structure to keep payload minimal
                        errorData.putDouble("latitude", coordinate.latitude);
                        errorData.putDouble("longitude", coordinate.longitude);
                        errorData.putInt("radius", radius);
                        errorData.putBoolean("outdoorOnly", outdoorOnly);
                    }
                    
                    reactContext.getJSModule(RCTEventEmitter.class)
                        .receiveEvent(getId(), "onError", errorData);
                }
            }
        });

        if (coordinate != null) {
            StreetViewSource source = outdoorOnly ? StreetViewSource.OUTDOOR : StreetViewSource.DEFAULT;
            this.panorama.setPosition(coordinate, radius, source);
        }

       long duration = 1000;
       if (bearing >= 0 && this.started) {
             StreetViewPanoramaCamera camera = new StreetViewPanoramaCamera.Builder()
           .zoom(zoom)
           .tilt(tilt)
           .bearing(bearing)
           .build();
             panorama.animateTo(camera,duration);
        }
        this.started = true;
    }

    public void setAllGesturesEnabled(boolean allGesturesEnabled) {
        // Saving to local variable as panorama may not be ready yet (async)
        this.allGesturesEnabled = allGesturesEnabled;
    }

    public void setStreetNamesHidden(boolean streetNamesHidden) {
        this.streetNamesHidden = streetNamesHidden;
    }

    public void setCoordinate(ReadableMap coordinate) {
        if (coordinate == null ) return;
        Double lng = coordinate.getDouble("longitude");
        Double lat = coordinate.getDouble("latitude");

        // saving radius
        this.radius = coordinate.hasKey("radius") ? coordinate.getInt("radius") : 50;

        // Saving to local variable as panorama may not be ready yet (async)
        this.coordinate = new LatLng(lat, lng);
         if (this.coordinate != null && this.started  ) {
            StreetViewSource source = outdoorOnly ? StreetViewSource.OUTDOOR : StreetViewSource.DEFAULT;
            this.panorama.setPosition(this.coordinate, this.radius, source);
         }
    }

    public void setPov(ReadableMap pov) {
        if (pov == null ) return;
        tilt = (float) pov.getDouble("tilt");
        bearing = (float) pov.getDouble("bearing");
        zoom = pov.getInt("zoom");

        long duration = 1000;
        if (bearing >= 0 && this.started) {
            StreetViewPanoramaCamera camera = new StreetViewPanoramaCamera.Builder()
            .zoom(zoom)
            .tilt(tilt)
            .bearing(bearing)
            .build();
            panorama.animateTo(camera,duration);
        }
    }

    public void setOutdoorOnly(boolean outdoorOnly) {
        this.outdoorOnly = outdoorOnly;
        // If panorama is already initialized, update the position with the new source
        if (this.panorama != null && this.coordinate != null) {
            StreetViewSource source = outdoorOnly ? StreetViewSource.OUTDOOR : StreetViewSource.DEFAULT;
            this.panorama.setPosition(this.coordinate, this.radius, source);
        }
    }

    // Add these setter methods
    public void setHasPovChangeListener(boolean hasListener) {
        this.hasPovChangeListener = hasListener;
    }

    public void setHasPanoramaChangeListener(boolean hasListener) {
        this.hasPanoramaChangeListener = hasListener;
    }

    public void setHasErrorListener(boolean hasListener) {
        this.hasErrorListener = hasListener;
    }

    public void setHasSuccessListener(boolean hasListener) {
        this.hasSuccessListener = hasListener;
    }
}
