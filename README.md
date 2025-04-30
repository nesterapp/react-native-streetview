# react-native-streetview [![npm version](https://img.shields.io/npm/v/react-native-streetview.svg?style=flat)](https://www.npmjs.com/package/react-native-streetview)

Google's StreetView component for React Native  
(iOS and Android supported)

## Features

- 🌐 Cross-platform Google Street View integration (iOS & Android)
- 🎥 Customizable camera position and point of view (tilt, bearing, zoom)
- 👆 Gesture controls for user interaction
- 🔍 Configurable search radius to find nearby panoramas
- 🏞️ Outdoor-only panorama option
- 📊 Event callbacks for errors, location changes, and camera movements (POV)
- ✅ Compatible with React Native 0.79+ and Fabric architecture

## Preview

<table>
  <tr>
    <td><img width="260" src="assets/streetview-demo.gif" alt="StreetView Demo"></td>
  </tr>
</table>

## Installation

```sh
yarn add react-native-streetview
# or using npm
npm install --save react-native-streetview
```

### API Key Setup
1. Generate an API Key at https://console.developers.google.com/apis/credentials
2. Make sure Google Maps API is enabled in the Google Cloud Console

### iOS

1. Install GoogleMaps SDK for iOS using CocoaPods:
   - Add to your Podfile: `pod 'GoogleMaps'`
   - Run `pod install`
   - For detailed instructions, see: https://developers.google.com/maps/documentation/ios-sdk/config

2. Add your API key to AppDelegate:

```swift
import GoogleMaps

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GMSServices.provideAPIKey("YOUR-API-KEY")
    // ...existing code...
    return true
}
```

### Android

1. Install Google Play services:
   - Open Android Studio's SDK Manager
   - Select and install "Google Play Services" from the SDK Tools tab
   - For detailed instructions, see: https://developers.google.com/maps/documentation/android-sdk/start

2. Add the API key to your app's Manifest file (`android\app\src\main\AndroidManifest.xml`):

   ```xml
   <application>
     <!-- You will only need to add this meta-data tag, but make sure it's a child of application -->
     <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR-API-KEY"/>
   </application>
   ```

## Usage

### Basic Implementation

```javascript
import StreetView from 'react-native-streetview';
import { View, StyleSheet } from 'react-native';

const YourComponent = () => (
  <View style={styles.container}>
    <StreetView
      style={styles.streetView}
      allGesturesEnabled={true}
      coordinate={{
        latitude: 37.7749,
        longitude: -122.4194,
        radius: 50  // Search radius in meters
      }}
    />
  </View>
);
```

### More Examples

<details>
<summary><b>With Camera Position (POV)</b></summary>

```javascript
<StreetView
  style={styles.streetView}
  coordinate={{
    latitude: 37.7749,
    longitude: -122.4194,
    radius: 50
  }}
  pov={{
    tilt: 30,     // Camera tilt angle in degrees (range: 0-90)
    bearing: 90,  // Camera compass direction (range: 0-360, where 0=North, 90=East)
    zoom: 1       // Camera zoom level (range: 0-5)
  }}
/>
```
</details>

<details>
<summary><b>Handling Events</b></summary>

```javascript
<StreetView
  style={styles.streetView}
  coordinate={{
    latitude: 37.7749,
    longitude: -122.4194,
    radius: 50
  }}
  onError={(errorEvent) => {
    // Access detailed error information
    const errorData = errorEvent.nativeEvent;
    console.log('Street View error:', errorData.message);
    // Access additional context for debugging
    if (errorData.outdoorOnly) {
      console.log('Try disabling outdoorOnly or increasing radius');
    }
    // For advanced debugging:
    console.log('Error details:', {
      location: `${errorData.latitude}, ${errorData.longitude}`,
      radius: errorData.radius,
      outdoorOnly: errorData.outdoorOnly
    });
  }}
  onPanoramaChange={(event) => {
    // When user navigates to a new panorama location
    const { position } = event.nativeEvent;
    const { panoId } = event.nativeEvent;
    console.log('Panorama changed to new location:', {
      latitude: position.latitude,
      longitude: position.longitude
    });
    // On iOS, may include additional Street View metadata
    if (panoId) {
      console.log('Panorama ID:', panoId);
    }
  }}
  onPovChange={(event) => {
    // When camera orientation changes
    const povData = event.nativeEvent;
    console.log('Camera view changed:');
    console.log('Bearing (direction):', povData.bearing);
    console.log('Tilt (angle):', povData.tilt);
    console.log('Zoom level:', povData.zoom);
    
    // * Only triggered when changes exceed threshold values
    // to avoid excessive updates during smooth camera movements
  }}
/>
```
</details>

<details>
<summary><b>Outdoor Only Panoramas</b></summary>

```javascript
<StreetView
  style={styles.streetView}
  coordinate={{
    latitude: 37.7749,
    longitude: -122.4194,
    radius: 100
  }}
  outdoorOnly={true}
/>
```
</details>

## Props

| Prop | Type | Default | Description |
|---|---|---|---|
| **Location** |  |  |  |
| `coordinate` | Object | `null` | Specify the latitude and longitude of the streetview location |
| `coordinate.latitude` | Number | `0` | Latitude |
| `coordinate.longitude` | Number | `0` | Longitude |
| `coordinate.radius` | Number | `50` | Search radius in meters around the specified location. If no panorama is found at the exact coordinates, Google Street View will search for the closest panorama within this radius. |
| **Display Options** |  |  |  |
| `outdoorOnly` | Boolean | `false` | When true, limits Street View searches to outdoor panoramas only |
| `streetNamesHidden` | Boolean | `false` | Whether to hide street names overlay |
| **Camera** |  |  |  |
| `pov` | Object | `null` | Camera point of view |
| `pov.tilt` | Number | `0` | Camera tilt angle in degrees (0-90) |
| `pov.bearing` | Number | `0` | Camera compass direction (0-360). 0 = north, 90 = east |
| `pov.zoom` | Number | `0` | Camera zoom level (0-5) |
| **Gesture Controls** |  |  |  |
| `allGesturesEnabled` | Boolean | `true` | Whether to enable all user gestures (panning, zooming, and navigation) |
| `orientationGestures` | Boolean | `true` | Whether to enable panning gestures to change camera orientation |
| `zoomGestures` | Boolean | `true` | Whether to enable pinch gestures to zoom the camera |
| `navigationGestures` | Boolean | `true` | Whether to enable tap gestures to navigate between panoramas |
| `navigationLinksHidden` | Boolean | `false` | Whether to hide the navigation links (iOS only) |
| **Events** |  |  |  |
| `onError` | Function | `null` | Callback when panorama cannot be found or errors occur |
| `onPanoramaChange` | Function | `null` | Callback when the panorama view changes to a new location |
| `onPovChange` | Function | `null` | Callback when the Point of View (camera orientation) changes |

## Troubleshooting

### No panoramas found
- Ensure coordinates are in an area covered by Google Street View
- Try increasing the search radius
- Check if your API key has StreetView API enabled

### Black screen issues
- Verify your API key is correctly added to both platforms
- For React Navigation users, add margins to the StreetView component as mentioned in the usage notes
- Ensure the component has a proper size

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## About

This component was originally developed for [Nester](http://nester.co.il), a home rental application requiring Google Street View integration.

## Contact & Support

For questions, issues, or feature requests, please contact:

- Amit Palomo - [apalgm@gmail.com](mailto:apalgm@gmail.com)
- [Open an issue](https://github.com/nesterapp/react-native-streetview/issues)

License
--------

MIT
