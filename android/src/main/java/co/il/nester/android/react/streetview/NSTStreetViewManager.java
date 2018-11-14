//
//  NSTStreetViewManager.java
//  react-native-streetview
//
//  Created by Amit Palomo on 26/04/2017.
//  Copyright © 2017 Nester.co.il.
//

package co.il.nester.android.react.streetview;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

import javax.annotation.Nullable;

public class NSTStreetViewManager extends SimpleViewManager<NSTStreetView> {

    public static final String REACT_CLASS = "NSTStreetView";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected NSTStreetView createViewInstance(ThemedReactContext themedReactContext) {
        return new NSTStreetView(themedReactContext);
    }

    @ReactProp(name = "allGesturesEnabled", defaultBoolean = false)
    public void setAllGesturesEnabled(NSTStreetView view, boolean allGesturesEnabled) {
        view.setAllGesturesEnabled(allGesturesEnabled);
    }

    @ReactProp(name = "coordinate")
    public void setCoordinate(NSTStreetView view, ReadableMap coordinate) {
        view.setCoordinate(coordinate);
    }
    @ReactProp(name = "pov")
        public void setPov(NSTStreetView view, ReadableMap pov) {
            view.setPov(pov);
        }

    @Override
    public @Nullable
    Map getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.of(
                NSTStreetViewEvent.eventNameForType(NSTStreetViewEvent.ON_ERROR), MapBuilder.of("registrationName", "onStreetViewError"),
                NSTStreetViewEvent.eventNameForType(NSTStreetViewEvent.ON_SUCCESS), MapBuilder.of("registrationName", "onStreetViewSuccess")
        );
    }
}
