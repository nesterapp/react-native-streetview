
# react-native-streetview

React Native Google's Panorama/StreetView component for iOS and Android.

![](http://i.imgur.com/PTFla6o.png)&emsp;&emsp;![](http://i.imgur.com/O3uzwrC.png)

## Installation

```
npm install react-native-streetview --save
```

Link the native dependencies:

```
react-native link react-native-streetview
```

### iOS

1. Install GoogleMaps SDK for iOS using CocoaPods:
		https://developers.google.com/maps/documentation/ios-sdk/start

2. Specify your Google Maps API Key:
    > Go to https://console.developers.google.com/apis/credentials to check your credentials.
 
   Add your API key to your AppDelegate file:

	```
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		[GMSServices provideAPIKey:@"YOUR-API-KEY-HERE"];
	```

3. Run  
	```
	react-native run-ios && react-native log-ios
	```

### Android
1. Install Google Play services using SDK Manager in Android Studio

2. Specify your Google Maps API Key:
    > Go to https://console.developers.google.com/apis/credentials to check your credentials.

   Add your API key to your manifest file (`android\app\src\main\AndroidManifest.xml`):

   ```xml
   <application>
     <!-- You will only need to add this meta-data tag, but make sure it's a child of application -->
     <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="Your Google maps API Key Here"/>
   </application>
   ```

3. Run  
	```
	react-native run-android && react-native log-android
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

## Roadmap and help?
I had to quickly wrap up this component to have Street View ability in our Home Renting app, [Nester](http://nester.co.il).
So, currently providing only two props that we actually needed.  
There is much to go forward, with camera and heading setup, markers, etc. We will gradually add those in the next releases.
Feel free to fork and submit PR's. We'll really appriciate any effort, especially on Android ;(  

#### Contact
Amit Palomo <amit@nester.co.il>  
Rafael Bodill <rafi@nester.co.il>  

License
--------

     Copyright (c) 2017 Nester.co.il

     Licensed under the The MIT License (MIT) (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

        https://raw.githubusercontent.com/nesterapp/react-native-streetview/master/LICENSE

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.

