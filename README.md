
# react-native-streetview

React Native Google's Panorama/StreetView component for iOS and Android.

![](http://i.imgur.com/PTFla6o.png)&emsp;&emsp;![](http://i.imgur.com/O3uzwrC.png)

## Installation

Download the library from npm:

```
npm install react-native-streetview --save
```

Link the native dependencies:

```
react-native link react-native-streetview
```

   >This installation should work in physical devices and iOS Simulator. For Genymotion, be sure to check Android installation about Google Play Services

### iOS

1. First, follow Google instructions for installing GoogleMaps SDK for iOS:
		https://developers.google.com/maps/documentation/ios-sdk/start

	It's important you add the API key to your application's app delegate. don't skip this part.

2. Now, set GoogleMaps SDK dir on search path for NSTStreetView library target:  
	a. On your project tree, expand 'Libraries' group.  
	b. Click NSTStreetView.xcodeproj (which was linked to your project with `react-native link react-native-streetview`).  
	c. Choose 'Build Settings' tab.  
	d. Edit 'Framework Search Paths'. Replace &lt;GOOGLE-MAPS-DIR&gt; with your own directory location for GoogleMaps SDK (which you installed on step 1).  

3. Follow JS usage below and hit  
	```
	react-native run-ios && react-native log-ios
	```

### Android
1. Specify your Google Maps API Key:
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

2. Follow JS usage below and hit  
	```
	react-native run-android && react-native log-android
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
	/>
</View>
```

### Use position absolute for layout
```javascript
const styles = StyleSheet.create({
	container: {
		height: 400
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
I had to quickly wrap up this component to have Street View ability in our Home renting app, [Nester](http://nester.co.il).
So, currently providing only two props that we needed.  
There is much to go forward, with camera and heading setup, markers, etc. We will gradually add those in the next releases.
Feel free to fork and submit PR's. We will really appriciate any effort, especially on Android ;(  

#### Contact
Amit Palomo <amit@nester.co.il>  
Rafael Bodill <rafi@nester.co.il>  
© 2017 Nester.co.il
