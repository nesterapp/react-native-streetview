
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
Prop                  | Type     | Default              | Description
--------------------- | -------- | -------------------- | -----------
allGesturesEnabled    | bool     | true               | Enables user interaction (orientation, zoom, navigation)
coordinate            | shape | null                     |  Request panorama near the coordinate
radius                | number   | 50                     |  Specify a search radius, in meters, around the coordinate
streetNamesHidden     | bool     | false                  |  Remove street names from the map

## Example

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
There is much to go forward, with camera and heading setup, markers, etc. We will gradually add those in the next releases.
Feel free to fork and submit PR's. We'll really appreciate any effort, especially on Android ;(  

#### Contact
Amit Palomo <amit@nester.co.il>  
Rafael Bodill <rafi@nester.co.il>  

License
--------

     Copyright (c) 2023 Nester.co.il

     Licensed under the The MIT License (MIT) (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

        https://raw.githubusercontent.com/nesterapp/react-native-streetview/master/LICENSE

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
