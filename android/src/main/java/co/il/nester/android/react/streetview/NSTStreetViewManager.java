/**
 * NSTStreetViewManager.java
 * 
 * Street View component manager for React Native (Android implementation)
 */

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

    @ReactProp(name = "streetNamesHidden", defaultBoolean = false)
    public void setStreetNamesEnabled(NSTStreetView view, boolean streetNamesHidden) {
        view.setStreetNamesHidden(streetNamesHidden);
    }

    @ReactProp(name = "coordinate")
    public void setCoordinate(NSTStreetView view, ReadableMap coordinate) {
        view.setCoordinate(coordinate);
    }

    @ReactProp(name = "pov")
    public void setPov(NSTStreetView view, ReadableMap pov) {
        view.setPov(pov);
    }

    @ReactProp(name = "outdoorOnly", defaultBoolean = false)
    public void setOutdoorOnly(NSTStreetView view, boolean outdoorOnly) {
        view.setOutdoorOnly(outdoorOnly);
    }

    @Override
    public @Nullable
    Map getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.builder()
            .put("onSuccess", MapBuilder.of("registrationName", "onSuccess"))
            .put("onError", MapBuilder.of("registrationName", "onError"))
            .build();
    }
}
