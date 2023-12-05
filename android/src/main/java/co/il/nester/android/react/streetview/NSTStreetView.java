//
//  NSTStreetView.java
//  react-native-streetview
//
//  Created by Amit Palomo on 26/04/2017.
//  Copyright © 2017 Nester.co.il.
//


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

import android.content.Context;

public class NSTStreetView extends StreetViewPanoramaView implements OnStreetViewPanoramaReadyCallback {

    private StreetViewPanorama panorama;
    private Boolean allGesturesEnabled = true;
    private Boolean streetNamesHidden = false;
    private LatLng coordinate = null;
    // default value
    private int radius = 50;
    private float tilt = 0 ;
    private float bearing = 0 ;
    private Integer zoom = 1;
    private Boolean started = false;

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

        this.panorama.setOnStreetViewPanoramaCameraChangeListener(new StreetViewPanorama.OnStreetViewPanoramaCameraChangeListener() {
            @Override
            public void onStreetViewPanoramaCameraChange(StreetViewPanoramaCamera streetViewPanoramaCamera) {
                if (!(streetViewPanoramaCamera.bearing >= 0 ) && coordinate != null) {
                    reactContext.getJSModule(RCTEventEmitter.class)
                        .receiveEvent(getId(), "onError", null);
                }
            }
        });

        panorama.setOnStreetViewPanoramaChangeListener(new StreetViewPanorama.OnStreetViewPanoramaChangeListener() {
            @Override
            public void onStreetViewPanoramaChange(StreetViewPanoramaLocation streetViewPanoramaLocation) {
                if (streetViewPanoramaLocation != null) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("latitude", streetViewPanoramaLocation.position.latitude);
                    map.putDouble("longitude", streetViewPanoramaLocation.position.longitude);
                    reactContext.getJSModule(RCTEventEmitter.class)
                        .receiveEvent(getId(), "onSuccess", map);
                } else {
                    reactContext.getJSModule(RCTEventEmitter.class)
                        .receiveEvent(getId(), "onError", null);
                }
            }
        });

        if (coordinate != null) {
            this.panorama.setPosition(coordinate, radius);
        }

       long duration = 1000;
       if (bearing > 0) {
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
            this.panorama.setPosition(this.coordinate, this.radius);
         }
    }
    public void setPov(ReadableMap pov) {

        if (pov == null ) return;
        tilt = (float) pov.getDouble("tilt");
        bearing = (float) pov.getDouble("bearing");
        zoom = pov.getInt("zoom");

        long duration = 1000;
         if (bearing > 0 && this.started) {
             StreetViewPanoramaCamera camera = new StreetViewPanoramaCamera.Builder()
             .zoom(zoom)
             .tilt(tilt)
             .bearing(bearing)
             .build();
             panorama.animateTo(camera,duration);
          }

    }
}
