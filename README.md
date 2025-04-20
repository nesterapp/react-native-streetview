# react-native-streetview [![npm version](https://img.shields.io/npm/v/react-native-streetview.svg?style=flat)](https://www.npmjs.com/package/react-native-streetview)

Google's StreetView component for React Native  
(iOS and Android supported)

## Installation

On your app's root folder run
```sh
yarn add react-native-streetview
```

### iOS

1. Install GoogleMaps SDK for iOS using CocoaPods:
		https://developers.google.com/maps/documentation/ios-sdk/start

2. Add your API key to AppDelegate:
    > Go to https://console.developers.google.com/apis/credentials to check your credentials.

	```objc
  import GoogleMaps
  
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		[GMSServices provideAPIKey:@"YOUR-API-KEY-HERE"];
	```

### Android
1. Install Google Play services using SDK Manager in Android Studio (once for all your apps)

2. Generate an a new API Key. see https://console.developers.google.com/apis/credentials
   Make sure Google Maps API is enabled.

3. Add the API key to your app's Manifest file (`android\app\src\main\AndroidManifest.xml`):

   ```xml
   <application>
     <!-- You will only need to add this meta-data tag, but make sure it's a child of application -->
     <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR-API-KEY-HERE"/>
   </application>
   ```

## Usage

### Import
```javascript
import StreetView from 'react-native-streetview';
```

### Add StreetView component
```javascript
<View style={styles.container}>
  <StreetView
    style={styles.streetView}
    allGesturesEnabled={true}
    coordinate={{
      'latitude': -33.852,
      'longitude': 151.211
    }}
    pov={{
	tilt:parseFloat(0),
	bearing:parseFloat(0),
	zoom:parseInt(1)
    }}
  />
</View>
```

### Use position absolute for layout
```javascript
const styles = StyleSheet.create({
  container: {
    flex: 1
  },
  streetView: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
});
```
> Notice: if you are using [react-navigation](https://github.com/react-navigation/react-navigation). There is a known bug where a black window appears upon dismissal
of StreetView's container screen - if it was deployed on full screen.
A workaround solution is to bound StreetView with some margins.
See [issue 12](https://github.com/nesterapp/react-native-streetview/issues/12)

## Properties

| Prop | Type | Default | Description |
|---|---|---|---|
| `coordinate` | Object | `null` | Specify the latitude and longitude of the streetview location |
| `coordinate.latitude` | Number | `0` | Latitude |
| `coordinate.longitude` | Number | `0` | Longitude |
| `coordinate.radius` | Number | `50` | Search radius in meters |
| `pov` | Object | `null` | Camera point of view |
| `pov.tilt` | Number | `0` | Camera tilt angle in degrees (0-90) |
| `pov.bearing` | Number | `0` | Camera compass direction (0-360). 0 = north, 90 = east |
| `pov.zoom` | Number | `1` | Camera zoom level (0-3) |
| `heading` | Number | `0` | **Deprecated:** Use `pov.bearing` instead. Camera direction in degrees |
| `allGesturesEnabled` | Boolean | `true` | Whether to enable user gestures |
| `streetNamesHidden` | Boolean | `false` | Whether to hide street names |

## Example

```javascript
import StreetView from 'react-native-streetview';

<StreetView
  style={{flex: 1}}
  coordinate={{
    latitude: 37.7749,
    longitude: -122.4194,
    radius: 50
  }}
  pov={{
    tilt: 30,
    bearing: 90,
    zoom: 1
  }}
/>
```

The 'example' folder contains a fully working example for iOS and Android.  

### iOS:

Edit `example/ios/example/AppDelegate.m` and add your API key at:
`[GMSServices provideAPIKey:@"YOUR-API-KEY-HERE"];`

And run
```sh
$ cd example
$ yarn
$ cd ios
$ pod install
$ cd ..
$ npx react-native run-ios
```

### Android:

Edit AndroidManifest.xml (in example/android/app/src/main)  
Add your API key under:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR-API-KEY-HERE" />
```


Then run
```sh
$ cd example
$ yarn
$ npx react-native run-android
```

## Roadmap and help?
This component was built to have Street View ability in our Home Renting app, [Nester](http://nester.co.il).

#### Contact
Amit Palomo <apalgm@gmail.com>  

License
--------

MIT
