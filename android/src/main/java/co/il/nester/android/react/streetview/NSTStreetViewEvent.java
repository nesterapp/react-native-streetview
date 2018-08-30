package co.il.nester.android.react.streetview;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;

public class NSTStreetViewEvent extends Event<NSTStreetViewEvent> {

    public static final int ON_ERROR = 1;
    public static final int ON_SUCCESS = 2;

    private final int mEventType;
    private WritableMap mMap;

    public NSTStreetViewEvent(int viewId, int eventType) {
        super(viewId);
        mEventType = eventType;
        mMap = null;
    }

    public static String eventNameForType(int eventType) {
        switch (eventType) {
            case ON_ERROR:
                return "photoViewError";
            case ON_SUCCESS:
                return "photoViewLoad";
            default:
                throw new IllegalStateException("Invalid image event: " + Integer.toString(eventType));
        }
    }

    public String getEventName() {
        return NSTStreetViewEvent.eventNameForType(mEventType);
    }

    @Override
    public void dispatch(RCTEventEmitter rctEventEmitter) {
        rctEventEmitter.receiveEvent(getViewTag(), getEventName(), mMap);
    }
}
