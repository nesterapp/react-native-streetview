
# react-native-streetview

React Native Google's Panorama/StreetView component for iOS and Android.

![](http://i.imgur.com/PTFla6o.png)&emsp;&emsp;![](http://i.imgur.com/O3uzwrC.png)

## Installation

```
yarn add react-native-streetview
```

Link the native dependencies:

```
react-native link react-native-streetview
```

### iOS

1. Install GoogleMaps SDK for iOS using CocoaPods:
		https://developers.google.com/maps/documentation/ios-sdk/start

2. Add your API key to AppDelegate:
    > Go to https://console.developers.google.com/apis/credentials to check your credentials.

	```
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		[GMSServices provideAPIKey:@"YOUR-API-KEY-HERE"];
	```

### Android
1. Install Google Play services using SDK Manager in Android Studio

2. Add your API key to Manifest file (`android\app\src\main\AndroidManifest.xml`):
    > Go to https://console.developers.google.com/apis/credentials to check your credentials.

   ```xml
   <application>
     <!-- You will only need to add this meta-data tag, but make sure it's a child of application -->
     <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR-API-KEY-HERE"/>
   </application>
   ```

>This installation should work in physical devices and iOS Simulator. For Genymotion, be sure to check Android installation about Google Play Services

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

## Example

The 'example' folder contains a fully working example for iOS and Android.  
To run the example on iOS do the following:  

```
$ cd example
$ yarn
$ cd ios
$ pod install
```

Edit AppDelegate.m to add your API key:
`[GMSServices provideAPIKey:@"YOUR-API-KEY-HERE"];`

```
$ react-native run-ios
```

To run the example on Android do the following:

```
$ cd example
$ yarn
```

Edit AndroidManifest.xml to add your API key:
`android:value="YOUR-API-KEY-HERE"/>`

```
$ react-native run-android
```

## Roadmap and help?
This component was built to have Street View ability in our Home Renting app, [Nester](http://nester.co.il).
There is much to go forward, with camera and heading setup, markers, etc. We will gradually add those in the next releases.
Feel free to fork and submit PR's. We'll really appriciate any effort, especially on Android ;(  

#### Contact
Amit Palomo <amit@nester.co.il>  
Rafael Bodill <rafi@nester.co.il>  

License
--------

     Copyright (c) 2018 Nester.co.il

     Licensed under the The MIT License (MIT) (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

        https://raw.githubusercontent.com/nesterapp/react-native-streetview/master/LICENSE

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
