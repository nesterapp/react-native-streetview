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
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.events.EventDispatcher;
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
    private LatLng coordinate = null;
    // default value
    private int radius = 50;

    public NSTStreetView(Context context) {
        super(context);
        super.onCreate(null);
        super.onResume();
        super.getStreetViewPanoramaAsync(this);
    }

    @Override
    public void onStreetViewPanoramaReady(StreetViewPanorama panorama) {

        this.panorama = panorama;
        this.panorama.setPanningGesturesEnabled(allGesturesEnabled);

        final EventDispatcher eventDispatcher = ((ReactContext) getContext())
                .getNativeModule(UIManagerModule.class).getEventDispatcher();

        this.panorama.setOnStreetViewPanoramaCameraChangeListener(new StreetViewPanorama.OnStreetViewPanoramaCameraChangeListener() {
            @Override
            public void onStreetViewPanoramaCameraChange(StreetViewPanoramaCamera streetViewPanoramaCamera) {
                if (!(streetViewPanoramaCamera.bearing >= 0 ) && coordinate != null) {
                    eventDispatcher.dispatchEvent(
                            new NSTStreetViewEvent(getId(), NSTStreetViewEvent.ON_ERROR)
                    );
                }
            }
        });

        panorama.setOnStreetViewPanoramaChangeListener(new StreetViewPanorama.OnStreetViewPanoramaChangeListener() {
            @Override
            public void onStreetViewPanoramaChange(StreetViewPanoramaLocation streetViewPanoramaLocation) {
                if (streetViewPanoramaLocation != null && streetViewPanoramaLocation.links != null ) {
                    eventDispatcher.dispatchEvent(
                            new NSTStreetViewEvent(getId(), NSTStreetViewEvent.ON_SUCCESS)
                    );
                } else {
                    eventDispatcher.dispatchEvent(
                            new NSTStreetViewEvent(getId(), NSTStreetViewEvent.ON_ERROR)
                    );
                }
            }
        });
        if (coordinate != null) {
            this.panorama.setPosition(coordinate, radius);
        }
    }

    public void setAllGesturesEnabled(boolean allGesturesEnabled) {
        // Saving to local variable as panorama may not be ready yet (async)
        this.allGesturesEnabled = allGesturesEnabled;
    }

    public void setCoordinate(ReadableMap coordinate) {

        if (coordinate == null ) return;
        Double lng = coordinate.getDouble("longitude");
        Double lat = coordinate.getDouble("latitude");

        // saving radius
        this.radius = coordinate.hasKey("radius") ? coordinate.getInt("radius") : 50;

        // Saving to local variable as panorama may not be ready yet (async)
        this.coordinate = new LatLng(lat, lng);
    }
}
